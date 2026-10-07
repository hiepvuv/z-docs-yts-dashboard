-- ADD: fact dashboard trên emr_datawarehouse. Không gồm bảng key-pair.
-- Key-pair: pipeline/sql/DDL_cac_bang_key_pair.sql
-- UPDATE: nhóm và chương dùng CREATE OR REPLACE vì thêm cccd cạnh ma_bn. Chạy lại xóa dữ liệu hai bảng đó.
-- emr_db_tong_hop_benh và các fact lượt khám / CLS / PTTT bên dưới: CREATE OR REPLACE, xóa dữ liệu bảng đó rồi nạp lại.
-- Fact thuốc nằm ở pipeline/sql/DDL_cac_bang_dich.sql.

-- ADD: fact bệnh tật CN_308–CN_313 và staging.
-- Chạy trên emr_datawarehouse trước khi bật EMR_DASHBOARD_DISEASE_MASTER_DAG.
-- Không UNIQUE. Job xóa theo (ma_csyt, ngay_ghi_nhan) rồi insert từ _stg.
-- Cột địa bàn, tên CSYT, tuyến, hạng, chỉ tiêu để NULL. ma_csyt lấy từ hồ sơ.
-- Chi tiết: z_docs/dashboard/benh_tat.md

-- =============================================================================
-- 1) Bệnh theo nhóm — CN_308, CN_310, CN_279
-- Một mã ICD thuộc nhiều nhóm thì mỗi nhóm một dòng (số lượt / tử vong nhân theo nhóm).
-- so_ca không lưu: dashboard COUNT(DISTINCT ma_bn, cccd). Cộng so_ca theo ngày sẽ đếm trùng người.
-- =============================================================================
CREATE OR REPLACE TABLE emr_db_tong_hop_benh_nhom
(
    id                   bigint auto_increment primary key,
    ma_benh              varchar(50)                              null comment 'Mã bệnh ICD10, mrd.diseases_code',
    ten_benh             text                                     null comment 'Tên bệnh, mrd.diseases_name',
    ma_nhom              varchar(50)                              null comment 'Mã nhóm bệnh, cats_diseases_groups.code',
    ten_nhom             varchar(255)                             null comment 'Tên nhóm bệnh, cats_diseases_groups.name',
    ma_bn                varchar(150)                             null comment 'Mã người bệnh, medical_records.patient_code. NULL khi trống',
    cccd                 text                                     null comment 'CCCD, medical_records.citizen_identification',
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

CREATE OR REPLACE TABLE emr_db_tong_hop_benh_nhom_stg LIKE emr_db_tong_hop_benh_nhom;

-- =============================================================================
-- 2) Bệnh theo chương — CN_309, CN_312
-- Mỗi code_vi lấy một chapter_id (MAX) để mã ICD trùng trong cats_icd10 không nhân số.
-- so_ca không lưu: dashboard COUNT(DISTINCT ma_bn, cccd).
-- =============================================================================
CREATE OR REPLACE TABLE emr_db_tong_hop_benh_chuong
(
    id                   bigint auto_increment primary key,
    ma_benh              varchar(50)                              null comment 'Mã bệnh ICD10, mrd.diseases_code',
    ten_benh             text                                     null comment 'Tên bệnh, mrd.diseases_name',
    ma_chuong            varchar(50)                              null comment 'Mã chương, cats_icd10_chapters.code_vi',
    ten_chuong           varchar(255)                             null comment 'Tên chương, cats_icd10_chapters.name_vi',
    ma_bn                varchar(150)                             null comment 'Mã người bệnh, medical_records.patient_code. NULL khi trống',
    cccd                 text                                     null comment 'CCCD, medical_records.citizen_identification',
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

CREATE OR REPLACE TABLE emr_db_tong_hop_benh_chuong_stg LIKE emr_db_tong_hop_benh_chuong;

-- =============================================================================
-- 3) Bệnh theo mã — CN_311, CN_313
-- UPDATE: mỗi dòng chẩn đoán một hồ sơ, so_luot = 1. so_ngay_dieu_tri là số ngày của hồ sơ đó.
-- Dashboard CN_313 SUM(so_luot). CN_311 lấy MAX(so_ngay_dieu_tri), lọc loai_kham IN (3, 4, 9).
-- =============================================================================
CREATE OR REPLACE TABLE emr_db_tong_hop_benh
(
    id                   bigint auto_increment primary key,
    ma_benh              varchar(50)                              null comment 'Mã bệnh ICD10, mrd.diseases_code',
    ten_benh             text                                     null comment 'Tên bệnh, mrd.diseases_name',
    loai_kham            int(1)                                   null comment 'XML1.MA_LOAI_KCB, medical_records.type_of_examination',
    ngay_ghi_nhan        date                                     null comment 'DATE(recording_date). Khóa xóa cùng ma_csyt',
    ma_bn                varchar(150)                             null comment 'Mã người bệnh, medical_records.patient_code. NULL khi trống',
    ten_bn               text                                     null comment 'Họ tên người bệnh, medical_records.fullname. View chi tiết',
    cccd                 text                                     null comment 'CCCD, medical_records.citizen_identification',
    ngay_sinh            datetime                                 null comment 'Ngày sinh, medical_records.birthday',
    gioi_tinh            varchar(50)                              null comment 'Giới tính, medical_records.gender_id',
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
    so_luot              bigint                                   null comment '1 cho mỗi dòng chẩn đoán. Dashboard SUM',
    so_ngay_dieu_tri     decimal(10, 2)                           null comment 'Số ngày của hồ sơ, treatment_day_number. Dashboard lấy MAX, không SUM',
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

CREATE OR REPLACE TABLE emr_db_tong_hop_benh_stg LIKE emr_db_tong_hop_benh;

-- Key-pair của nhóm này nằm ở pipeline/sql/DDL_cac_bang_key_pair.sql.
-- Không tạo bảng khóa trong file fact.

-- ADD: fact lượt khám CN_264–CN_286. CN_279 đọc emr_db_tong_hop_benh_nhom, không tạo bảng ở đây.
-- Chạy trên emr_datawarehouse trước khi bật EMR_DASHBOARD_VISIT_MASTER_DAG.
-- UPDATE: tám fact lượt khám có cột chi tiết dùng CREATE OR REPLACE, xóa dữ liệu bảng đó và _stg.
-- CN_285 và CN_286 tách khỏi emr_db_tong_hop_luot_kham. Bảng lượt khám không còn cột tiền.
-- emr_db_tong_hop_luot_ra vẫn CREATE TABLE IF NOT EXISTS. Không đụng bảng thuốc, nhóm bệnh, chương bệnh.
-- Không UNIQUE. Job xóa theo khóa ngày rồi insert từ _stg.
-- Chi tiết: z_docs/dashboard/luot_kham.md

-- =============================================================================
-- 1) Lượt khám theo ngày vào — CN_264, CN_265, CN_267, CN_278, CN_280–CN_283
-- UPDATE: grain từng hồ sơ + ngày vào để view chi tiết. Dashboard SUM cột 0/1, bằng tổng theo ngày cũ.
-- so_ngay_dieu_tri chỉ của hồ sơ loại khám 3, 4, 9, chỉ CN_283.
-- UPDATE: bỏ tien_benh_nhan, tien_bao_hiem. CN_285 và CN_286 đọc fact riêng bên dưới.
-- =============================================================================
CREATE OR REPLACE TABLE emr_db_tong_hop_luot_kham
(
    id                   bigint auto_increment primary key,
    ngay_vao             date                                     null comment 'DATE(examination_date). Khóa xóa cùng ma_csyt',
    ma_bn                varchar(150)                             null comment 'Mã người bệnh, medical_records.patient_code. NULL khi trống',
    ten_bn               text                                     null comment 'Họ tên người bệnh, medical_records.fullname. View chi tiết',
    cccd                 text                                     null comment 'CCCD, medical_records.citizen_identification',
    ngay_sinh            datetime                                 null comment 'Ngày sinh, medical_records.birthday',
    gioi_tinh            varchar(50)                              null comment 'Giới tính, medical_records.gender_id',
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
    so_ho_so             bigint                                   null comment '1 cho mỗi hồ sơ có examination_date thuộc ngày. Dashboard SUM',
    so_ho_so_bh          bigint                                   null comment '1 nếu IFNULL(is_health_insurance, 0) = 1. Dashboard SUM',
    so_ho_so_khong_bh    bigint                                   null comment '1 nếu IFNULL(is_health_insurance, 0) khác 1. Dashboard SUM',
    so_cap_cuu           bigint                                   null comment '1 nếu reason_code = 2. Dashboard SUM',
    so_tu_vong           bigint                                   null comment '1 nếu treatment_result_id thuộc 5 hoặc 8. Dashboard SUM',
    so_noi_tru           bigint                                   null comment '1 nếu type_of_examination thuộc 3, 4, 9. Dashboard SUM. CN_267. CN_266 đọc emr_db_tong_hop_luot_vao_ra',
    so_ngoai_tru         bigint                                   null comment '1 nếu type_of_examination thuộc 2, 5, 6, 7, 8, 96, 97, 98. Dashboard SUM',
    so_tai_nan           bigint                                   null comment '1 nếu accident_type = 1. Dashboard SUM. CN_270 đọc emr_db_tong_hop_tai_nan',
    ten_tai_nan          varchar(255)                             null comment 'cats_accidents.name_vi khi accident_type = 1. NULL nếu không phải nguyên nhân tai nạn',
    so_ngay_dieu_tri     decimal(14, 2)                           null comment 'Số ngày của hồ sơ nội trú 3, 4, 9. Dashboard SUM. CN_283',
    thoi_gian_cap_nhat   date         default current_timestamp() null,
    nguoi_ghi_nhan       varchar(255) default 'admin datalake'    null,
    nguoi_cap_nhat       varchar(255) default 'admin datalake'    null,
    index idx_luot_csyt_ngay (ma_csyt(32), ngay_vao),
    index idx_luot_db (ma_tinh(16), ma_csyt(32), thoi_gian, ma_chi_tieu_bieu_do(24))
)
    charset = utf8mb3
    comment = 'Dashboard lượt khám theo ngày vào. Nguồn: medical_records, cats_accidents. Không gồm lượt ra, CN_285, CN_286.'
