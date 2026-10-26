# Tổng hợp tử vong CN_399–CN_403

Đã đọc `z_docs/dashboard/autogen/CN399_403.xlsx` và schema `emr_datalake` trên MariaDB (cùng instance, schema `emr_datalake`).

Một fact. Các màn cùng nguồn `medical_records`, cùng cửa sổ `DATE(dead_date)`, cùng phép `COUNT` hồ sơ có `treatment_result_id` thuộc `5` hoặc `8`. Dashboard chỉ khác `GROUP BY`.

| Fact | Màn | Grain |
|---|---|---|
| `emr_db_tong_hop_tu_vong` | CN_399, CN_400, CN_401, CN_402, CN_403 | cơ sở + ngày tử vong + giới tính + hình thức + nơi tử vong + nhóm tuổi |

`noi_tu_vong` = `TRIM(cats_death_places.name_vi)`, nối `medical_records.death_place_code = cats_death_places.code_vi`. `death_place_code` trên hồ sơ là `varchar(11)`. Hồ sơ chưa có mã, hoặc mã không có trong danh mục, thì tên để rỗng. Không lọc `is_delete` của danh mục để giữ tên cũ. Grain nhóm theo `death_place_code`, không theo tên. Mã `code_vi` khác NULL không trùng trên danh mục.

`ngay_tu_vong` = `DATE(medical_records.dead_date)`. Hồ sơ không có ngày tử vong không vào fact. `so_luot` là số hồ sơ, dashboard `SUM`.

Nhóm tuổi là số năm tròn `TIMESTAMPDIFF(YEAR, birthday, dead_date)`: `0-6`, `7-12`, `13-18`, `19-40`, `41-60`, `Trên 60`. Thiếu ngày sinh hoặc ngày chết trước ngày sinh thì `Không xác định`. Excel chỉ ghi hiệu hai ngày, không ghi mốc. Mốc lấy theo nhóm tuổi đang dùng trong bộ dashboard (màn KSK).

`ma_csyt` = `medical_records.healthfacilities_id`. `ma_tinh`, `ten_tinh`, `ma_xa`, `ten_xa`, `ten_csyt`, `tuyen_csyt`, `hang_csyt` có cột trên fact và để trống. Ba cột chỉ tiêu để trống.

Khóa xóa-ghi: `(ma_csyt, ngay_tu_vong)` trên `emr_db_changed_death_pair`. `prepare` quét `update_date` của `medical_records`. `commit` khi job thành công. Thứ Hai quét thêm 45 ngày `dead_date`.

DAG: `EMR_DASHBOARD_DEATH_MASTER_DAG`, lịch `0 5 * * *`. Không gắn vào DAG thuốc.

## SQL select dashboard

Cửa sổ `ngay_tu_vong >= :from_date AND ngay_tu_vong < :to_date`. Bỏ điều kiện khi tham số tương ứng là NULL.

CN_399 — `emr_db_tong_hop_tu_vong`

```sql
SELECT gioi_tinh,
       SUM(so_luot) AS so_luot
FROM emr_db_tong_hop_tu_vong
WHERE ngay_tu_vong >= :from_date
  AND ngay_tu_vong < :to_date
  AND (:ma_csyt IS NULL OR ma_csyt = :ma_csyt)
  AND (:thang IS NULL OR thang = :thang)
  AND (:nam IS NULL OR nam = :nam)
GROUP BY gioi_tinh
```

CN_400 — `emr_db_tong_hop_tu_vong`

```sql
SELECT noi_tu_vong,
       SUM(so_luot) AS so_luot
FROM emr_db_tong_hop_tu_vong
WHERE ngay_tu_vong >= :from_date
  AND ngay_tu_vong < :to_date
  AND (:ma_csyt IS NULL OR ma_csyt = :ma_csyt)
  AND (:thang IS NULL OR thang = :thang)
  AND (:nam IS NULL OR nam = :nam)
GROUP BY noi_tu_vong
```

CN_401 — `emr_db_tong_hop_tu_vong`

```sql
SELECT hinh_thuc_tu_vong,
       SUM(so_luot) AS so_luot
FROM emr_db_tong_hop_tu_vong
WHERE ngay_tu_vong >= :from_date
  AND ngay_tu_vong < :to_date
  AND (:ma_csyt IS NULL OR ma_csyt = :ma_csyt)
  AND (:thang IS NULL OR thang = :thang)
  AND (:nam IS NULL OR nam = :nam)
GROUP BY hinh_thuc_tu_vong
```

CN_402 — `emr_db_tong_hop_tu_vong`

```sql
SELECT nam,
       thang,
       SUM(so_luot) AS so_luot
FROM emr_db_tong_hop_tu_vong
WHERE ngay_tu_vong >= :from_date
  AND ngay_tu_vong < :to_date
  AND (:ma_csyt IS NULL OR ma_csyt = :ma_csyt)
  AND (:thang IS NULL OR thang = :thang)
  AND (:nam IS NULL OR nam = :nam)
GROUP BY nam, thang
ORDER BY nam, thang
```

CN_403 — `emr_db_tong_hop_tu_vong`

```sql
SELECT nhom_tuoi,
       SUM(so_luot) AS so_luot
FROM emr_db_tong_hop_tu_vong
WHERE ngay_tu_vong >= :from_date
  AND ngay_tu_vong < :to_date
  AND (:ma_csyt IS NULL OR ma_csyt = :ma_csyt)
  AND (:thang IS NULL OR thang = :thang)
  AND (:nam IS NULL OR nam = :nam)
GROUP BY nhom_tuoi
ORDER BY FIELD(nhom_tuoi, '0-6', '7-12', '13-18', '19-40', '41-60', 'Trên 60', 'Không xác định')
```

## Việc người dùng chạy

1. Trên lake: job đọc `medical_records.death_place_code` (`varchar(11)`), nối `cats_death_places.code_vi`. Pipeline không tạo cột này.
2. Trên warehouse: fact trong `pipeline/sql/DDL_cac_bang_dich.sql` (bảng mới dùng `CREATE TABLE IF NOT EXISTS`; bảng đã tạo thì `ALTER ... ADD COLUMN IF NOT EXISTS noi_tu_vong`). Bảng khóa trong `pipeline/sql/DDL_cac_bang_key_pair.sql`.
3. Trên nguồn (không sửa dữ liệu): `medical_records` đã có `idx_mr_update_date`. Chưa có index `(healthfacilities_id, dead_date)`. Nên tạo index đó trước khi bật DAG, vì job đọc lại theo cặp cơ sở + ngày tử vong và thứ Hai quét `dead_date`.
4. Airflow variable: `var_emr_db_tong_hop_tu_vong`. Lần đầu đặt `from_date` / `to_date` phủ kỳ cần số. Không đặt hai trường này và chưa có `last_runtime` thì lần quét đầu lấy `update_date` từ 2000-01-01.
5. Chạy đủ pipeline thì `commit` mới ghi khóa và `last_runtime`. Chạy lẻ với `{"pipelines": [...]}` không gồm `DashboardTongHopTuVong` thì giữ `from_date` / `to_date`.
6. Deploy DAG rồi mới bật. Task không gán pool `mcc_ds_pool`. `py_compile` không thay cho chạy MySQL.
