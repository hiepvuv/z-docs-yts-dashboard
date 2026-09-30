# Gộp bảng tổng hợp SD thuốc

Gộp theo **nhóm nguồn** + cột chiều dùng chung.

**Trước:** 14 bảng fact (+ 14 `_stg`)  
**Sau:** 8 bảng fact + 8 `_stg` tương ứng  
Mỗi bảng có `comment` ghi **Dashboard dùng cho** + **nguồn bảng**.

**Không có `loai_bao_cao`:** bảng grain chung.  
**Đã bỏ cột:** `cskcb`, `ngay_tong_hop`, `ngay_tong_hop_goc` (grain CSYT = `ma_csyt`).  
**Đổi tên cột:** `phan_loai` → `la_khang_sinh` (trên `emr_db_tong_hop_thuoc`).  
**Index Dashboard:** chỉ trên bảng prod (không `_stg`), dẫn đầu `(ma_csyt, ngay_su_dung)` + chiều GROUP BY.  
**Đã thêm cột chuẩn Dashboard (mọi bảng):**  
`thoi_gian`, `ma_tinh`, `ten_tinh`, `ma_xa`, `ten_xa`, `ma_csyt`, `ten_csyt`, `tuyen_csyt`, `hang_csyt`,  
`ma_chi_tieu_bieu_do`, `ma_chi_tieu_canh_bao`, `ten_chi_tieu`, `ngay`, `thang`, `nam`.  
**Không còn UNIQUE.** Job xóa theo cặp `(ma_csyt, ngay_su_dung)` rồi insert. Index dashboard dẫn đầu `(ma_csyt, ngay_su_dung)` phục vụ bước xóa.  
**DDD năm:** `emr_db_tong_hop_ddd_khoa` gom theo **năm** (`nam`), `ngay_su_dung` để null, `thoi_gian` là năm. `so_ngay_giuong` lấy từ `treatment_department_days` theo năm + khoa + cơ sở, lặp trên từng dòng thuốc trong năm — không `SUM` cột này qua nhiều thuốc. `so_ddd_100 = so_ddd * 100 / so_ngay_giuong`. Xóa-ghi theo `(ma_csyt, nam)` trên `emr_db_changed_ddd_year`.
**DDD tháng:** `emr_db_tong_hop_ddd_khoa_thang` cùng cột, grain **tháng** (`thang` + `nam`, `thoi_gian` = yyyyMM). `so_ngay_giuong` lấy từ `treatment_days`. Xóa-ghi theo `(ma_csyt, nam, thang)` trên `emr_db_changed_ddd_month`. Đổi tháng hoặc cơ sở của dòng `treatment_days` thì tính lại tháng cũ.

**Charset:** `utf8mb3`.  
**Độ dài khớp nguồn:** `ten_thuoc` text (`drug_name`); `ten_biet_duoc` text khi lấy `medical_records_drugs.brand_drug_name`, vẫn `varchar(1024)` trên `emr_db_tong_hop_thuoc` vì lấy `cats_antibiotics.brand_drug_name`; `nhom_thuoc` varchar(1024); `xuat_xu` varchar(45); `ma_csyt` varchar(50). Cột địa bàn, tên cơ sở, chỉ tiêu ghi `NULL`.  
**Pipeline:** SQL chung ở `pipeline/dashboard_pipelines/medical/sql_common.py`. `ma_csyt` lấy từ `healthfacilities_id`. Địa bàn, tên cơ sở và chỉ tiêu ghi `NULL`.

## Luồng chạy

DAG `EMR_DASHBOARD_MEDICAL_MASTER_DAG`, 1 giờ sáng. Không có DAG riêng cho phần khóa.

**Bước 1:** Tìm các cặp khóa (`healthfacilities_id`, `DATE(decision_date)`) để tổng hợp lại từ nguồn về đích. Cột khóa warehouse vẫn tên `use_date`, giá trị là ngày y lệnh.