;

CREATE OR REPLACE TABLE emr_db_tong_hop_luot_kham_stg LIKE emr_db_tong_hop_luot_kham;

-- UPDATE: bảng đã tạo thì CREATE IF NOT EXISTS không sửa comment cột không BHYT
ALTER TABLE emr_db_tong_hop_luot_kham
    MODIFY so_ho_so_khong_bh bigint null comment '1 nếu IFNULL(is_health_insurance, 0) khác 1. Dashboard SUM';

-- ADD: ten_tai_nan cho bảng đã có. Không CREATE OR REPLACE nên không xóa dữ liệu.
ALTER TABLE emr_db_tong_hop_luot_kham
    ADD COLUMN IF NOT EXISTS ten_tai_nan varchar(255) null comment 'cats_accidents.name_vi khi accident_type = 1. NULL nếu không phải nguyên nhân tai nạn' AFTER so_tai_nan;
ALTER TABLE emr_db_tong_hop_luot_kham_stg
    ADD COLUMN IF NOT EXISTS ten_tai_nan varchar(255) null comment 'cats_accidents.name_vi khi accident_type = 1. NULL nếu không phải nguyên nhân tai nạn' AFTER so_tai_nan;

-- =============================================================================
-- Tai nạn theo tên — CN_270
-- UPDATE: grain hồ sơ + ngày vào + tên tai nạn. Không gộp vào emr_db_tong_hop_luot_kham
-- vì một ngày nhiều tên sẽ nhân so_ho_so, tiền và số ngày. so_luot = 1, dashboard SUM.
-- Khóa xóa vẫn (ma_csyt, ngay_vao), dùng chung emr_db_changed_record_pair.
-- =============================================================================
CREATE OR REPLACE TABLE emr_db_tong_hop_tai_nan
(
    id                   bigint auto_increment primary key,
    ngay_vao             date                                     null comment 'DATE(examination_date). Khóa xóa cùng ma_csyt',
    ten_tai_nan          varchar(255)                             null comment 'Tên nguyên nhân tai nạn, cats_accidents.name_vi, accident_type = 1',
    ma_bn                varchar(150)                             null comment 'Mã người bệnh, medical_records.patient_code. NULL khi trống',
    ten_bn               text                                     null comment 'Họ tên người bệnh, medical_records.fullname. View chi tiết',
    cccd                 text                                     null comment 'CCCD, medical_records.citizen_identification',
    ngay_sinh            datetime                                 null comment 'Ngày sinh, medical_records.birthday',
    gioi_tinh            varchar(50)                              null comment 'Giới tính, medical_records.gender_id',
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
    so_luot              bigint                                   null comment '1 cho mỗi hồ sơ của tên tai nạn. Dashboard SUM',
    thoi_gian_cap_nhat   date         default current_timestamp() null,
    nguoi_ghi_nhan       varchar(255) default 'admin datalake'    null,
    nguoi_cap_nhat       varchar(255) default 'admin datalake'    null,
    index idx_tn_csyt_ngay (ma_csyt(32), ngay_vao),
    index idx_tn_ten (ma_csyt(32), ngay_vao, ten_tai_nan(64)),
    index idx_tn_db (ma_tinh(16), ma_csyt(32), thoi_gian, ma_chi_tieu_bieu_do(24))
)
    charset = utf8mb3
    comment = 'Dashboard CN_270. Nguồn: medical_records, cats_accidents. Một ngày nhiều tên tai nạn thì mỗi tên một dòng.'
