-- ADD: fact dashboard trên emr_datawarehouse. Không gồm bảng key-pair.
-- Key-pair: pipeline/sql/DDL_cac_bang_key_pair.sql
-- CREATE TABLE IF NOT EXISTS: chạy lại không xóa fact đã có.
-- Fact thuốc nằm ở pipeline/sql/DDL_cac_bang_dich.sql.

-- ADD: fact bệnh tật CN_308–CN_313 và staging.
-- Chạy trên emr_datawarehouse trước khi bật EMR_DASHBOARD_DISEASE_MASTER_DAG.
-- Không UNIQUE. Job xóa theo (ma_csyt, ngay_ghi_nhan) rồi insert từ _stg.
-- Cột địa bàn, tên CSYT, tuyến, hạng, chỉ tiêu để NULL. ma_csyt lấy từ hồ sơ.
-- Chi tiết: z_docs/dashboard/benh_tat.md

-- =============================================================================
-- 1) Bệnh theo nhóm — CN_308, CN_310, CN_279
-- Một mã ICD thuộc nhiều nhóm thì mỗi nhóm một dòng (số lượt / tử vong nhân theo nhóm).
-- so_ca không lưu: dashboard COUNT(DISTINCT ma_bn). Cộng so_ca theo ngày sẽ đếm trùng người.
-- =============================================================================
CREATE TABLE IF NOT EXISTS emr_db_tong_hop_benh_nhom
(
    id                   bigint auto_increment primary key,
    ma_benh              varchar(50)                              null comment 'Mã bệnh ICD10, mrd.diseases_code',
    ten_benh             text                                     null comment 'Tên bệnh, mrd.diseases_name',
    ma_nhom              varchar(50)                              null comment 'Mã nhóm bệnh, cats_diseases_groups.code',
    ten_nhom             varchar(255)                             null comment 'Tên nhóm bệnh, cats_diseases_groups.name',
    ma_bn                varchar(255)                             null comment 'Mã người bệnh, medical_records.patient_code. NULL khi trống',
    ngay_ghi_nhan        date                                     null comment 'DATE(recording_date). Khóa xóa cùng ma_csyt',
    thoi_gian            int                                      null comment 'Thời gian của dòng, định dạng yyyyMMdd',
    ma_tinh              varchar(50)                              null comment 'Mã tỉnh/thành phố của cơ sở y tế',
    ten_tinh             varchar(255)                             null comment 'Tên tỉnh/thành phố',
    ma_xa                varchar(50)                              null comment 'Mã xã/phường của cơ sở y tế',
    ten_xa               varchar(255)                             null comment 'Tên xã/phường',
    ma_csyt              varchar(50)                              null comment 'Mã cơ sở khám chữa bệnh',
    ten_csyt             varchar(255)                             null comment 'Tên cơ sở khám chữa bệnh',
    tuyen_csyt           varchar(10)                              null comment 'Tuyến của cơ sở khám chữa bệnh',
    hang_csyt            varchar(10)                              null comment 'Hạng của cơ sở khám chữa bệnh',
    ma_chi_tieu_bieu_do  varchar(50)                              null comment 'Mã chỉ tiêu biểu đồ, dùng để lọc đúng nhóm số liệu',
    ma_chi_tieu_canh_bao varchar(50)                              null comment 'Mã chỉ tiêu cảnh báo, để trống vì màn này không có ngưỡng cảnh báo',
    ten_chi_tieu         varchar(255)                             null comment 'Tên chỉ tiêu bằng tiếng Việt',
    ngay                 varchar(50)                              null comment 'Ngày, tách từ cột thời gian',
    thang                varchar(10)                              null comment 'Tháng, tách từ cột thời gian, dùng cho bộ lọc Tháng',
    nam                  varchar(10)                              null comment 'Năm, tách từ cột thời gian, dùng cho bộ lọc Năm',
    so_luot              bigint                                   null comment 'Số dòng chẩn đoán ra viện trong grain',
    so_tu_vong           bigint                                   null comment 'Số dòng có treatment_result_id = 5',
    thoi_gian_cap_nhat   date         default current_timestamp() null,
    nguoi_ghi_nhan       varchar(255) default 'admin datalake'    null,
    nguoi_cap_nhat       varchar(255) default 'admin datalake'    null,
    index idx_nhom_csyt_ngay (ma_csyt(32), ngay_ghi_nhan),
    index idx_nhom_benh (ma_csyt(32), ngay_ghi_nhan, ma_nhom(32), ma_benh(32)),
    index idx_nhom_db (ma_tinh(16), ma_csyt(32), thoi_gian, ma_chi_tieu_bieu_do(24))
)
    charset = utf8mb3
    comment = 'Dashboard CN_308, CN_310, CN_279. Nguồn: medical_records, medical_records_diagnoses_discharge, cats_diseases_groups_details, cats_diseases_groups. Một ICD nhiều nhóm thì tính ở từng nhóm.'
