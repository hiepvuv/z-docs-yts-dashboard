# Tổng hợp lượt khám CN_264–CN_286

Đã đối chiếu grain với fact bệnh CN_308–CN_313 trước khi sinh file. Nguồn đọc trên `emr_datalake`. Đích nối vào `z_docs/dashboard/dich.sql`.

CN_279 đọc `emr_db_tong_hop_benh_nhom` đã có cho CN_308 và CN_310. Không tạo fact mới và không thêm job.

Các màn còn lại không dùng fact bệnh: ngày là `examination_date` hoặc `finish_examination_date` hoặc `decision_date`, không phải `recording_date`. Số là đếm hồ sơ hoặc cộng tiền, không phải dòng chẩn đoán. `emr_db_tong_hop_benh.so_ngay_dieu_tri` là MAX theo mã bệnh và ngày ghi nhận; CN_283 cần SUM theo hồ sơ và ngày vào.

| Fact | Màn | Grain |
|---|---|---|
| `emr_db_tong_hop_luot_kham` | CN_264, CN_265, CN_267, CN_278, CN_280–CN_283, CN_285, CN_286 | cơ sở + ngày vào |
| `emr_db_tong_hop_luot_vao_ra` | CN_266 | cơ sở + ngày biểu đồ |
| `emr_db_tong_hop_luot_bhyt` | CN_268 | cơ sở + ngày vào + loại BHYT |
| `emr_db_tong_hop_cap_cuu_tu_vong` | CN_269 | cơ sở + ngày vào + loại cấp cứu/tử vong |
| `emr_db_tong_hop_tai_nan` | CN_270 | cơ sở + ngày vào + tên tai nạn |
| `emr_db_tong_hop_nhom_dich_vu` | CN_284 | cơ sở + ngày y lệnh + nhóm chi phí + mã hồ sơ |

`ngay_vao` = `DATE(examination_date)`. `ngay_ra` = `DATE(finish_examination_date)`. `ngay_y_lenh` = `DATE(decision_date)`. `ma_csyt` hồ sơ lấy `medical_records.healthfacilities_id`. `ma_csyt` dịch vụ lấy `medical_records_services.healthfacilities_id` (varchar 255 trên nguồn).

`so_ho_so_bh` đếm `IFNULL(is_health_insurance, 0) = 1`. `so_ho_so_khong_bh` đếm giá trị đã coi null là 0 rồi khác 1. CN_264 đọc cùng cột này.

`so_tai_nan` trên fact ngày là tổng hồ sơ `accident_type = 1`, dùng cho CN_280. CN_270 tách `emr_db_tong_hop_tai_nan` vì cần `name_vi`: một ngày nhiều tên nếu nằm trên fact ngày sẽ nhân số hồ sơ, tiền và số ngày.

`examination_date` trên `medical_records_services` đang không có giá trị (đếm dòng khác NULL = 0). CN_284 lấy ngày y lệnh `decision_date`. Câu “cùng examination_date” trong Excel không áp được trên lake.

CN_284 giữ `ma_hs` vì số hồ sơ trong tháng là `COUNT(DISTINCT ma_hs)`. Cộng số đã tách theo ngày sẽ đếm một hồ sơ nhiều lần.

CN_285 có đích mong muốn trùng CN_283 (tổng số ngày điều trị nội trú). Tên màn nói cơ cấu chi phí nhưng file không nêu cột tiền. SQL làm theo đích đã ghi, không tự thêm cột tiền thành phần.

Khóa xóa-ghi hồ sơ: hợp của ngày vào và ngày ra trên `emr_db_changed_record_pair`. Khóa dịch vụ: `emr_db_changed_service_pair`. `prepare` quét `update_date` hồ sơ và dòng dịch vụ. Hồ sơ đổi cũng kéo dòng dịch vụ của hồ sơ đó, vì cờ xóa hồ sơ không sửa `update_date` dòng dịch vụ. `commit` khi cả sáu job thành công. Thứ Hai quét thêm 45 ngày `examination_date` và `decision_date` vì đổi danh mục tai nạn hoặc tên nhóm chi phí không chạm `update_date`.

CN_266, CN_268, CN_269 ghi sẵn hình dòng mà tool gen dashboard đọc được. Tool không đọc subquery, nên không UNION lúc SELECT. `emr_db_tong_hop_luot_ra` không còn job.

DAG: `EMR_DASHBOARD_VISIT_MASTER_DAG`, lịch `0 3 * * *`. Không gắn vào DAG thuốc hoặc DAG bệnh.

## SQL select dashboard

Cửa sổ `>= :from_date AND < :to_date`. Bỏ `:thang` khi xem cả năm.

CN_264 — `emr_db_tong_hop_luot_kham`

```sql
SELECT SUM(so_ho_so)          AS tong_ho_so,
       SUM(so_ho_so_bh)       AS tong_ho_so_bh,
       SUM(so_ho_so_khong_bh) AS tong_ho_so_khong_bh,
       SUM(so_cap_cuu)        AS luot_cap_cuu,
       SUM(so_tu_vong)        AS luot_tu_vong
FROM emr_db_tong_hop_luot_kham
WHERE ma_csyt = :ma_csyt
  AND ngay_vao >= :from_date
  AND ngay_vao < :to_date
  AND (:thang IS NULL OR thang = :thang)
```