;

CREATE OR REPLACE TABLE emr_db_tong_hop_tai_nan_stg LIKE emr_db_tong_hop_tai_nan;

-- =============================================================================
-- Lượt ra cũ — không còn job. CN_266 đọc emr_db_tong_hop_luot_vao_ra.
-- Giữ CREATE để lần chạy DDL không đụng bảng đã có. Có thể DROP sau khi fact mới đã chạy.
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
    comment = 'Không còn pipeline. CN_266 đã chuyển sang emr_db_tong_hop_luot_vao_ra.'
;

CREATE TABLE IF NOT EXISTS emr_db_tong_hop_luot_ra_stg LIKE emr_db_tong_hop_luot_ra;

-- =============================================================================
-- CN_266 — lượt vào và lượt ra trên cùng một ngày biểu đồ
-- UPDATE: grain hồ sơ + ngay_theo_doi. Dashboard SUM hai cột theo ngày, không UNION.
-- Lượt vào: examination_date, loại khám 3, 4, 9. Lượt ra: finish_examination_date, mọi hồ sơ.
-- Khóa xóa (ma_csyt, ngay_theo_doi) vì cặp đổi đã gồm cả ngày vào và ngày ra.
-- =============================================================================
CREATE OR REPLACE TABLE emr_db_tong_hop_luot_vao_ra
(
    id                   bigint auto_increment primary key,
    ngay_theo_doi        date                                     null comment 'Ngày trên biểu đồ. Lượt vào là DATE(examination_date), lượt ra là DATE(finish_examination_date)',
    ma_bn                varchar(150)                             null comment 'Mã người bệnh, medical_records.patient_code. NULL khi trống',
    ten_bn               text                                     null comment 'Họ tên người bệnh, medical_records.fullname. View chi tiết',
    cccd                 text                                     null comment 'CCCD, medical_records.citizen_identification',
    ngay_sinh            datetime                                 null comment 'Ngày sinh, medical_records.birthday',
    gioi_tinh            varchar(50)                              null comment 'Giới tính, medical_records.gender_id',
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
    so_luot_vao          bigint                                   null comment '1 nếu hồ sơ nội trú vào đúng ngày, ngược lại 0. Dashboard SUM',
    so_luot_ra           bigint                                   null comment '1 nếu hồ sơ ra đúng ngày, ngược lại 0. Dashboard SUM',
    thoi_gian_cap_nhat   date         default current_timestamp() null,
    nguoi_ghi_nhan       varchar(255) default 'admin datalake'    null,
    nguoi_cap_nhat       varchar(255) default 'admin datalake'    null,
    index idx_vr_csyt_ngay (ma_csyt(32), ngay_theo_doi),
    index idx_vr_db (ma_tinh(16), ma_csyt(32), thoi_gian, ma_chi_tieu_bieu_do(24))
)
    charset = utf8mb3
    comment = 'Dashboard CN_266. Một dòng một ngày: so_luot_vao và so_luot_ra. Nguồn: medical_records.'