- Nguồn `emr_datalake.medical_records_drugs`, dòng có `update_date >= {from_date}` và `update_date < {to_date}`. `{from_date}` / `{to_date}` là cửa sổ rộng nhất của các pipeline được chọn. `to_date` không nằm trong cửa sổ.
- Lịch ngày: `{from_date}` = `last_runtime` lùi 2 ngày, `{to_date}` = hôm nay. Job lỗi không ghi `last_runtime` nên lần sau vẫn quét lại ngày đó. Có `from_date` và `to_date` tay thì dùng cửa sổ đó, xong lần chạy thành công thì xóa hai trường.
- Thứ Hai: thêm mọi cặp `decision_date` trong 45 ngày, kể cả dòng không đổi `update_date` (đổi danh mục, ngày giường, loại khám).
- Lấy `drug_record_id`, `healthfacilities_id`, `decision_date`. Kể cả dòng `is_delete = 1` hoặc `is_active = 0`, vì dòng tắt vẫn phải kéo cặp khóa ra để xóa số cũ trên đích.
- Ghi tạm `emr_datawarehouse.emr_db_medical_records_drugs_key_chg` (chưa phải sổ khóa): `drug_record_id` giữ nguyên, `healthfacilities_id` null thành `''`, `use_date = DATE(decision_date)`.
- So cùng `drug_record_id` với `emr_datawarehouse.emr_db_medical_records_drugs_key` — bảng theo dõi dòng `medical_records_drugs` đã tổng hợp. Dùng cho case `decision_date` hoặc `healthfacilities_id` đổi trên nguồn: cặp khóa cũ không còn trên dòng nguồn, đích sẽ sót số của cặp cũ nếu không đối chiếu bảng này.
- Chưa có dòng khóa: chỉ lấy cặp hiện tại (`healthfacilities_id`, `DATE(decision_date)`) khi `decision_date` có giá trị.
- Đã có dòng khóa mà `healthfacilities_id` hoặc ngày khác: thêm cặp cũ.
- Ghi các cặp vào `emr_datawarehouse.emr_db_changed_drug_pair` (`healthfacilities_id`, `use_date`).
- Chưa ghi đè `emr_db_medical_records_drugs_key`. Bảy bảng phía sau còn phải đọc cặp cũ.

**Bước 2:** Tổng hợp lại dữ liệu cho các cặp khóa vừa tìm. Cách cộng theo nghiệp vụ từng bảng. Chỉ sum khi `is_delete = 0` và `is_active = 1`.

- Tám bảng chạy song song: `emr_db_top10_thuoc_sd`, `emr_db_top10_nhom_thuoc_sd`, `emr_db_tong_hop_thuoc`, `emr_db_tong_hop_thuoc_noi_ngoai`, `emr_db_tong_hop_thuoc_phan_nhom`, `emr_db_tong_hop_thuoc_xuat_xu`, `emr_db_tong_hop_ddd_khoa`, `emr_db_tong_hop_ddd_khoa_thang`. Mỗi bảng có bảng `_stg`.
- Chỉ lấy dòng `medical_records_drugs` thuộc cặp trong `emr_db_changed_drug_pair`: `healthfacilities_id` bằng `healthfacilities_id` của cặp, và `decision_date` đúng ngày `use_date` của cặp. Mã cơ sở null không vào cặp.
- Xóa đích trước, rồi insert, không upsert: `ma_csyt` = `emr_db_changed_drug_pair.healthfacilities_id`, `ngay_su_dung` = `emr_db_changed_drug_pair.use_date`. Cặp không còn dòng hiệu lực thì đích mất số cũ, không insert lại.
- Sáu bảng theo ngày: `ma_csyt = healthfacilities_id`, `ngay_su_dung = DATE(decision_date)`. DDD năm/tháng cũng lấy năm và tháng từ `decision_date`.
- `emr_db_tong_hop_ddd_khoa` gom cả năm. Xóa theo `emr_db_changed_ddd_year` (`ma_csyt`, `nam`). Năm đó gồm cặp thuốc đổi và dòng `treatment_department_days` đổi `update_date`. Năm hoặc cơ sở cũ của dòng ngày giường cũng được tính lại. Khóa `emr_db_treatment_department_days_key` ghi khi job DDD chạy xong.
- `emr_db_tong_hop_ddd_khoa_thang` gom cả tháng. Xóa theo `emr_db_changed_ddd_month` (`ma_csyt`, `nam`, `thang`). Tháng đó gồm cặp thuốc đổi và dòng `treatment_days` đổi `update_date`. Tháng hoặc cơ sở cũ cũng được tính lại. Khóa `emr_db_treatment_days_key` ghi khi job DDD tháng chạy xong.