;

CREATE TABLE IF NOT EXISTS emr_db_tong_hop_benh_nhom_stg LIKE emr_db_tong_hop_benh_nhom;

-- =============================================================================
-- 2) Bệnh theo chương — CN_309, CN_312
-- Mỗi code_vi lấy một chapter_id (MAX) để mã ICD trùng trong cats_icd10 không nhân số.
-- so_ca không lưu: dashboard COUNT(DISTINCT ma_bn).
-- =============================================================================
CREATE TABLE IF NOT EXISTS emr_db_tong_hop_benh_chuong
(
    id                   bigint auto_increment primary key,
    ma_benh              varchar(50)                              null comment 'Mã bệnh ICD10, mrd.diseases_code',
    ten_benh             text                                     null comment 'Tên bệnh, mrd.diseases_name',
    ma_chuong            varchar(50)                              null comment 'Mã chương, cats_icd10_chapters.code_vi',
    ten_chuong           varchar(255)                             null comment 'Tên chương, cats_icd10_chapters.name_vi',
    ma_bn                varchar(255)                             null comment 'Mã người bệnh, medical_records.patient_code. NULL khi trống',
    ngay_ghi_nhan        date                                     null comment 'DATE(recording_date). Khóa xóa cùng ma_csyt',
    thoi_gian            int                                      null comment 'Thời gian của dòng, định dạng yyyyMMdd',
    ma_tinh              varchar(50)                              null comment 'Mã tỉnh/thành phố của cơ sở y tế',
    ten_tinh             varchar(255)                             null comment 'Tên tỉnh/thành phố',
    ma_xa                varchar(50)                              null comment 'Mã xã/phường của cơ sở y tế',
    ten_xa               varchar(255)                             null comment 'Tên xã/phường',
    ma_csyt              varchar(50)                              null comment 'Mã cơ sở khám chữa bệnh',
    ten_csyt             varchar(255)                             null comment 'Tên cơ sở khám chữa bệnh',
    tuyen_csyt           varchar(10)                              null comment 'Tuyến của cơ sở khám chữa bệnh',
    hang_csyt            varchar(10)                              null comment 'Hạng của cơ sở khám chữa bệnh',
    ma_chi_tieu_bieu_do  varchar(50)                              null comment 'Mã chỉ tiêu biểu đồ, dùng để lọc đúng nhóm số liệu',
    ma_chi_tieu_canh_bao varchar(50)                              null comment 'Mã chỉ tiêu cảnh báo, để trống vì màn này không có ngưỡng cảnh báo',
    ten_chi_tieu         varchar(255)                             null comment 'Tên chỉ tiêu bằng tiếng Việt',
    ngay                 varchar(50)                              null comment 'Ngày, tách từ cột thời gian',
    thang                varchar(10)                              null comment 'Tháng, tách từ cột thời gian, dùng cho bộ lọc Tháng',
    nam                  varchar(10)                              null comment 'Năm, tách từ cột thời gian, dùng cho bộ lọc Năm',
    so_luot              bigint                                   null comment 'Số dòng chẩn đoán ra viện trong grain',
    so_tu_vong           bigint                                   null comment 'Số dòng có treatment_result_id = 5',
    thoi_gian_cap_nhat   date         default current_timestamp() null,
    nguoi_ghi_nhan       varchar(255) default 'admin datalake'    null,
    nguoi_cap_nhat       varchar(255) default 'admin datalake'    null,
    index idx_chuong_csyt_ngay (ma_csyt(32), ngay_ghi_nhan),
    index idx_chuong_benh (ma_csyt(32), ngay_ghi_nhan, ma_chuong(32), ma_benh(32)),
    index idx_chuong_db (ma_tinh(16), ma_csyt(32), thoi_gian, ma_chi_tieu_bieu_do(24))
)
    charset = utf8mb3
    comment = 'Dashboard CN_309, CN_312. Nguồn: medical_records, medical_records_diagnoses_discharge, cats_icd10, cats_icd10_chapters.'