;

CREATE OR REPLACE TABLE emr_db_tong_hop_luot_vao_ra_stg LIKE emr_db_tong_hop_luot_vao_ra;

-- =============================================================================
-- CN_268 — BHYT / Không BHYT theo ngày vào
-- UPDATE: grain hồ sơ + ngày vào + loại, luot = 1. Ngày thiếu một loại vẫn một dòng luot = 0.
-- Dashboard SUM(luot). Tool không đọc subquery nên loại nằm sẵn trên dòng.
-- =============================================================================
CREATE OR REPLACE TABLE emr_db_tong_hop_luot_bhyt
(
    id                   bigint auto_increment primary key,
    ngay_vao             date                                     null comment 'DATE(examination_date). Khóa xóa cùng ma_csyt',
    loai                 varchar(50)                              null comment 'BHYT khi IFNULL(is_health_insurance, 0) = 1. Không BHYT khi giá trị đó khác 1',
    ma_bn                varchar(150)                             null comment 'Mã người bệnh, medical_records.patient_code. NULL khi trống',
    ten_bn               text                                     null comment 'Họ tên người bệnh, medical_records.fullname. View chi tiết',
    cccd                 text                                     null comment 'CCCD, medical_records.citizen_identification',
    ngay_sinh            datetime                                 null comment 'Ngày sinh, medical_records.birthday',
    gioi_tinh            varchar(50)                              null comment 'Giới tính, medical_records.gender_id',
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
    luot                 bigint                                   null comment '1 nếu hồ sơ thuộc loại. Dòng giữ chỗ của loại vắng ghi 0. Dashboard SUM',
    thoi_gian_cap_nhat   date         default current_timestamp() null,
    nguoi_ghi_nhan       varchar(255) default 'admin datalake'    null,
    nguoi_cap_nhat       varchar(255) default 'admin datalake'    null,
    index idx_bh_csyt_ngay (ma_csyt(32), ngay_vao),
    index idx_bh_loai (ma_csyt(32), ngay_vao, loai),
    index idx_bh_db (ma_tinh(16), ma_csyt(32), thoi_gian, ma_chi_tieu_bieu_do(24))
)
    charset = utf8mb3
    comment = 'Dashboard CN_268. Nguồn: medical_records.is_health_insurance. Mỗi loại một dòng.'