**Bước 3:** Upsert `emr_db_medical_records_drugs_key` để lần tổng hợp sau còn biết cặp cũ.

- Chỉ khi đủ mọi bảng thuốc thành công. Chạy thiếu bảng (`dag_run.conf` không đủ tên) thì bỏ qua bước này.
- `drug_record_id`, `healthfacilities_id`, `use_date` lấy từ `emr_db_medical_records_drugs_key_chg`, ghi đè theo `drug_record_id`.

---

## Mapping cũ → mới

| Bảng cũ | Bảng mới |
|---|---|
| `emr_db_top10_thuoc_sd` | `emr_db_top10_thuoc_sd` *(giữ)* |
| `emr_db_top10_nhom_thuoc_sd` | `emr_db_top10_nhom_thuoc_sd` *(giữ)* |
| `emr_db_top10_hoat_chat_sd` | `emr_db_tong_hop_thuoc` |
| `emr_db_co_cau_chi_phi_sd_thuoc` | `emr_db_tong_hop_thuoc` |
| `emr_db_chi_phi_ks_theo_khoa` | `emr_db_tong_hop_thuoc` |
| `emr_db_tien_ks_theo_hoat_chat` | `emr_db_tong_hop_thuoc` |
| `emr_db_tien_ks_theo_duong_dung` | `emr_db_tong_hop_thuoc` |
| `emr_db_tien_ks_giua_noitru_ngoaitru` | `emr_db_tong_hop_thuoc_noi_ngoai` |
| `emr_db_tien_ks_ngoaitru_thang` | `emr_db_tong_hop_thuoc_noi_ngoai` |
| `emr_db_tien_ks_noitru_thang` | `emr_db_tong_hop_thuoc_noi_ngoai` |
| `emr_db_tien_ks_phan_nhom_tddl` | `emr_db_tong_hop_thuoc_phan_nhom` |
| `emr_db_tien_ks_theo_khoa_phan_nhom_tddl` | `emr_db_tong_hop_thuoc_phan_nhom` |
| `emr_db_tien_ks_theo_xuat_xu` | `emr_db_tong_hop_thuoc_xuat_xu` |

### Vì sao không gộp hết 1 bảng?

- Nhóm nguồn khác nhau → ETL/job tổng hợp khác nhau.
- Grain chiều tổng hợp khác nhau.
- `top10_thuoc` / `top10_nhom_thuoc` không join `cats_antibiotics` → giữ riêng.

---

## Index Dashboard (prod)

Mọi bảng (và `_stg` khi `CREATE TABLE ... LIKE`) có index dẫn đầu `(ma_csyt, ngay_su_dung)` để xóa theo cặp cơ sở + ngày.

| Bảng | Index |
|---|---|
| `emr_db_top10_thuoc_sd` | `(ma_csyt, ngay_su_dung, ma_thuoc)` |
| `emr_db_top10_nhom_thuoc_sd` | `(ma_csyt, ngay_su_dung, nhom_thuoc)` |
| `emr_db_tong_hop_thuoc` | `(ma_csyt, ngay_su_dung)`; `+ ma_hoat_chat`; `+ la_khang_sinh`; `+ khoa`; `+ duong_dung` |
| `emr_db_tong_hop_thuoc_noi_ngoai` | `(ma_csyt, ngay_su_dung, loai_dieu_tri)`; `+ thang_su_dung` |
| `emr_db_tong_hop_thuoc_phan_nhom` | `(ma_csyt, ngay_su_dung, phan_nhom)`; `(ma_csyt, ngay_su_dung, khoa, phan_nhom)` |
| `emr_db_tong_hop_thuoc_xuat_xu` | `(ma_csyt, ngay_su_dung, xuat_xu)` |
| `emr_db_tong_hop_ddd_khoa` | `(ma_csyt, nam, khoa)`; `+ ma_thuoc`. Xóa theo `(ma_csyt, nam)` |
| `emr_db_tong_hop_ddd_khoa_thang` | `(ma_csyt, nam, thang, khoa)`; `+ ma_thuoc`. Xóa theo `(ma_csyt, nam, thang)` |