CN_265 — `emr_db_tong_hop_luot_kham`

```sql
SELECT ngay_vao,
       SUM(so_ho_so) AS luot_kham
FROM emr_db_tong_hop_luot_kham
WHERE ma_csyt = :ma_csyt
  AND ngay_vao >= :from_date
  AND ngay_vao < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY ngay_vao
ORDER BY ngay_vao
```

CN_266 — `emr_db_tong_hop_luot_vao_ra`

Một dòng một ngày. `ngay` là ngày trên biểu đồ: lượt vào đếm `examination_date` của loại khám 3, 4, 9; lượt ra đếm `finish_examination_date` của mọi hồ sơ. Ngày chỉ có một phía thì phía kia bằng 0.

```sql
SELECT ngay_theo_doi AS ngay,
       so_luot_vao,
       so_luot_ra
FROM emr_db_tong_hop_luot_vao_ra
WHERE ma_csyt = :ma_csyt
  AND ngay_theo_doi >= :from_date
  AND ngay_theo_doi < :to_date
  AND (:thang IS NULL OR thang = :thang)
ORDER BY ngay_theo_doi
```

CN_267 — `emr_db_tong_hop_luot_kham`

```sql
SELECT ngay_vao,
       SUM(so_noi_tru)   AS luot_noi_tru,
       SUM(so_ngoai_tru) AS luot_ngoai_tru
FROM emr_db_tong_hop_luot_kham
WHERE ma_csyt = :ma_csyt
  AND ngay_vao >= :from_date
  AND ngay_vao < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY ngay_vao
ORDER BY ngay_vao
```

CN_268 — `emr_db_tong_hop_luot_bhyt`

Mỗi dòng là một điểm line: `ngay_vao`, `loai`, `luot`. `BHYT` là cờ bảo hiểm bằng 1. `Không BHYT` là null (coi như 0) hoặc khác 1. Ngày có hồ sơ thì cả hai loại đều có dòng, kể cả số 0.

```sql
SELECT ngay_vao,
       loai,
       luot
FROM emr_db_tong_hop_luot_bhyt
WHERE ma_csyt = :ma_csyt
  AND ngay_vao >= :from_date
  AND ngay_vao < :to_date
  AND (:thang IS NULL OR thang = :thang)
ORDER BY ngay_vao, loai
```

CN_269 — `emr_db_tong_hop_cap_cuu_tu_vong`

Mỗi dòng là một điểm line: `ngay_vao`, `loai`, `luot`. Một hồ sơ vừa cấp cứu vừa tử vong thì có mặt ở cả hai loại. Ngày có hồ sơ thì cả hai loại đều có dòng, kể cả số 0.

```sql
SELECT ngay_vao,
       loai,
       luot
FROM emr_db_tong_hop_cap_cuu_tu_vong
WHERE ma_csyt = :ma_csyt
  AND ngay_vao >= :from_date
  AND ngay_vao < :to_date
  AND (:thang IS NULL OR thang = :thang)
ORDER BY ngay_vao, loai
```

CN_270 — `emr_db_tong_hop_tai_nan`

Mỗi dòng là một điểm line: `ngay_vao`, `loai` (tên tai nạn), `luot`.

```sql
SELECT ngay_vao,
       ten_tai_nan AS loai,
       SUM(so_luot) AS luot
FROM emr_db_tong_hop_tai_nan
WHERE ma_csyt = :ma_csyt
  AND ngay_vao >= :from_date
  AND ngay_vao < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY ngay_vao, ten_tai_nan
ORDER BY ngay_vao, loai
```

CN_278 — `emr_db_tong_hop_luot_kham`

```sql
SELECT nam,
       thang,
       SUM(so_noi_tru)   AS luot_noi_tru,
       SUM(so_ngoai_tru) AS luot_ngoai_tru
FROM emr_db_tong_hop_luot_kham
WHERE ma_csyt = :ma_csyt
  AND ngay_vao >= :from_date
  AND ngay_vao < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY nam, thang
ORDER BY nam, thang
```

CN_280 — `emr_db_tong_hop_luot_kham`

```sql
SELECT nam,
       thang,
       SUM(so_tai_nan) AS luot
FROM emr_db_tong_hop_luot_kham
WHERE ma_csyt = :ma_csyt
  AND ngay_vao >= :from_date
  AND ngay_vao < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY nam, thang
ORDER BY nam, thang
```

CN_281 — `emr_db_tong_hop_luot_kham`

```sql
SELECT nam,
       thang,
       SUM(so_tu_vong) AS luot_tu_vong
FROM emr_db_tong_hop_luot_kham
WHERE ma_csyt = :ma_csyt
  AND ngay_vao >= :from_date
  AND ngay_vao < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY nam, thang
ORDER BY nam, thang
```

