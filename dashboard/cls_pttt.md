# Tổng hợp cận lâm sàng và PTTT CN_296–CN_301

Đã đối chiếu grain trên MariaDB trước khi sinh file. Fact nằm ở `pipeline/sql/DDL_cac_bang_dich.sql`. Key-pair nằm ở `pipeline/sql/DDL_cac_bang_key_pair.sql`.

CN_296–CN_299 đọc `emr_datawarehouse.report_medical_records_service`. Bảng này không có trên `emr_datalake`, nên không nối DDL vào `nguon.sql`. Hai schema cùng một instance. Câu pipeline ghi schema tường minh.

CN_300–CN_301 đọc `emr_datalake.medical_records_services`, `medical_records`, `cats_cost_groups`. Ba bảng đã có trong `nguon.sql`. `cost_group_id` 8 là Phẫu thuật, 18 là Thủ thuật.

| Fact | Màn | Grain |
|---|---|---|
| `emr_db_tong_hop_cls` | CN_296–CN_299 | cơ sở + ngày thực hiện + mã nhóm báo cáo |
| `emr_db_tong_hop_pttt` | CN_300, CN_301 | cơ sở + ngày y lệnh |

Tách hai fact vì khác bảng nguồn, khác cột ngày, khác công thức. Không gộp vào DAG thuốc, bệnh, hoặc lượt khám. Không dùng lại bảng khóa của lượt khám.

`ngay_thuc_hien` lấy từ `thoi_gian` dạng số `yyyyMMdd`. `ngay_y_lenh` = `DATE(decision_date)`. `ma_csyt` CLS là `ma_csyt` của bảng báo cáo. `ma_csyt` PTTT là `medical_records_services.healthfacilities_id`.

Excel viết “đếm số bản ghi” của bảng báo cáo. Bảng đó đã cộng sẵn `so_luot` theo dịch vụ (mỗi nhóm khoảng 1,8 nghìn dòng nhưng `SUM(so_luot)` khoảng 90 nghìn). Fact lưu `SUM(so_luot)`. Đếm dòng sẽ đếm dòng danh mục.

Mã nhóm trên nguồn: 9 xét nghiệm, 6–8 siêu âm, 1–2 X-quang, 3–5 CT/MRI. Bốn màn chỉ lọc `ma_nhom` lúc đọc.

CN_300 và CN_301 đếm hồ sơ `medical_record_id`, không đếm dòng dịch vụ. Nhiều dòng cùng hồ sơ trong một ngày vẫn là một ca. `so_phau_thuat` và `so_thu_thuat` là hai cột trên cùng grain.

`ten_csyt`, `tuyen_csyt`, `hang_csyt` của CLS lấy từ bảng báo cáo. PTTT chưa có tên cơ sở trên dòng dịch vụ nên các cột đó để `NULL`. Địa bàn và chỉ tiêu để `NULL` ở cả hai fact.

Khóa CLS: `emr_db_changed_cls_pair`, xóa theo `(ma_csyt, ngay_thuc_hien)`. Quét `thoi_gian_cap_nhat`. Dòng có ngày cập nhật trống vẫn được kéo. Không quét 45 ngày thứ Hai vì mã nhóm đã nằm trên dòng báo cáo.

Khóa PTTT: `emr_db_changed_pttt_pair`, xóa theo `(ma_csyt, ngay_y_lenh)`. Quét `update_date` của dòng nhóm 8 và 18, dòng đã rời hai nhóm nếu còn khóa cũ, và dòng của hồ sơ vừa đổi. Thứ Hai quét thêm 45 ngày `decision_date`. `commit` khi cả hai job thành công.

DAG: `EMR_DASHBOARD_CLINICAL_MASTER_DAG`, lịch `0 4 * * *`.

## SQL select dashboard

Cửa sổ `>= :from_date AND < :to_date`. Bỏ `:thang` khi xem cả năm. Lọc cơ sở bằng `ma_csyt` vì tên cơ sở trùng giữa nhiều mã.

CN_296 — `emr_db_tong_hop_cls`

```sql
SELECT nam,
       thang,
       SUM(so_luot) AS luot_xet_nghiem
FROM emr_db_tong_hop_cls
WHERE ma_csyt = :ma_csyt
  AND ma_nhom = '9'
  AND ngay_thuc_hien >= :from_date
  AND ngay_thuc_hien < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY nam, thang
ORDER BY nam, thang
```

CN_297 — `emr_db_tong_hop_cls`

```sql
SELECT nam,
       thang,
       SUM(so_luot) AS luot_sieu_am
FROM emr_db_tong_hop_cls
WHERE ma_csyt = :ma_csyt
  AND ma_nhom IN ('6', '7', '8')
  AND ngay_thuc_hien >= :from_date
  AND ngay_thuc_hien < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY nam, thang
ORDER BY nam, thang
```

CN_298 — `emr_db_tong_hop_cls`

```sql
SELECT nam,
       thang,
       SUM(so_luot) AS luot_xquang
FROM emr_db_tong_hop_cls
WHERE ma_csyt = :ma_csyt
  AND ma_nhom IN ('1', '2')
  AND ngay_thuc_hien >= :from_date
  AND ngay_thuc_hien < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY nam, thang
ORDER BY nam, thang
```

CN_299 — `emr_db_tong_hop_cls`

```sql
SELECT nam,
       thang,
       SUM(so_luot) AS luot_ct_mri
FROM emr_db_tong_hop_cls
WHERE ma_csyt = :ma_csyt
  AND ma_nhom IN ('3', '4', '5')
  AND ngay_thuc_hien >= :from_date
  AND ngay_thuc_hien < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY nam, thang
ORDER BY nam, thang
```

CN_300 — `emr_db_tong_hop_pttt`

```sql
SELECT nam,
       thang,
       SUM(so_phau_thuat) AS so_ca_phau_thuat
FROM emr_db_tong_hop_pttt
WHERE ma_csyt = :ma_csyt
  AND ngay_y_lenh >= :from_date
  AND ngay_y_lenh < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY nam, thang
ORDER BY nam, thang
```

CN_301 — `emr_db_tong_hop_pttt`

```sql
SELECT nam,
       thang,
       SUM(so_thu_thuat) AS so_ca_thu_thuat
FROM emr_db_tong_hop_pttt
WHERE ma_csyt = :ma_csyt
  AND ngay_y_lenh >= :from_date
  AND ngay_y_lenh < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY nam, thang
ORDER BY nam, thang
```

## Việc người dùng chạy

1. Trên warehouse: fact `emr_db_tong_hop_cls` và `emr_db_tong_hop_pttt` trong `pipeline/sql/DDL_cac_bang_dich.sql`. Bảng khóa trong `pipeline/sql/DDL_cac_bang_key_pair.sql`.
2. Connection Airflow `emr_datalake` phải đọc được `emr_datawarehouse.report_medical_records_service` trên cùng instance. Index `update_date` của `medical_records` và `medical_records_services` đã có.
3. Airflow variable: `var_emr_db_tong_hop_cls`, `var_emr_db_tong_hop_pttt`. Lần đầu đặt `from_date` / `to_date` phủ kỳ cần số. Không đặt hai trường này và chưa có `last_runtime` thì lần quét đầu lấy từ 2000-01-01.
4. Chạy đủ hai pipeline thì `commit` mới ghi khóa và `last_runtime`. Chạy lẻ thì `from_date` / `to_date` giữ nguyên.
5. Deploy DAG rồi mới bật. Task không gán pool `mcc_ds_pool`. `py_compile` không thay cho chạy MySQL.
