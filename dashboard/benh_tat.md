# Tổng hợp bệnh tật CN_308–CN_313

Đã duyệt grain trước khi sinh file. Nguồn `z_docs/dashboard/nguon.sql`. Đích `z_docs/dashboard/dich.sql`.

Ba fact vì ba kiểu JOIN khác nhau. Một mã ICD thuộc nhiều nhóm thì số của CN_308/310 tính ở từng nhóm. Chương lấy một `chapter_id` (`MAX`) cho mỗi `code_vi`.

| Fact | Màn | Grain |
|---|---|---|
| `emr_db_tong_hop_benh_nhom` | CN_308, CN_310, CN_279 | cơ sở + ngày ghi nhận + mã bệnh + tên bệnh + nhóm + `ma_bn` + `cccd` |
| `emr_db_tong_hop_benh_chuong` | CN_309, CN_312 | cơ sở + ngày ghi nhận + mã bệnh + tên bệnh + chương + `ma_bn` + `cccd` |
| `emr_db_tong_hop_benh` | CN_311, CN_313 | từng dòng chẩn đoán + hồ sơ. `so_luot = 1`. CN_313 `SUM`. CN_311 `MAX(so_ngay_dieu_tri)` |

`ngay_ghi_nhan` = `DATE(recording_date)`. `ma_csyt` = `medical_records.healthfacilities_id`. Đếm mọi `diagnoses_type`. Không lọc cờ dashboard của danh mục nhóm.

Số ca là `COUNT(DISTINCT ma_bn, cccd)` lúc đọc trên fact nhóm và chương. Mã hoặc CCCD trống không vào số ca. `so_luot` và `so_tu_vong` thì `SUM`. `emr_db_tong_hop_benh.so_ngay_dieu_tri` là số ngày của hồ sơ trên từng dòng chẩn đoán; CN_311 đọc `MAX` và lọc `loai_kham IN (3, 4, 9)`.

Khóa xóa-ghi: `(ma_csyt, ngay_ghi_nhan)` trên `emr_db_changed_diagnoses_pair`. `prepare` quét `update_date` của dòng chẩn đoán và của hồ sơ. `commit` khi cả ba job thành công. Thứ Hai quét thêm 45 ngày `recording_date`.

DAG: `EMR_DASHBOARD_DISEASE_MASTER_DAG`, lịch `0 2 * * *`. Không gắn vào DAG thuốc.

## SQL select dashboard

Cửa sổ `ngay_ghi_nhan >= :from_date AND ngay_ghi_nhan < :to_date`. Bỏ `:thang` khi xem cả năm.

CN_308 — `emr_db_tong_hop_benh_nhom`

```sql
SELECT ma_benh,
       ten_benh,
       ten_nhom,
       COUNT(DISTINCT ma_bn, cccd) AS so_ca,
       SUM(so_luot)          AS so_luot,
       SUM(so_tu_vong)       AS so_tu_vong
FROM emr_db_tong_hop_benh_nhom
WHERE ma_csyt = :ma_csyt
  AND ngay_ghi_nhan >= :from_date
  AND ngay_ghi_nhan < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY ma_benh, ten_benh, ten_nhom
```

CN_310 — `emr_db_tong_hop_benh_nhom`

```sql
SELECT ten_nhom,
       COUNT(DISTINCT ma_bn, cccd) AS so_ca
FROM emr_db_tong_hop_benh_nhom
WHERE ma_csyt = :ma_csyt
  AND ngay_ghi_nhan >= :from_date
  AND ngay_ghi_nhan < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY ten_nhom
ORDER BY so_ca DESC
LIMIT 10
```

CN_279 — `emr_db_tong_hop_benh_nhom`

```sql
SELECT ten_nhom,
       COUNT(DISTINCT ma_bn, cccd) AS so_ca
FROM emr_db_tong_hop_benh_nhom
WHERE ma_csyt = :ma_csyt
  AND ngay_ghi_nhan >= :from_date
  AND ngay_ghi_nhan < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY ten_nhom
ORDER BY so_ca DESC
LIMIT 10
```

CN_309 — `emr_db_tong_hop_benh_chuong`

```sql
SELECT ma_benh,
       ten_benh,
       ten_chuong,
       COUNT(DISTINCT ma_bn, cccd) AS so_ca,
       SUM(so_luot)          AS so_luot,
       SUM(so_tu_vong)       AS so_tu_vong
FROM emr_db_tong_hop_benh_chuong
WHERE ma_csyt = :ma_csyt
  AND ngay_ghi_nhan >= :from_date
  AND ngay_ghi_nhan < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY ma_benh, ten_benh, ten_chuong
```

CN_312 — `emr_db_tong_hop_benh_chuong`

```sql
SELECT ten_chuong,
       SUM(so_luot)    AS so_luot,
       SUM(so_tu_vong) AS so_tu_vong
FROM emr_db_tong_hop_benh_chuong
WHERE ma_csyt = :ma_csyt
  AND ngay_ghi_nhan >= :from_date
  AND ngay_ghi_nhan < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY ten_chuong
ORDER BY so_luot DESC
LIMIT 10
```

CN_313 — `emr_db_tong_hop_benh`

```sql
SELECT ma_benh,
       ten_benh,
       SUM(so_luot) AS so_luot
FROM emr_db_tong_hop_benh
WHERE ma_csyt = :ma_csyt
  AND ngay_ghi_nhan >= :from_date
  AND ngay_ghi_nhan < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY ma_benh, ten_benh
ORDER BY so_luot DESC
LIMIT 10
```

CN_311 — `emr_db_tong_hop_benh`

```sql
SELECT ma_benh,
       ten_benh,
       MAX(so_ngay_dieu_tri) AS so_ngay_dieu_tri
FROM emr_db_tong_hop_benh
WHERE ma_csyt = :ma_csyt
  AND loai_kham IN (3, 4, 9)
  AND ngay_ghi_nhan >= :from_date
  AND ngay_ghi_nhan < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY ma_benh, ten_benh
ORDER BY so_ngay_dieu_tri DESC
LIMIT 10
```

## Việc người dùng chạy

1. Trên warehouse: fact trong `pipeline/sql/DDL_cac_bang_dich.sql`. `emr_db_tong_hop_benh`, `emr_db_tong_hop_benh_nhom` và `emr_db_tong_hop_benh_chuong` dùng `CREATE OR REPLACE` (xóa dữ liệu bảng đó và `_stg` rồi nạp lại). Bảng khóa trong `pipeline/sql/DDL_cac_bang_key_pair.sql`.
2. Trên nguồn (không sửa dữ liệu): index `update_date` cho `medical_records` và `medical_records_diagnoses_discharge` nếu chưa có. Các index khóa nghiệp vụ đã có trong `nguon.sql`.
3. Airflow variable, cùng kiểu biến thuốc: `var_emr_db_tong_hop_benh_nhom`, `var_emr_db_tong_hop_benh_chuong`, `var_emr_db_tong_hop_benh`. Lần đầu đặt `from_date` / `to_date` phủ kỳ cần số. Không đặt hai trường này và chưa có `last_runtime` thì lần quét đầu lấy `update_date` từ 2000-01-01.
4. Chạy đủ ba pipeline thì `commit` mới ghi khóa và `last_runtime`. Chạy lẻ thì `from_date` / `to_date` giữ nguyên để lần đủ ba job tính lại cùng kỳ.
5. Deploy DAG rồi mới bật. Task không gán pool `mcc_ds_pool`. `py_compile` không thay cho chạy MySQL.