;

CREATE OR REPLACE TABLE emr_db_tong_hop_luot_bhyt_stg LIKE emr_db_tong_hop_luot_bhyt;

-- =============================================================================
-- CN_269 — cấp cứu / tử vong theo ngày vào
-- UPDATE: grain hồ sơ + ngày vào + loại, luot = 1. Một hồ sơ có thể vào cả hai loại.
-- Ngày thiếu một loại vẫn một dòng luot = 0. Dashboard SUM(luot).
-- =============================================================================
CREATE OR REPLACE TABLE emr_db_tong_hop_cap_cuu_tu_vong
(
    id                   bigint auto_increment primary key,
    ngay_vao             date                                     null comment 'DATE(examination_date). Khóa xóa cùng ma_csyt',
    loai                 varchar(50)                              null comment 'Cấp cứu khi reason_code = 2. Tử vong khi treatment_result_id thuộc 5 hoặc 8',
    ma_bn                varchar(150)                             null comment 'Mã người bệnh, medical_records.patient_code. NULL khi trống',
    ten_bn               text                                     null comment 'Họ tên người bệnh, medical_records.fullname. View chi tiết',
    cccd                 text                                     null comment 'CCCD, medical_records.citizen_identification',
    ngay_sinh            datetime                                 null comment 'Ngày sinh, medical_records.birthday',
    gioi_tinh            varchar(50)                              null comment 'Giới tính, medical_records.gender_id',
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
    luot                 bigint                                   null comment '1 nếu hồ sơ thuộc loại. Dòng giữ chỗ của loại vắng ghi 0. Dashboard SUM',
    thoi_gian_cap_nhat   date         default current_timestamp() null,
    nguoi_ghi_nhan       varchar(255) default 'admin datalake'    null,
    nguoi_cap_nhat       varchar(255) default 'admin datalake'    null,
    index idx_cc_csyt_ngay (ma_csyt(32), ngay_vao),
    index idx_cc_loai (ma_csyt(32), ngay_vao, loai),
    index idx_cc_db (ma_tinh(16), ma_csyt(32), thoi_gian, ma_chi_tieu_bieu_do(24))
)
    charset = utf8mb3
    comment = 'Dashboard CN_269. Nguồn: medical_records.reason_code, treatment_result_id. Mỗi loại một dòng.'
;

CREATE OR REPLACE TABLE emr_db_tong_hop_cap_cuu_tu_vong_stg LIKE emr_db_tong_hop_cap_cuu_tu_vong;