;

CREATE TABLE IF NOT EXISTS emr_db_tong_hop_benh_chuong_stg LIKE emr_db_tong_hop_benh_chuong;

-- =============================================================================
-- 3) Bệnh theo mã — CN_311, CN_313
-- so_ngay_dieu_tri là MAX trong grain (số ngày của hồ sơ lặp trên mọi dòng chẩn đoán).
-- Dashboard CN_311 lấy MAX, không SUM. Lọc loai_kham IN (3, 4, 9) lúc đọc.
-- =============================================================================
CREATE TABLE IF NOT EXISTS emr_db_tong_hop_benh
(
    id                   bigint auto_increment primary key,
    ma_benh              varchar(50)                              null comment 'Mã bệnh ICD10, mrd.diseases_code',
    ten_benh             text                                     null comment 'Tên bệnh, mrd.diseases_name',
    loai_kham            int(1)                                   null comment 'XML1.MA_LOAI_KCB, medical_records.type_of_examination',
    ngay_ghi_nhan        date                                     null comment 'DATE(recording_date). Khóa xóa cùng ma_csyt',
    thoi_gian            int                                      null comment 'Thời gian của dòng, định dạng yyyyMMdd',
    ma_tinh              varchar(50)                              null comment 'Mã tỉnh/thành phố của cơ sở y tế',
    ten_tinh             varchar(255)                             null comment 'Tên tỉnh/thành phố',
    ma_xa                varchar(50)                              null comment 'Mã xã/phường của cơ sở y tế',
    ten_xa               varchar(255)                             null comment 'Tên xã/phường',
    ma_csyt              varchar(50)                              null comment 'Mã cơ sở khám chữa bệnh',
    ten_csyt             varchar(255)                             null comment 'Tên cơ sở khám chữa bệnh',
    tuyen_csyt           varchar(10)                              null comment 'Tuyến của cơ sở khám chữa bệnh',
    hang_csyt            varchar(10)                              null comment 'Hạng của cơ sở khám chữa bệnh',
    ma_chi_tieu_bieu_do  varchar(50)                              null comment 'Mã chỉ tiêu biểu đồ, dùng để lọc đúng nhóm số liệu',
    ma_chi_tieu_canh_bao varchar(50)                              null comment 'Mã chỉ tiêu cảnh báo, để trống vì màn này không có ngưỡng cảnh báo',
    ten_chi_tieu         varchar(255)                             null comment 'Tên chỉ tiêu bằng tiếng Việt',
    ngay                 varchar(50)                              null comment 'Ngày, tách từ cột thời gian',
    thang                varchar(10)                              null comment 'Tháng, tách từ cột thời gian, dùng cho bộ lọc Tháng',
    nam                  varchar(10)                              null comment 'Năm, tách từ cột thời gian, dùng cho bộ lọc Năm',
    so_luot              bigint                                   null comment 'Số dòng chẩn đoán ra viện trong grain',
    so_ngay_dieu_tri     decimal(10, 2)                           null comment 'MAX số ngày điều trị nội trú trong grain. Dashboard lấy MAX, không SUM. Nguồn treatment_day_number varchar',
    thoi_gian_cap_nhat   date         default current_timestamp() null,
    nguoi_ghi_nhan       varchar(255) default 'admin datalake'    null,
    nguoi_cap_nhat       varchar(255) default 'admin datalake'    null,
    index idx_benh_csyt_ngay (ma_csyt(32), ngay_ghi_nhan),
    index idx_benh_loai (ma_csyt(32), ngay_ghi_nhan, ma_benh(32), loai_kham),
    index idx_benh_db (ma_tinh(16), ma_csyt(32), thoi_gian, ma_chi_tieu_bieu_do(24))
)
    charset = utf8mb3
    comment = 'Dashboard CN_311, CN_313. Nguồn: medical_records, medical_records_diagnoses_discharge. so_ngay_dieu_tri lặp theo hồ sơ, đọc bằng MAX.'
