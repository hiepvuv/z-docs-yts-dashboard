# Tổng hợp cận lâm sàng và PTTT CN_296–CN_301

Đã đối chiếu grain trên MariaDB trước khi sinh file. Fact nằm ở `pipeline/sql/DDL_cac_bang_dich.sql`. Key-pair nằm ở `pipeline/sql/DDL_cac_bang_key_pair.sql`.

CN_296–CN_299 đọc `emr_datalake.medical_records_services`, `medical_records`, `cats_services_groups_reports_details`, `cats_services_groups_reports`. Nối `mrs.service_code = srd.service_code_vi`, rồi `srd.service_group_id = sr.service_group_id`. Điều kiện dòng dịch vụ và hồ sơ là `is_delete = 0`. Danh mục nhóm thêm `is_active = 1`.

CN_300–CN_301 đọc `emr_datalake.medical_records_services`, `medical_records`, `cats_cost_groups`. `cost_group_id` 8 là Phẫu thuật, 18 là Thủ thuật.

| Fact | Màn | Grain |
|---|---|---|
| `emr_db_tong_hop_cls` | CN_296–CN_299 | cơ sở hồ sơ + `DATE(decision_date)` + `code_vi` + `record_service_id`. `PATIENT_COLUMNS` lấy từ hồ sơ. `so_luot = 1`. Biểu đồ `COUNT(DISTINCT id_dich_vu)` |
| `emr_db_tong_hop_pttt` | CN_300, CN_301 | hồ sơ + ngày y lệnh. Cờ 0/1, dashboard `SUM` bằng `COUNT(DISTINCT)` cũ |

Tách hai fact vì khác danh mục nhóm, khác cột đếm. Không gộp vào DAG thuốc, bệnh, hoặc lượt khám. Không dùng lại bảng khóa của lượt khám.

`ngay_thuc_hien` = `DATE(decision_date)`. `ngay_y_lenh` = `DATE(decision_date)`. `ma_csyt` CLS là `medical_records.healthfacilities_id`. `ma_csyt` PTTT là `medical_records_services.healthfacilities_id`.

Đích Excel là đếm `record_service_id` không trùng trong tập mã. Bốn mã dịch vụ `02.03.1896`–`02.03.1899` vừa thuộc nhóm `3` vừa thuộc nhóm `4`. `SUM(so_luot)` trên CN_299 đếm các dòng đó hai lần. Biểu đồ dùng `COUNT(DISTINCT id_dich_vu)`.

Mã nhóm: xét nghiệm `9`, `22`, `23`, `24`, `25`, `XNK`; siêu âm `6`, `7`, `8`, `18Sieuam`; X-quang `1`, `2`, `18Xquang`; CT/MRI `3`, `4`, `5`, `18CTS`, `18MRI`. Bốn màn lọc `ma_nhom` lúc đọc.

CN_300 và CN_301 đếm hồ sơ `medical_record_id`, không đếm dòng dịch vụ. Nhiều dòng cùng hồ sơ trong một ngày vẫn là một ca: cờ `so_phau_thuat` / `so_thu_thuat` bằng 1, dashboard `SUM`.

`ten_csyt`, `tuyen_csyt`, `hang_csyt` của CLS để `NULL` vì dòng dịch vụ không có tên cơ sở. PTTT cũng để `NULL`. Địa bàn và chỉ tiêu để `NULL` ở cả hai fact.

Khóa CLS: `emr_db_changed_cls_pair`, xóa theo `(ma_csyt, ngay_thuc_hien)`. Khóa dòng là `record_service_id`. Quét `update_date` của dòng còn trong nhóm, dòng đã rời nhóm nếu còn khóa cũ, và dòng của hồ sơ vừa đổi. Thứ Hai quét thêm 45 ngày `decision_date` vì đổi danh mục nhóm không chạm `update_date` dòng dịch vụ.

Khóa PTTT: `emr_db_changed_pttt_pair`, xóa theo `(ma_csyt, ngay_y_lenh)`. Quét `update_date` của dòng nhóm 8 và 18, dòng đã rời hai nhóm nếu còn khóa cũ, và dòng của hồ sơ vừa đổi. Thứ Hai quét thêm 45 ngày `decision_date`. `commit` khi cả hai job thành công.

DAG: `EMR_DASHBOARD_CLINICAL_MASTER_DAG`, lịch `0 4 * * *`.

## SQL select dashboard

Cửa sổ `>= :from_date AND < :to_date`. Bỏ `:thang` khi xem cả năm. Lọc cơ sở bằng `ma_csyt` vì tên cơ sở trùng giữa nhiều mã.

CN_296 — `emr_db_tong_hop_cls`

```sql
SELECT nam,
       thang,
       COUNT(DISTINCT id_dich_vu) AS luot_xet_nghiem
FROM emr_db_tong_hop_cls
WHERE ma_csyt = :ma_csyt
  AND ma_nhom IN ('9', '22', '23', '24', '25', 'XNK')
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
       COUNT(DISTINCT id_dich_vu) AS luot_sieu_am
FROM emr_db_tong_hop_cls
WHERE ma_csyt = :ma_csyt
  AND ma_nhom IN ('6', '7', '8', '18Sieuam')
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
       COUNT(DISTINCT id_dich_vu) AS luot_xquang
FROM emr_db_tong_hop_cls
WHERE ma_csyt = :ma_csyt
  AND ma_nhom IN ('1', '2', '18Xquang')
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
       COUNT(DISTINCT id_dich_vu) AS luot_ct_mri
FROM emr_db_tong_hop_cls
WHERE ma_csyt = :ma_csyt
  AND ma_nhom IN ('3', '4', '5', '18CTS', '18MRI')
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

1. Trên warehouse: chạy lại `emr_db_tong_hop_cls` trong `pipeline/sql/DDL_cac_bang_dich.sql` (`CREATE OR REPLACE`, xóa dữ liệu bảng và `_stg`). Chạy lại ba bảng khóa CLS trong `pipeline/sql/DDL_cac_bang_key_pair.sql` (`CREATE OR REPLACE`, xóa khóa báo cáo cũ). Rồi nạp lại pipeline CLS với `from_date` / `to_date` phủ cả kỳ.
2. Connection Airflow `emr_datalake` đọc lake và đọc được bảng khóa trên `emr_datawarehouse` cùng instance. Index `update_date` của `medical_records` và `medical_records_services` đã có.
3. Airflow variable: `var_emr_db_tong_hop_cls`, `var_emr_db_tong_hop_pttt`. Lần đầu đặt `from_date` / `to_date` phủ kỳ cần số. Không đặt hai trường này và chưa có `last_runtime` thì lần quét đầu lấy từ 2000-01-01.
4. Chạy đủ hai pipeline thì `commit` mới ghi khóa và `last_runtime`. Chạy lẻ thì `from_date` / `to_date` giữ nguyên.
5. Deploy DAG rồi mới bật. Task không gán pool `mcc_ds_pool`. `py_compile` không thay cho chạy MySQL.