-- =============================================================================
-- 3) Nhóm chi phí dịch vụ — CN_284
-- Grain: cơ sở + DATE(decision_date) + nhóm chi phí + mã hồ sơ.
-- UPDATE: thêm họ tên, CCCD, ngày sinh, giới tính theo ma_hs. COUNT(DISTINCT ma_hs) không đổi.
-- ma_hs giữ lại vì COUNT(DISTINCT) theo tháng không bằng SUM số hồ sơ từng ngày.
-- ma_csyt varchar(255) khớp medical_records_services.healthfacilities_id.
-- examination_date của bảng dịch vụ đang trống trên lake; không dùng cột đó làm ngày.
-- =============================================================================
CREATE OR REPLACE TABLE emr_db_tong_hop_nhom_dich_vu
(
    id                   bigint auto_increment primary key,
    ngay_y_lenh          date                                     null comment 'DATE(decision_date). Khóa xóa cùng ma_csyt',
    ma_nhom              varchar(50)                              null comment 'Mã nhóm chi phí, cats_cost_groups.code_vi',
    ten_nhom             varchar(255)                             null comment 'Tên nhóm chi phí, cats_cost_groups.name_vi',
    ma_hs                int                                      null comment 'medical_records_services.medical_record_id. Dashboard COUNT(DISTINCT)',
    ma_bn                varchar(150)                             null comment 'Mã người bệnh, medical_records.patient_code. NULL khi trống',
    ten_bn               text                                     null comment 'Họ tên người bệnh, medical_records.fullname. View chi tiết',
    cccd                 text                                     null comment 'CCCD, medical_records.citizen_identification',
    ngay_sinh            datetime                                 null comment 'Ngày sinh, medical_records.birthday',
    gioi_tinh            varchar(50)                              null comment 'Giới tính, medical_records.gender_id',
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

CREATE OR REPLACE TABLE emr_db_tong_hop_nhom_dich_vu_stg LIKE emr_db_tong_hop_nhom_dich_vu;

-- =============================================================================
-- CN_285 — cơ cấu chi phí theo 18 nhóm
-- UPDATE: không gộp vào emr_db_tong_hop_luot_kham. Một hồ sơ × 18 nhóm sẽ nhân so_ho_so và số ngày.
-- Nguồn: medical_records full join cats_cost_groups code_vi 1–18. Tiền là cột trên hồ sơ, không phải dòng dịch vụ.
-- Mã 5, 6, 9, 11 đang is_delete = 1 trên danh mục; vẫn lấy vì Excel map đủ 18 cột.
-- Grain: hồ sơ + ngày vào + nhóm. tien_dich_vu = 0 vẫn ghi để tháng nào cũng đủ nhóm.
-- Khóa xóa (ma_csyt, ngay_vao), dùng chung emr_db_changed_record_pair.
-- Cột tiền nguồn là decimal(15,2). Fact để decimal(20,3).
-- =============================================================================
CREATE OR REPLACE TABLE emr_db_tong_hop_nhom_chi_phi
(
    id                   bigint auto_increment primary key,
    ngay_vao             date                                     null comment 'DATE(examination_date). Khóa xóa cùng ma_csyt',
    ma_nhom              varchar(50)                              null comment 'Mã nhóm chi phí, cats_cost_groups.code_vi 1–18',
    ten_nhom             varchar(255)                             null comment 'Tên nhóm, name_vi đã bỏ tab và xuống dòng',
    ma_bn                varchar(150)                             null comment 'Mã người bệnh, medical_records.patient_code. NULL khi trống',
    ten_bn               text                                     null comment 'Họ tên người bệnh, medical_records.fullname. View chi tiết',
    cccd                 text                                     null comment 'CCCD, medical_records.citizen_identification',
    ngay_sinh            datetime                                 null comment 'Ngày sinh, medical_records.birthday',
    gioi_tinh            varchar(50)                              null comment 'Giới tính, medical_records.gender_id',
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
    tien_dich_vu         decimal(20, 3)                           null comment 'Tiền của nhóm trên hồ sơ. Dashboard SUM. 0 vẫn lưu',
    thoi_gian_cap_nhat   date         default current_timestamp() null,
    nguoi_ghi_nhan       varchar(255) default 'admin datalake'    null,
    nguoi_cap_nhat       varchar(255) default 'admin datalake'    null,
    index idx_ncp_csyt_ngay (ma_csyt(32), ngay_vao),
    index idx_ncp_nhom (ma_csyt(32), ngay_vao, ma_nhom),
    index idx_ncp_db (ma_tinh(16), ma_csyt(32), thoi_gian, ma_chi_tieu_bieu_do(24))
)
    charset = utf8mb3
    comment = 'Dashboard CN_285. Nguồn: medical_records, cats_cost_groups code_vi 1–18. Một hồ sơ 18 dòng.'
;

CREATE OR REPLACE TABLE emr_db_tong_hop_nhom_chi_phi_stg LIKE emr_db_tong_hop_nhom_chi_phi;

-- =============================================================================
-- CN_286 — tiền không bảo hiểm và tiền bảo hiểm
-- UPDATE: không đọc emr_db_tong_hop_luot_kham. Công thức cũ cộng patient_pay_together_money vào tiền bệnh nhân
-- và bỏ external_capacity_money, other_souces_money.
-- tien_khong_bh = patient_money + external_capacity_money + other_souces_money.
-- tien_bao_hiem = insurance_money + patient_pay_together_money.
-- Tỉ lệ % tính lúc đọc, không lưu. Grain: hồ sơ + ngày vào.
-- =============================================================================
CREATE OR REPLACE TABLE emr_db_tong_hop_chi_phi_bh
(
    id                   bigint auto_increment primary key,
    ngay_vao             date                                     null comment 'DATE(examination_date). Khóa xóa cùng ma_csyt',
    ma_bn                varchar(150)                             null comment 'Mã người bệnh, medical_records.patient_code. NULL khi trống',
    ten_bn               text                                     null comment 'Họ tên người bệnh, medical_records.fullname. View chi tiết',
    cccd                 text                                     null comment 'CCCD, medical_records.citizen_identification',
    ngay_sinh            datetime                                 null comment 'Ngày sinh, medical_records.birthday',
    gioi_tinh            varchar(50)                              null comment 'Giới tính, medical_records.gender_id',
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
    tien_khong_bh        decimal(20, 3)                           null comment 'patient_money + external_capacity_money + other_souces_money. Dashboard SUM',
    tien_bao_hiem        decimal(20, 3)                           null comment 'insurance_money + patient_pay_together_money. Dashboard SUM',
    thoi_gian_cap_nhat   date         default current_timestamp() null,
    nguoi_ghi_nhan       varchar(255) default 'admin datalake'    null,
    nguoi_cap_nhat       varchar(255) default 'admin datalake'    null,
    index idx_cpbh_csyt_ngay (ma_csyt(32), ngay_vao),
    index idx_cpbh_db (ma_tinh(16), ma_csyt(32), thoi_gian, ma_chi_tieu_bieu_do(24))
)
    charset = utf8mb3
    comment = 'Dashboard CN_286. Nguồn: medical_records. Tỉ lệ tiền tính lúc đọc.'
;

CREATE OR REPLACE TABLE emr_db_tong_hop_chi_phi_bh_stg LIKE emr_db_tong_hop_chi_phi_bh;

-- Key-pair của nhóm này nằm ở pipeline/sql/DDL_cac_bang_key_pair.sql.
-- Không tạo bảng khóa trong file fact.

-- ADD: fact cận lâm sàng và PTTT CN_296–CN_301 và staging.
-- Chạy trên emr_datawarehouse trước khi bật EMR_DASHBOARD_CLINICAL_MASTER_DAG.
-- UPDATE: emr_db_tong_hop_cls và emr_db_tong_hop_pttt dùng CREATE OR REPLACE, xóa dữ liệu hai bảng và _stg.
-- Không UNIQUE. Job xóa theo khóa ngày rồi insert từ _stg.
-- Chi tiết: z_docs/dashboard/cls_pttt.md

-- =============================================================================
-- 1) Cận lâm sàng — CN_296 xét nghiệm, CN_297 siêu âm, CN_298 X-quang, CN_299 CT/MRI
-- UPDATE: grain cơ sở hồ sơ + DATE(decision_date) + code_vi + record_service_id.
-- Nguồn emr_datalake: medical_records_services, medical_records, cats_services_groups_reports(_details).
-- so_luot = 1. Biểu đồ COUNT(DISTINCT id_dich_vu) vì một mã dịch vụ có thể thuộc hai nhóm.
-- =============================================================================
CREATE OR REPLACE TABLE emr_db_tong_hop_cls
(
    id                   bigint auto_increment primary key,
    ngay_thuc_hien       date                                     null comment 'DATE(medical_records_services.decision_date). Khóa xóa cùng ma_csyt',
    ma_nhom              varchar(255)                             null comment 'cats_services_groups_reports.code_vi',
    ten_nhom             varchar(255)                             null comment 'name_vi của nhóm báo cáo',
    ma_bn                varchar(150)                             null comment 'Mã người bệnh, medical_records.patient_code. NULL khi trống',
    ten_bn               text                                     null comment 'Họ tên người bệnh, medical_records.fullname. View chi tiết',
    cccd                 text                                     null comment 'CCCD, medical_records.citizen_identification',
    ngay_sinh            datetime                                 null comment 'Ngày sinh, medical_records.birthday',
    gioi_tinh            varchar(50)                              null comment 'Giới tính, medical_records.gender_id',
    thoi_gian            int                                      null comment 'Thời gian của dòng, định dạng yyyyMMdd',
    ma_tinh              varchar(50)                              null comment 'Mã tỉnh/thành phố của cơ sở y tế',
    ten_tinh             varchar(255)                             null comment 'Tên tỉnh/thành phố',
    ma_xa                varchar(50)                              null comment 'Mã xã/phường của cơ sở y tế',
    ten_xa               varchar(255)                             null comment 'Tên xã/phường',
    ma_csyt              varchar(255)                             null comment 'Mã cơ sở, medical_records.healthfacilities_id',
    ten_csyt             varchar(255)                             null comment 'Tên cơ sở, chưa có trên dòng dịch vụ',
    tuyen_csyt           varchar(10)                              null comment 'Tuyến cơ sở, chưa có trên dòng dịch vụ',
    hang_csyt            varchar(10)                              null comment 'Hạng cơ sở, chưa có trên dòng dịch vụ',
    ma_chi_tieu_bieu_do  varchar(50)                              null comment 'Mã chỉ tiêu biểu đồ, dùng để lọc đúng nhóm số liệu',
    ma_chi_tieu_canh_bao varchar(50)                              null comment 'Mã chỉ tiêu cảnh báo, để trống vì màn này không có ngưỡng cảnh báo',
    ten_chi_tieu         varchar(255)                             null comment 'Tên chỉ tiêu bằng tiếng Việt',
    ngay                 varchar(50)                              null comment 'Ngày, tách từ cột thời gian',
    thang                varchar(10)                              null comment 'Tháng, tách từ cột thời gian, dùng cho bộ lọc Tháng',
    nam                  varchar(10)                              null comment 'Năm, tách từ cột thời gian, dùng cho bộ lọc Năm',
    id_dich_vu           int                                      null comment 'medical_records_services.record_service_id. Dashboard COUNT(DISTINCT)',
    so_luot              bigint                                   null comment '1 cho mỗi cặp dòng dịch vụ và mã nhóm',
    thoi_gian_cap_nhat   date         default current_timestamp() null,
    nguoi_ghi_nhan       varchar(255) default 'admin datalake'    null,
    nguoi_cap_nhat       varchar(255) default 'admin datalake'    null,
    index idx_cls_csyt_ngay (ma_csyt(64), ngay_thuc_hien),
    index idx_cls_nhom (ma_csyt(64), ngay_thuc_hien, ma_nhom(16)),
    index idx_cls_db (ma_tinh(16), ma_csyt(64), thoi_gian, ma_chi_tieu_bieu_do(24))
)
    charset = utf8mb3
    comment = 'Dashboard CN_296–CN_299. Nguồn: dòng dịch vụ và nhóm báo cáo. Lọc ma_nhom lúc đọc.'