;

CREATE TABLE IF NOT EXISTS emr_db_tong_hop_benh_stg LIKE emr_db_tong_hop_benh;

-- Key-pair của nhóm này nằm ở pipeline/sql/DDL_cac_bang_key_pair.sql.
-- Không tạo bảng khóa trong file fact.

-- ADD: fact lượt khám CN_264–CN_286. CN_279 đọc emr_db_tong_hop_benh_nhom, không tạo bảng ở đây.
-- Chạy trên emr_datawarehouse trước khi bật EMR_DASHBOARD_VISIT_MASTER_DAG.
-- CREATE TABLE IF NOT EXISTS: chạy lại không xóa fact đã có, không đụng bảng thuốc hoặc bệnh.
-- Không UNIQUE. Job xóa theo khóa ngày rồi insert từ _stg.
-- Chi tiết: z_docs/dashboard/luot_kham.md

-- =============================================================================
-- 1) Lượt khám theo ngày vào — CN_264–CN_270, CN_278, CN_280–CN_283, CN_285, CN_286
-- Grain: cơ sở + DATE(examination_date). Số cộng được theo ngày nên biểu đồ tháng SUM lúc đọc.
-- so_ngay_dieu_tri chỉ cộng hồ sơ loại khám 3, 4, 9. Tỉ lệ tiền CN_286 tính lúc đọc, không lưu.
-- =============================================================================
CREATE TABLE IF NOT EXISTS emr_db_tong_hop_luot_kham
(
    id                   bigint auto_increment primary key,
    ngay_vao             date                                     null comment 'DATE(examination_date). Khóa xóa cùng ma_csyt',
    thoi_gian            int                                      null comment 'Thời gian của dòng, định dạng yyyyMMdd',
    ma_tinh              varchar(50)                              null comment 'Mã tỉnh/thành phố của cơ sở y tế',
    ten_tinh             varchar(255)                             null comment 'Tên tỉnh/thành phố',
    ma_xa                varchar(50)                              null comment 'Mã xã/phường của cơ sở y tế',
    ten_xa               varchar(255)                             null comment 'Tên xã/phường',
    ma_csyt              varchar(50)                              null comment 'Mã cơ sở khám chữa bệnh, medical_records.healthfacilities_id',
    ten_csyt             varchar(255)                             null comment 'Tên cơ sở khám chữa bệnh',
    tuyen_csyt           varchar(10)                              null comment 'Tuyến của cơ sở khám chữa bệnh',
    hang_csyt            varchar(10)                              null comment 'Hạng của cơ sở khám chữa bệnh',
    ma_chi_tieu_bieu_do  varchar(50)                              null comment 'Mã chỉ tiêu biểu đồ, dùng để lọc đúng nhóm số liệu',
    ma_chi_tieu_canh_bao varchar(50)                              null comment 'Mã chỉ tiêu cảnh báo, để trống vì màn này không có ngưỡng cảnh báo',
    ten_chi_tieu         varchar(255)                             null comment 'Tên chỉ tiêu bằng tiếng Việt',
    ngay                 varchar(50)                              null comment 'Ngày, tách từ cột thời gian',
    thang                varchar(10)                              null comment 'Tháng, tách từ cột thời gian, dùng cho bộ lọc Tháng',
    nam                  varchar(10)                              null comment 'Năm, tách từ cột thời gian, dùng cho bộ lọc Năm',
    so_ho_so             bigint                                   null comment 'Số hồ sơ có examination_date thuộc ngày',
    so_ho_so_bh          bigint                                   null comment 'Số hồ sơ is_health_insurance = 1',
    so_ho_so_khong_bh    bigint                                   null comment 'Số hồ sơ is_health_insurance = 0',
    so_cap_cuu           bigint                                   null comment 'Số hồ sơ reason_code = 2',
    so_tu_vong           bigint                                   null comment 'Số hồ sơ treatment_result_id thuộc 5 hoặc 8',
    so_noi_tru           bigint                                   null comment 'Số hồ sơ type_of_examination thuộc 3, 4, 9. CN_266 gọi là lượt vào',
    so_ngoai_tru         bigint                                   null comment 'Số hồ sơ type_of_examination thuộc 2, 5, 6, 7, 8, 96, 97, 98',
    so_tai_nan           bigint                                   null comment 'Số hồ sơ có cats_accidents.accident_type = 1',
    so_ngay_dieu_tri     decimal(14, 2)                           null comment 'Tổng treatment_day_number của hồ sơ nội trú 3, 4, 9 trong ngày. Đọc bằng SUM',
    tien_benh_nhan       decimal(20, 3)                           null comment 'Tổng patient_money + patient_pay_together_money',
    tien_bao_hiem        decimal(20, 3)                           null comment 'Tổng insurance_money',
    thoi_gian_cap_nhat   date         default current_timestamp() null,
    nguoi_ghi_nhan       varchar(255) default 'admin datalake'    null,
    nguoi_cap_nhat       varchar(255) default 'admin datalake'    null,
    index idx_luot_csyt_ngay (ma_csyt(32), ngay_vao),
    index idx_luot_db (ma_tinh(16), ma_csyt(32), thoi_gian, ma_chi_tieu_bieu_do(24))
)
    charset = utf8mb3
    comment = 'Dashboard lượt khám theo ngày vào. Nguồn: medical_records, cats_accidents. Không gồm lượt ra.'