---

## Tóm tắt kết quả

| # | Bảng (+ `_stg`) | Dashboard | Nguồn |
|---|---|---|---|
| 1 | `emr_db_top10_thuoc_sd` | Top 10 thuốc sử dụng | `medical_records_drugs` |
| 2 | `emr_db_top10_nhom_thuoc_sd` | Top 10 nhóm thuốc sử dụng | `medical_records_drugs`, `cats_drugs_groups`, `cats_emr_drugs` |
| 3 | `emr_db_tong_hop_thuoc` | Top 10 hoạt chất; Cơ cấu chi phí SD thuốc; Chi phí KS theo khoa; Tiền KS theo hoạt chất; Tiền KS theo đường dùng | `medical_records_drugs`, `cats_antibiotics` |
| 4 | `emr_db_tong_hop_thuoc_noi_ngoai` | Tiền KS nội–ngoại; KS ngoại trú theo tháng; KS nội trú theo tháng | `medical_records_drugs`, `cats_antibiotics`, `cats_type_examination`, `medical_records` |
| 5 | `emr_db_tong_hop_thuoc_phan_nhom` | Tiền KS phân nhóm TDDL; Tiền KS theo khoa phân nhóm TDDL | `medical_records_drugs`, `cats_antibiotics`, `cats_antibiotics_groups` |
| 6 | `emr_db_tong_hop_thuoc_xuat_xu` | Tiền KS theo xuất xứ | `medical_records_drugs`, `cats_antibiotics`, `cats_emr_drugs`, `manufacturer`, `country_registration` |
| 7 | `emr_db_tong_hop_ddd_khoa` | DDD theo khoa/100 ngày giường, grain năm | `medical_records_drugs`, `cats_antibiotics`, `treatment_department_days`, `cats_faculty` |
| 8 | `emr_db_tong_hop_ddd_khoa_thang` | DDD theo khoa/100 ngày giường, grain tháng | `medical_records_drugs`, `cats_antibiotics`, `treatment_days`, `cats_faculty` |

### Ghi lại theo ngày (mọi bảng)

Không upsert. Xóa mọi cặp trong `emr_db_changed_drug_pair` (cặp mới và cặp cũ nếu `drug_record_id` đổi cơ sở hoặc ngày), rồi insert phần staging. Dòng `is_delete = 1` hoặc `is_active = 0` không được cộng; cặp của dòng đó vẫn bị xóa trên đích.

```sql
DELETE t FROM <bảng> t
INNER JOIN emr_db_changed_drug_pair p
    ON t.ma_csyt = p.healthfacilities_id
   AND t.ngay_su_dung = p.use_date;

INSERT INTO <bảng> (...)
SELECT ... FROM <bảng>_stg;
```

`thoi_gian` không dùng làm khóa xóa vì luôn suy ra từ `ngay_su_dung`.

**DDL fact (prod + stg):** `pipeline/sql/table_merged.sql`.  
**DDL khóa:** `pipeline/sql/emr_db_medical_records_drugs_key.sql` — khóa dòng thuốc, khóa `treatment_department_days`, bảng năm DDD, khóa `treatment_days`, bảng tháng DDD.

---

## Việc cần làm tiếp (khi duyệt)

1. Tạo mới trên warehouse: chạy `pipeline/sql/table_merged.sql` rồi `pipeline/sql/emr_db_medical_records_drugs_key.sql`.
2. Deploy DAG medical (task `prepare_drug_keys` trước mọi job, `commit_drug_keys` sau khi cả 8 job thành công).
3. Cập nhật Dashboard / dynamic report nếu còn filter theo `cskcb` → dùng `ma_csyt`.
4. Địa bàn / tên CSYT / chỉ tiêu ghi `NULL` — core chỉ cần có cột. `ma_csyt` vẫn là mã cơ sở.