;

CREATE OR REPLACE TABLE emr_db_tong_hop_cls_stg LIKE emr_db_tong_hop_cls;

-- =============================================================================
-- 2) Phẫu thuật / thủ thuật — CN_300, CN_301
-- UPDATE: grain hồ sơ + DATE(decision_date). Cờ 0/1, dashboard SUM bằng COUNT(DISTINCT) cũ.
-- so_phau_thuat = 1 khi hồ sơ có cost_group_id 8. so_thu_thuat = 1 khi có nhóm 18.
-- =============================================================================
CREATE OR REPLACE TABLE emr_db_tong_hop_pttt
(
    id                   bigint auto_increment primary key,
    ngay_y_lenh          date                                     null comment 'DATE(decision_date). Khóa xóa cùng ma_csyt',
    ma_bn                varchar(150)                             null comment 'Mã người bệnh, medical_records.patient_code. NULL khi trống',
    ten_bn               text                                     null comment 'Họ tên người bệnh, medical_records.fullname. View chi tiết',
    cccd                 text                                     null comment 'CCCD, medical_records.citizen_identification',
    ngay_sinh            datetime                                 null comment 'Ngày sinh, medical_records.birthday',
    gioi_tinh            varchar(50)                              null comment 'Giới tính, medical_records.gender_id',
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
    so_phau_thuat        bigint                                   null comment '1 nếu hồ sơ có dịch vụ cost_group_id = 8 trong ngày. Dashboard SUM. CN_300',
    so_thu_thuat         bigint                                   null comment '1 nếu hồ sơ có dịch vụ cost_group_id = 18 trong ngày. Dashboard SUM. CN_301',
    thoi_gian_cap_nhat   date         default current_timestamp() null,
    nguoi_ghi_nhan       varchar(255) default 'admin datalake'    null,
    nguoi_cap_nhat       varchar(255) default 'admin datalake'    null,
    index idx_pttt_csyt_ngay (ma_csyt(64), ngay_y_lenh),
    index idx_pttt_db (ma_tinh(16), ma_csyt(64), thoi_gian, ma_chi_tieu_bieu_do(24))
)
    charset = utf8mb3
    comment = 'Dashboard CN_300–CN_301. Nguồn: medical_records_services, medical_records, cats_cost_groups.'
;

CREATE OR REPLACE TABLE emr_db_tong_hop_pttt_stg LIKE emr_db_tong_hop_pttt;

-- Key-pair của nhóm này nằm ở pipeline/sql/DDL_cac_bang_key_pair.sql.
-- Không tạo bảng khóa trong file fact.