;

CREATE TABLE IF NOT EXISTS emr_db_tong_hop_luot_kham_stg LIKE emr_db_tong_hop_luot_kham;

-- =============================================================================
-- 2) Lượt ra — CN_266
-- Grain: cơ sở + DATE(finish_examination_date). Khóa xóa khác ngày vào nên tách bảng.
-- =============================================================================
CREATE TABLE IF NOT EXISTS emr_db_tong_hop_luot_ra
(
    id                   bigint auto_increment primary key,
    ngay_ra              date                                     null comment 'DATE(finish_examination_date). Khóa xóa cùng ma_csyt',
    thoi_gian            int                                      null comment 'Thời gian của dòng, định dạng yyyyMMdd',
    ma_tinh              varchar(50)                              null comment 'Mã tỉnh/thành phố của cơ sở y tế',
    ten_tinh             varchar(255)                             null comment 'Tên tỉnh/thành phố',
    ma_xa                varchar(50)                              null comment 'Mã xã/phường của cơ sở y tế',
    ten_xa               varchar(255)                             null comment 'Tên xã/phường',
    ma_csyt              varchar(50)                              null comment 'Mã cơ sở khám chữa bệnh, medical_records.healthfacilities_id',
    ten_csyt             varchar(255)                             null comment 'Tên cơ sở khám chữa bệnh',
    tuyen_csyt           varchar(10)                              null comment 'Tuyến của cơ sở khám chữa bệnh',
    hang_csyt            varchar(10)                              null comment 'Hạng của cơ sở khám chữa bệnh',
    ma_chi_tieu_bieu_do  varchar(50)                              null comment 'Mã chỉ tiêu biểu đồ, dùng để lọc đúng nhóm số liệu',
    ma_chi_tieu_canh_bao varchar(50)                              null comment 'Mã chỉ tiêu cảnh báo, để trống vì màn này không có ngưỡng cảnh báo',
    ten_chi_tieu         varchar(255)                             null comment 'Tên chỉ tiêu bằng tiếng Việt',
    ngay                 varchar(50)                              null comment 'Ngày, tách từ cột thời gian',
    thang                varchar(10)                              null comment 'Tháng, tách từ cột thời gian, dùng cho bộ lọc Tháng',
    nam                  varchar(10)                              null comment 'Năm, tách từ cột thời gian, dùng cho bộ lọc Năm',
    so_luot_ra           bigint                                   null comment 'Số hồ sơ có finish_examination_date thuộc ngày. Không lọc loại khám',
    thoi_gian_cap_nhat   date         default current_timestamp() null,
    nguoi_ghi_nhan       varchar(255) default 'admin datalake'    null,
    nguoi_cap_nhat       varchar(255) default 'admin datalake'    null,
    index idx_ra_csyt_ngay (ma_csyt(32), ngay_ra),
    index idx_ra_db (ma_tinh(16), ma_csyt(32), thoi_gian, ma_chi_tieu_bieu_do(24))
)
    charset = utf8mb3
    comment = 'Dashboard CN_266 lượt ra. Nguồn: medical_records.finish_examination_date.'