CN_282 — `emr_db_tong_hop_luot_kham`

```sql
SELECT nam,
       thang,
       SUM(so_cap_cuu) AS luot_cap_cuu
FROM emr_db_tong_hop_luot_kham
WHERE ma_csyt = :ma_csyt
  AND ngay_vao >= :from_date
  AND ngay_vao < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY nam, thang
ORDER BY nam, thang
```

CN_283 và CN_285 — `emr_db_tong_hop_luot_kham`

```sql
SELECT nam,
       thang,
       SUM(so_ngay_dieu_tri) AS so_ngay_dieu_tri
FROM emr_db_tong_hop_luot_kham
WHERE ma_csyt = :ma_csyt
  AND ngay_vao >= :from_date
  AND ngay_vao < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY nam, thang
ORDER BY nam, thang
```

CN_284 — `emr_db_tong_hop_nhom_dich_vu`

```sql
SELECT ten_nhom,
       COUNT(DISTINCT ma_hs) AS so_luot
FROM emr_db_tong_hop_nhom_dich_vu
WHERE ma_csyt = :ma_csyt
  AND ngay_y_lenh >= :from_date
  AND ngay_y_lenh < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY ten_nhom
ORDER BY so_luot DESC
LIMIT 6
```

CN_286 — `emr_db_tong_hop_luot_kham`

```sql
SELECT nam,
       thang,
       SUM(tien_benh_nhan) AS tien_benh_nhan,
       SUM(tien_bao_hiem)  AS tien_bao_hiem,
       ROUND(SUM(tien_benh_nhan) / NULLIF(SUM(tien_benh_nhan) + SUM(tien_bao_hiem), 0) * 100, 2) AS ty_le_benh_nhan,
       ROUND(SUM(tien_bao_hiem) / NULLIF(SUM(tien_benh_nhan) + SUM(tien_bao_hiem), 0) * 100, 2) AS ty_le_bao_hiem
FROM emr_db_tong_hop_luot_kham
WHERE ma_csyt = :ma_csyt
  AND ngay_vao >= :from_date
  AND ngay_vao < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY nam, thang
ORDER BY nam, thang
```

## CN_279 — `emr_db_tong_hop_benh_nhom`

Đã xác nhận tái sử dụng fact của CN_308 và CN_310. Biểu đồ tháng đọc `COUNT(DISTINCT ma_bn)` vì grain đã lưu `ma_bn` và cột `thang`. Cơ sở trên fact là `medical_records.healthfacilities_id`.

```sql
SELECT ten_nhom,
       COUNT(DISTINCT ma_bn) AS so_ca
FROM emr_db_tong_hop_benh_nhom
WHERE ma_csyt = :ma_csyt
  AND ngay_ghi_nhan >= :from_date
  AND ngay_ghi_nhan < :to_date
  AND (:thang IS NULL OR thang = :thang)
GROUP BY ten_nhom
ORDER BY so_ca DESC
LIMIT 10
```

## Việc người dùng chạy

1. Trên warehouse: fact lượt khám trong `pipeline/sql/DDL_cac_bang_dich.sql`. Phần thuốc phía trên file dùng `CREATE OR REPLACE`. Phần bệnh và lượt khám dùng `CREATE TABLE IF NOT EXISTS`. Bảng khóa trong `pipeline/sql/DDL_cac_bang_key_pair.sql`.
2. Trên nguồn (không sửa dữ liệu), tạo index nếu chưa có. Đã kiểm tra `information_schema`: `medical_records` và `medical_records_services` chưa có index `update_date`.

```sql
CREATE INDEX idx_mr_update_date ON emr_datalake.medical_records (update_date);
CREATE INDEX idx_mr_hf_exam ON emr_datalake.medical_records (healthfacilities_id, examination_date);
CREATE INDEX idx_mr_hf_finish ON emr_datalake.medical_records (healthfacilities_id, finish_examination_date);
CREATE INDEX idx_mrs_update_date ON emr_datalake.medical_records_services (update_date);
CREATE INDEX idx_mrs_hf_decision ON emr_datalake.medical_records_services (healthfacilities_id, decision_date);
```

3. Airflow variable: `var_emr_db_tong_hop_luot_kham`, `var_emr_db_tong_hop_luot_vao_ra`, `var_emr_db_tong_hop_luot_bhyt`, `var_emr_db_tong_hop_cap_cuu_tu_vong`, `var_emr_db_tong_hop_tai_nan`, `var_emr_db_tong_hop_nhom_dich_vu`. Lần đầu đặt `from_date` / `to_date` phủ kỳ cần số. Không đặt hai trường này và chưa có `last_runtime` thì lần quét đầu lấy `update_date` từ 2000-01-01. Biến `var_emr_db_tong_hop_luot_ra` không còn job.
4. Chạy đủ sáu pipeline thì `commit` mới ghi khóa và `last_runtime`. Chạy lẻ thì `from_date` / `to_date` giữ nguyên.
5. Deploy DAG rồi mới bật. Task không gán pool `mcc_ds_pool`. `py_compile` không thay cho chạy MySQL.