;

CREATE TABLE IF NOT EXISTS emr_db_tong_hop_luot_ra_stg LIKE emr_db_tong_hop_luot_ra;

-- =============================================================================
-- 3) Nhóm chi phí dịch vụ — CN_284
-- Grain: cơ sở + DATE(decision_date) + nhóm chi phí + mã hồ sơ.
-- ma_hs giữ lại vì COUNT(DISTINCT) theo tháng không bằng SUM số hồ sơ từng ngày.
-- ma_csyt varchar(255) khớp medical_records_services.healthfacilities_id.
-- examination_date của bảng dịch vụ đang trống trên lake; không dùng cột đó làm ngày.
-- =============================================================================
CREATE TABLE IF NOT EXISTS emr_db_tong_hop_nhom_dich_vu
(
    id                   bigint auto_increment primary key,
    ngay_y_lenh          date                                     null comment 'DATE(decision_date). Khóa xóa cùng ma_csyt',
    ma_nhom              varchar(50)                              null comment 'Mã nhóm chi phí, cats_cost_groups.code_vi',
    ten_nhom             varchar(255)                             null comment 'Tên nhóm chi phí, cats_cost_groups.name_vi',
    ma_hs                int                                      null comment 'medical_records_services.medical_record_id. Dashboard COUNT(DISTINCT)',
    thoi_gian            int                                      null comment 'Thời gian của dòng, định dạng yyyyMMdd',
    ma_tinh              varchar(50)                              null comment 'Mã tỉnh/thành phố của cơ sở y tế',
    ten_tinh             varchar(255)                             null comment 'Tên tỉnh/thành phố',
    ma_xa                varchar(50)                              null comment 'Mã xã/phường của cơ sở y tế',
    ten_xa               varchar(255)                             null comment 'Tên xã/phường',
    ma_csyt              varchar(255)                             null comment 'Mã cơ sở, medical_records_services.healthfacilities_id',
    ten_csyt             varchar(255)                             null comment 'Tên cơ sở khám chữa bệnh',
    tuyen_csyt           varchar(10)                              null comment 'Tuyến của cơ sở khám chữa bệnh',
    hang_csyt            varchar(10)                              null comment 'Hạng của cơ sở khám chữa bệnh',
    ma_chi_tieu_bieu_do  varchar(50)                              null comment 'Mã chỉ tiêu biểu đồ, dùng để lọc đúng nhóm số liệu',
    ma_chi_tieu_canh_bao varchar(50)                              null comment 'Mã chỉ tiêu cảnh báo, để trống vì màn này không có ngưỡng cảnh báo',
    ten_chi_tieu         varchar(255)                             null comment 'Tên chỉ tiêu bằng tiếng Việt',
    ngay                 varchar(50)                              null comment 'Ngày, tách từ cột thời gian',
    thang                varchar(10)                              null comment 'Tháng, tách từ cột thời gian, dùng cho bộ lọc Tháng',
    nam                  varchar(10)                              null comment 'Năm, tách từ cột thời gian, dùng cho bộ lọc Năm',
    thoi_gian_cap_nhat   date         default current_timestamp() null,
    nguoi_ghi_nhan       varchar(255) default 'admin datalake'    null,
    nguoi_cap_nhat       varchar(255) default 'admin datalake'    null,
    index idx_dv_csyt_ngay (ma_csyt(64), ngay_y_lenh),
    index idx_dv_nhom (ma_csyt(64), ngay_y_lenh, ma_nhom, ma_hs),
    index idx_dv_db (ma_tinh(16), ma_csyt(64), thoi_gian, ma_chi_tieu_bieu_do(24))
)
    charset = utf8mb3
    comment = 'Dashboard CN_284. Nguồn: medical_records_services, medical_records, cats_cost_groups. Đếm hồ sơ lúc đọc.'
;

CREATE TABLE IF NOT EXISTS emr_db_tong_hop_nhom_dich_vu_stg LIKE emr_db_tong_hop_nhom_dich_vu;

-- Key-pair của nhóm này nằm ở pipeline/sql/DDL_cac_bang_key_pair.sql.
-- Không tạo bảng khóa trong file fact.

-- ADD: fact cận lâm sàng và PTTT CN_296–CN_301 và staging.
-- Chạy trên emr_datawarehouse trước khi bật EMR_DASHBOARD_CLINICAL_MASTER_DAG.
-- CREATE TABLE IF NOT EXISTS: chạy lại không xóa fact đã có, không đụng bảng thuốc, bệnh, lượt khám.
-- Không UNIQUE. Job xóa theo khóa ngày rồi insert từ _stg.
-- Chi tiết: z_docs/dashboard/cls_pttt.md

-- =============================================================================
-- 1) Cận lâm sàng — CN_296 xét nghiệm, CN_297 siêu âm, CN_298 X-quang, CN_299 CT/MRI
-- Grain: cơ sở + ngày (từ thoi_gian yyyyMMdd) + ma_nhom_dich_vu_report.
-- so_luot là SUM(so_luot) của bảng báo cáo. Đếm dòng sẽ đếm dòng danh mục, không phải lượt.
-- Nguồn emr_datawarehouse.report_medical_records_service, không nằm trên emr_datalake.
-- =============================================================================
CREATE TABLE IF NOT EXISTS emr_db_tong_hop_cls
(
    id                   bigint auto_increment primary key,
    ngay_thuc_hien       date                                     null comment 'Ngày từ thoi_gian yyyyMMdd. Khóa xóa cùng ma_csyt',
    ma_nhom              varchar(255)                             null comment 'ma_nhom_dich_vu_report. 9 xét nghiệm; 6-8 siêu âm; 1-2 X-quang; 3-5 CT/MRI',
    ten_nhom             varchar(255)                             null comment 'MAX(nhom_dich_vu_report) trong grain',
    thoi_gian            int                                      null comment 'Thời gian của dòng, định dạng yyyyMMdd',
    ma_tinh              varchar(50)                              null comment 'Mã tỉnh/thành phố của cơ sở y tế',
    ten_tinh             varchar(255)                             null comment 'Tên tỉnh/thành phố',
    ma_xa                varchar(50)                              null comment 'Mã xã/phường của cơ sở y tế',
    ten_xa               varchar(255)                             null comment 'Tên xã/phường',
    ma_csyt              varchar(255)                             null comment 'Mã cơ sở, report_medical_records_service.ma_csyt',
    ten_csyt             varchar(255)                             null comment 'Tên cơ sở, lấy từ bảng báo cáo',
    tuyen_csyt           varchar(10)                              null comment 'Tuyến cơ sở, lấy từ bảng báo cáo',
    hang_csyt            varchar(10)                              null comment 'Hạng cơ sở, lấy từ bảng báo cáo',
    ma_chi_tieu_bieu_do  varchar(50)                              null comment 'Mã chỉ tiêu biểu đồ, dùng để lọc đúng nhóm số liệu',
    ma_chi_tieu_canh_bao varchar(50)                              null comment 'Mã chỉ tiêu cảnh báo, để trống vì màn này không có ngưỡng cảnh báo',
    ten_chi_tieu         varchar(255)                             null comment 'Tên chỉ tiêu bằng tiếng Việt',
    ngay                 varchar(50)                              null comment 'Ngày, tách từ cột thời gian',
    thang                varchar(10)                              null comment 'Tháng, tách từ cột thời gian, dùng cho bộ lọc Tháng',
    nam                  varchar(10)                              null comment 'Năm, tách từ cột thời gian, dùng cho bộ lọc Năm',
    so_luot              bigint                                   null comment 'SUM(so_luot) của các dòng báo cáo cùng cơ sở, ngày, nhóm',
    thoi_gian_cap_nhat   date         default current_timestamp() null,
    nguoi_ghi_nhan       varchar(255) default 'admin datalake'    null,
    nguoi_cap_nhat       varchar(255) default 'admin datalake'    null,
    index idx_cls_csyt_ngay (ma_csyt(64), ngay_thuc_hien),
    index idx_cls_nhom (ma_csyt(64), ngay_thuc_hien, ma_nhom(16)),
    index idx_cls_db (ma_tinh(16), ma_csyt(64), thoi_gian, ma_chi_tieu_bieu_do(24))
)
    charset = utf8mb3
    comment = 'Dashboard CN_296–CN_299. Nguồn: report_medical_records_service. Lọc ma_nhom lúc đọc.'
;

CREATE TABLE IF NOT EXISTS emr_db_tong_hop_cls_stg LIKE emr_db_tong_hop_cls;

-- =============================================================================
-- 2) Phẫu thuật / thủ thuật — CN_300, CN_301
-- Grain: cơ sở + DATE(decision_date). Hai cột vì hai mã nhóm trên cùng một ngày.
-- so_phau_thuat = COUNT(DISTINCT hồ sơ) cost_group_id 8. so_thu_thuat = nhóm 18.
-- =============================================================================
CREATE TABLE IF NOT EXISTS emr_db_tong_hop_pttt
(
    id                   bigint auto_increment primary key,
    ngay_y_lenh          date                                     null comment 'DATE(decision_date). Khóa xóa cùng ma_csyt',
    thoi_gian            int                                      null comment 'Thời gian của dòng, định dạng yyyyMMdd',
    ma_tinh              varchar(50)                              null comment 'Mã tỉnh/thành phố của cơ sở y tế',
    ten_tinh             varchar(255)                             null comment 'Tên tỉnh/thành phố',
    ma_xa                varchar(50)                              null comment 'Mã xã/phường của cơ sở y tế',
    ten_xa               varchar(255)                             null comment 'Tên xã/phường',
    ma_csyt              varchar(255)                             null comment 'Mã cơ sở, medical_records_services.healthfacilities_id',
    ten_csyt             varchar(255)                             null comment 'Tên cơ sở khám chữa bệnh',
    tuyen_csyt           varchar(10)                              null comment 'Tuyến của cơ sở khám chữa bệnh',
    hang_csyt            varchar(10)                              null comment 'Hạng của cơ sở khám chữa bệnh',
    ma_chi_tieu_bieu_do  varchar(50)                              null comment 'Mã chỉ tiêu biểu đồ, dùng để lọc đúng nhóm số liệu',
    ma_chi_tieu_canh_bao varchar(50)                              null comment 'Mã chỉ tiêu cảnh báo, để trống vì màn này không có ngưỡng cảnh báo',
    ten_chi_tieu         varchar(255)                             null comment 'Tên chỉ tiêu bằng tiếng Việt',
    ngay                 varchar(50)                              null comment 'Ngày, tách từ cột thời gian',
    thang                varchar(10)                              null comment 'Tháng, tách từ cột thời gian, dùng cho bộ lọc Tháng',
    nam                  varchar(10)                              null comment 'Năm, tách từ cột thời gian, dùng cho bộ lọc Năm',
    so_phau_thuat        bigint                                   null comment 'Số hồ sơ có dòng dịch vụ cost_group_id = 8 trong ngày. CN_300',
    so_thu_thuat         bigint                                   null comment 'Số hồ sơ có dòng dịch vụ cost_group_id = 18 trong ngày. CN_301',
    thoi_gian_cap_nhat   date         default current_timestamp() null,
    nguoi_ghi_nhan       varchar(255) default 'admin datalake'    null,
    nguoi_cap_nhat       varchar(255) default 'admin datalake'    null,
    index idx_pttt_csyt_ngay (ma_csyt(64), ngay_y_lenh),
    index idx_pttt_db (ma_tinh(16), ma_csyt(64), thoi_gian, ma_chi_tieu_bieu_do(24))
)
    charset = utf8mb3
    comment = 'Dashboard CN_300–CN_301. Nguồn: medical_records_services, medical_records, cats_cost_groups.'
;

CREATE TABLE IF NOT EXISTS emr_db_tong_hop_pttt_stg LIKE emr_db_tong_hop_pttt;

-- Key-pair của nhóm này nằm ở pipeline/sql/DDL_cac_bang_key_pair.sql.
-- Không tạo bảng khóa trong file fact.

