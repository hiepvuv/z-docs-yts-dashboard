create table cats_antibiotics
(
    antibiotic_id          int auto_increment
        primary key,
    healthfacilities_id    varchar(50)                          not null comment 'ID CSKCB (cats_healthfacilities.code_vi)',
    drug_code              varchar(255)                         null comment 'Mã thuốc',
    brand_drug_name        varchar(1024)                        not null comment 'Tên biệt dược',
    active_ingredient_name varchar(1024)                        not null comment 'Hoạt chất',
    active_ingredient_code varchar(255)                         null comment 'Mã hoạt chất',
    unit                   varchar(255)                         null comment 'Đơn vị tính',
    unit_prices            decimal(10, 2)                       null comment 'Đơn giá',
    drug_concentration     varchar(255)                         null comment 'Hàm lượng thuốc',
    dosage_form            varchar(1024)                        null comment 'Dạng bào chế',
    antibiotic_group_id    varchar(100)                         null comment 'Nhóm kháng sinh (cats_antibiotics_groups.antibiotic_group_id)',
    qd5631_id              varchar(50)                          null comment 'Phân loại KS theo QĐ 5631 (cats_antibiotics_qd5631.qd5631_id)',
    method_id              varchar(50)                          null comment 'Mã đường dùng (bảng cats_methods)',
    method_name            varchar(255)                         null comment 'Tên đường dùng',
    concentration_who_ddd  decimal(10, 2)                       null comment 'Hàm lượng quy đổi theo đơn vị WHO DDD',
    concentration_unit     varchar(255)                         null comment 'Đơn vị của hàm lượng 2',
    ddd_who                decimal(10, 2)                       null comment 'DDD WHO',
    ddd_unit               varchar(255)                         null comment 'Đơn vị DDD',
    atc_code               varchar(255)                         null comment 'Mã ATC',
    antibiotic_aware_id    int                                  null comment 'Phân loại theo AWARE (cats_antibiotics_aware.antibiotic_aware_id)',
    order_number           int(4)   default 0                   not null,
    is_delete              bit      default b'0'                not null,
    is_active              bit      default b'1'                not null,
    create_user_id         varchar(50)                          null,
    create_date            datetime default current_timestamp() null,
    update_user_id         varchar(50)                          null,
    update_date            datetime default current_timestamp() null on update current_timestamp()
)
    comment 'Danh mục thuốc kháng sinh tại bệnh viện' row_format = DYNAMIC;

create table cats_antibiotics_groups
(
    antibiotic_group_id   varchar(100)                         not null
        primary key,
    antibiotic_group_name varchar(255)                         not null comment 'Tên nhóm thuốc kháng sinh',
    order_number          int(4)                               null,
    is_delete             bit      default b'0'                not null,
    is_active             bit      default b'1'                not null,
    create_user_id        varchar(50)                          null,
    create_date           datetime default current_timestamp() not null,
    update_user_id        varchar(50)                          null,
    update_date           datetime default current_timestamp() null on update current_timestamp()
)
    comment 'Danh mục nhóm thuốc kháng sinh' row_format = DYNAMIC;

create table cats_drugs_groups
(
    drugs_group_id        int           null,
    drugs_group_parent_id int           null,
    code_vi               varchar(50)   null,
    name_vi               varchar(1024) null,
    name_en               varchar(255)  null,
    system_url            varchar(255)  null,
    defining_url          varchar(255)  null,
    version               varchar(255)  null,
    order_number          int(4)        null,
    description           varchar(1000) null,
    is_delete             bit           null,
    is_active             bit           null,
    create_user_id        varchar(50)   null,
    create_date           datetime      null,
    update_user_id        varchar(50)   null,
    update_date           datetime      null
);

create table cats_emr_drugs
(
    drug_id                    int            null,
    drug_code                  varchar(45)    null,
    drug_name                  varchar(1024)  null,
    drug_fullname              varchar(1024)  null,
    registration_number        varchar(255)   null,
    unit                       varchar(45)    null,
    specifications             varchar(400)   null,
    drug_concentration         varchar(1000)  null,
    active_ingredient_code     varchar(1000)  null,
    active_ingredient_name     varchar(1000)  null,
    active_ingredient_register varchar(1000)  null,
    method_name                varchar(255)   null,
    method_code                varchar(255)   null,
    dosage_form                varchar(1000)  null,
    used                       varchar(45)    null,
    country_manufacture        varchar(400)   null,
    manufacturer               varchar(1024)  null,
    country_registration       varchar(45)    null,
    drug_order                 varchar(45)    null,
    is_insurance               bit            null,
    cost_group_id              int            null,
    drugs_group_id             int            null,
    is_delete                  bit            null,
    is_active                  bit            null,
    create_user_id             varchar(50)    null,
    create_date                datetime       not null,
    update_user_id             varchar(50)    null,
    update_date                datetime       null,
    contractor_name            varchar(1000)  null,
    tender_info                text           null,
    bid_type                   int            null,
    bid_method                 int            null,
    drug_type                  int            null,
    healthfacilities_id        varchar(255)   null,
    hd_from                    datetime       null,
    hd_to                      datetime       null,
    from_date                  datetime       null,
    to_date                    datetime       null,
    healthfacilities_name      varchar(1000)  null,
    service_code               varchar(1024)  null,
    quality_standard           varchar(100)   null,
    medicinal_part             int            null,
    scientific_name            varchar(1000)  null,
    root_source                text           null,
    process_method             varchar(1024)  null,
    medicinal_herb_import      varchar(50)    null,
    medicinal_herb_process     varchar(50)    null,
    loss_rate_process          decimal(10, 2) null,
    loss_rate_preserve         decimal(10, 2) null,
    drug_healthfacilities_id   varchar(255)   null,
    drug_healthfacilities_name varchar(1000)  null,
    order_number               bigint         null,
    quantity                   int            null,
    unit_price                 decimal(20, 3) null,
    insurance_unit_price       decimal(20, 3) null,
    atc_code                   varchar(250)   null,
    brand_drug_name            varchar(250)   null,
    drug_group_id              varchar(250)   null,
    m_drug_group_id            varchar(50)    null
);

create table cats_faculty
(
    faculty_id            int auto_increment
        primary key,
    byt_code_vi           varchar(255)                         null,
    byt_name_vi           varchar(255)                         null,
    code_vi               varchar(50)                          not null,
    name_vi               varchar(255)                         not null,
    name_en               varchar(255)                         null,
    healthfacilities_id   varchar(255)                         null comment 'khoa phòng thuộc csyt',
    is_show_full          bit      default b'0'                not null,
    system_url            varchar(255)                         null,
    defining_url          varchar(255)                         null,
    version               varchar(255)                         null,
    order_number          int(4)   default 0                   not null,
    description           varchar(1000)                        null,
    avatar                varchar(1000)                        null,
    is_delete             bit      default b'0'                not null,
    is_active             bit      default b'1'                not null,
    create_user_id        varchar(50)                          null,
    create_date           datetime default current_timestamp() not null,
    update_user_id        varchar(50)                          null,
    update_date           datetime default current_timestamp() null on update current_timestamp(),
    bed_number_actual     int                                  null comment 'Số giường thực kê',
    bed_number_approval   int                                  null comment 'Số giường phê duyệt',
    bed_number_emergency  int                                  null comment 'Số giường hồi sức cấp cứu',
    bed_number_intensive  int                                  null comment 'Số giường hồi sức tích cực',
    table_number_exam     int                                  null comment 'Số bàn khám',
    from_date             datetime                             null,
    to_date               datetime                             null,
    healthfacilities_name varchar(255)                         null
)
    comment 'Danh mục khoa EMR';

create table cats_type_examination
(
    type_id        int                                  not null
        primary key,
    code_vi        varchar(50)                          null,
    code_byt       varchar(50)                          null,
    name_vi        varchar(255)                         not null,
    name_en        varchar(255)                         null,
    system_url     varchar(255)                         null,
    defining_url   varchar(255)                         null,
    version        varchar(50)                          null,
    order_number   int(4)   default 0                   not null,
    group_type     int(4)                               not null comment '(1=Ngoại trú, 2= Nội trú, 3=Khám sức khỏe, 4=Khác)',
    description    varchar(1000)                        null,
    avatar         varchar(1000)                        null,
    is_delete      bit      default b'0'                not null,
    is_active      bit      default b'1'                not null,
    create_user_id varchar(50)                          null,
    create_date    datetime default current_timestamp() not null,
    update_user_id varchar(50)                          null,
    update_date    datetime default current_timestamp() null on update current_timestamp(),
    in_out_patient int                                  null
)
    comment 'Danh mục loại hình khám chữa bệnh (824/QĐ-BYT)';

create table medical_records
(
    medical_record_id              int auto_increment
        primary key,
    medical_identifier_code        varchar(255)                               null comment 'Mã định danh y tế cá nhân',
    medical_record_type_id         varchar(255)                               null comment 'ID loại hồ sơ bệnh án (bảng cats_medical_record_types.medical_record_type_id)  --> [cv365.ThongTinBenhNhan.loaiba]',
    medical_record_number          varchar(255)                               null comment 'XML1.MA_LK hoặc  [cv365.ThongTinBenhNhan.sovaovien]',
    patient_code                   varchar(255)                               null comment 'XML1.MA_BN hoặc [cv365.ThongTinBenhNhan.mabenhnhan]',
    order_number                   bigint                                     null comment 'XML1.STT',
    fullname                       text                                       null comment 'XML1.HO_TEN hoặc [cv365.ThongTinBenhNhan.hoten]',
    citizen_identification         text                                       null comment 'XML1.SO_CCCD hoặc [cv365.ThongTinBenhNhan.cccd_so]',
    birthday                       datetime                                   not null comment 'XML1.NGAY_SINH hoặc [cv365.ThongTinBenhNhan.ngaysinh]',
    gender_id                      varchar(255)                               null comment 'XML1.GIOI_TINH hoặc [cv365.ThongTinBenhNhan.gioitinh]',
    blood_abo                      varchar(255)                               null comment 'XML1.NHOM_MAU hoặc [cv365.ThongTinBenhNhan.nhommau]',
    blood_rh                       varchar(50)                                null comment '[cv365.ThongTinBenhNhan.yeutorh]',
    nation_id                      varchar(255)                               null comment 'XML1.MA_QUOCTICH (cats_nations.nation_id)',
    ethnicity_id                   varchar(255)                               null comment 'XML1.MA_DANTOC (cats_ethnicities.ethnicity_id) hoặc [cv365.ThongTinBenhNhan.dantoc_ma]',
    ethnicity_name                 text                                       null comment '[cv365.ThongTinBenhNhan.dantoc]',
    job_id                         varchar(255)                               null comment 'XML1.MA_NGHE_NGHIEP (Bảng cats_jobs.job_id) hoặc [cv365.ThongTinBenhNhan.nghenghiep_ma]',
    job_name                       text                                       null comment '[cv365.ThongTinBenhNhan.nghenghiep]',
    address                        text                                       null comment 'XML1.DIA_CHI hoặc [cv365.ThongTinBenhNhan.diachi]',
    province_id                    varchar(255)                               null comment 'XML1.MATINH_CU_TRU (cats_provinces.province_id)  hoặc [cv365.ThongTinBenhNhan.tinhthanh_ma]',
    district_id                    varchar(255)                               null comment 'XML1.MAHUYEN_CU_TRU  hoặc [cv365.ThongTinBenhNhan.quanhuyen_ma]',
    ward_id                        varchar(255)                               null comment 'XML1.MAXA_CU_TRU (cats_wards.ward_id)',
    phone_number                   text                                       null comment 'XML1.DIEN_THOAI hoặc [cv365.ThongTinBenhNhan.sodienthoai]',
    health_insurance_number        text                                       null comment 'XML1.MA_THE_BHYT hoặc [cv365.ThongTinBenhNhan.mabhyt]',
    initial_healthfacilities_id    text                                       null comment 'XML1.MA_DKBD (cats_healthfacilities.healthfacilities_id) hoặc [cv365.ThongTinBenhNhan.noidangkykcbbd]',
    from_date                      datetime                                   null comment 'XML1.GT_THE_TU hoặc [cv365.ThongTinBenhNhan.tungaybhyt]',
    to_date                        datetime                                   null comment 'XML1.GT_THE_DEN hoặc [cv365.ThongTinBenhNhan.denngaybhyt]',
    free_charge_date               datetime                                   null comment 'XML1.NGAY_MIEN_CCT',
    reasons_medical_examination    text                                       null comment 'Lý do khám (XM1.LY_DO_VV)',
    reason_treatment               text                                       null comment 'XML1.LY_DO_VNT',
    reason_treatment_code          varchar(255)                               null comment 'XML1.MA_LY_DO_VNT',
    preliminary_diagnosis          text                                       null comment 'XML1.CHAN_DOAN_VAO hoặc [cv365.ThongTinVaoVien.chandoanvaovien]',
    concludes_disease              text                                       null comment 'XML1.CHAN_DOAN_RV (Kết luận bệnh)',
    diseases_code                  varchar(50)                                null comment 'XML1.MA_BENH_CHINH (Bảng cats_icd10.code_vi)',
    comorbidities_code             varchar(1000)                              null comment 'XML1.MA_BENH_KT  (Bảng cats_icd10.code_vi)',
    diseases_tm_code               varchar(1000)                              null comment 'XML1.MA_BENH_YHCT  (Bảng cats_diseases_tm.code_vi)',
    international_surgical_code    varchar(255)                               null comment 'XML1.MA_PTTT_QT (Bảng cats_icd9.icd9_id)',
    reason_code                    varchar(50)                                null comment 'XML1.MA_DOITUONG_KCB (Bảng cats_examination_object.code_vi)',
    healthfacilities_delivery_id   varchar(50)                                null comment 'XML1.MA_NOI_DI (Bảng cats_healthfacilities.healthfacilities_id)',
    healthfacilities_arrive_id     varchar(50)                                null comment ' XML1.MA_NOI_DEN (Bảng cats_healthfacilities.healthfacilities_id)',
    accident_id                    varchar(50)                                null comment 'XML1.MA_TAI_NAN (Bảng cats_accidents.accident_id)',
    examination_date               datetime                                   not null comment 'XML1.NGAY_VAO hoặc [cv365.ThongTinBenhNhan.thoigianvaovien]',
    treatment_date                 datetime                                   null comment 'XML1.NGAY_VAO_NOI_TRU',
    finish_examination_date        datetime                                   null comment 'XML1.NGAY_RA',
    transit_number                 text                                       null comment 'XML1.GIAY_CHUYEN_TUYEN',
    treatment_day_number           varchar(50)                                null comment 'XML1.SO_NGAY_DTRI',
    treatments                     text                                       null comment 'XML1.PP_DIEU_TRI',
    treatment_result_id            varchar(50)                                null comment 'XML1.KET_QUA_DTRI (Bảng cats_treatment_results.treatment_result_id)',
    discharge_status_id            varchar(50)                                null comment 'XML1.MA_LOAI_RV (Bảng cats_discharge_status.discharge_status_id)',
    treatment_direction            text                                       null comment 'XML1.GHI_CHU',
    settlement_date                datetime                                   null comment 'XMl1.NGAY_TTOAN',
    drug_money                     decimal(20, 3)                             null comment 'XML1.T_THUOC',
    material_money                 decimal(20, 3)                             null comment 'XML1.T_VTYT',
    total_money                    decimal(20, 3)                             null comment 'XML1.T_TONGCHI_BV',
    total_money_insurance          decimal(20, 3)                             null comment 'XML1.T_TONGCHI_BH',
    patient_money                  decimal(20, 3)                             null comment 'XML1.T_BNTT',
    patient_pay_together_money     decimal(20, 3)                             null comment 'XML1.T_BNCCT',
    insurance_money                decimal(20, 3)                             null comment 'XML1.T_BHTT',
    other_souces_money             decimal(20, 3)                             null comment 'XML1.T_NGUONKHAC',
    external_capacity_money        decimal(20, 3)                             null comment 'XML1.T_BHTT_GDV',
    settlement_year                int(4)                                     null comment 'XML1.NAM_QT',
    settlement_month               int(2)                                     null comment 'XML1.THANG_QT',
    type_of_examination            int(1)                                     not null comment 'XML1.MA_LOAI_KCB  (Bảng cats_type_examination.type_id)',
    faculty_treatment_id           varchar(255)                               null comment 'XML1.MA_KHOA (Bảng cats_faculty.faculty_id); [cv365.ThongTinBenhNhan.makhoa]',
    healthfacilities_id            varchar(50)                                not null comment 'XML1.MA_CSKCB  (Bảng cats_healthfacilities.healthfacilities_id) hoặc [cv365.ThongTinVaoVien.maphongkham]',
    area_code                      varchar(255)                               null comment 'XML1.MA_KHUVUC',
    weight                         decimal(10, 2)                             null comment 'XML1.CAN_NANG hoặc [cv365.ThongTinVaoVien.cannang]',
    baby_weight                    char(255)                                  null comment 'XML1.CAN_NANG_CON',
    five_years_date                datetime                                   null comment 'XML1.NAM_NAM_LIEN_TUC',
    re_examination_date            datetime                                   null comment 'XML1.NGAY_TAI_KHAM',
    medical_record_code            varchar(255)                               null comment 'XML1.MA_HSBA  hoặc  [cv365.ThongTinBenhNhan.soba]',
    leader_medical_identifier_code text                                       null comment 'XML1.MA_TTDV',
    backup                         text                                       null comment 'XML1.DU_PHONG',
    storage_number                 varchar(255)                               null comment '[cv365.ThongTinBenhNhan.soluutru]',
    email                          text                                       null,
    bmi                            varchar(255)                               null,
    height                         varchar(255)                               null comment '[cv365.ThongTinVaoVien.chieucao]',
    pulse                          varchar(255)                               null comment '[cv365.ThongTinVaoVien.mach]',
    temperature                    varchar(255)                               null comment '[cv365.ThongTinVaoVien.nhietdo]',
    heart_beat                     varchar(255)                               null comment '[cv365.ThongTinVaoVien.nhiptho]',
    pressure_max                   varchar(255)                               null comment '[cv365.ThongTinVaoVien.huyetap_tamthu]',
    pressure_min                   varchar(255)                               null comment '[cv365.ThongTinVaoVien.huyetap_tamtruong]',
    waist_circumference            varchar(255)                               null,
    left_eye_no_glasses            varchar(255)                               null,
    right_eye_no_glasses           varchar(255)                               null,
    left_eye_glasses               varchar(255)                               null,
    right_eye_glasses              varchar(255)                               null,
    symptoms                       text                                       null comment 'Bệnh sử/Triệu chứng',
    datasource_id                  int                                        null comment 'Nguồn ( 1: EMR Viettel HIS; 2: EMR CV 365; 3: XML4210; 4: XML 4750/3176,99: Khác)',
    level_insurance_coverage       decimal(20, 3)                             null comment 'Mức hưởng BHYT',
    notes                          text                                       null comment 'Ghi chú',
    xml_3176                       blob                                       null comment 'Lưu dữ liệu XML của file',
    synchronized_history_id        bigint                                     null comment 'Tương ứng với trường dữ liệu [synchronized_history].[id]',
    synchronized_transaction_code  varchar(255)                               null comment 'Tương ứng với trường dữ liệu [synchronized_history].[transaction_code]',
    test_money                     decimal(20, 3) default 0.000               null comment 'Tiền xét nghiệm (XML3.cost_group_id=1)',
    radiology_money                decimal(20, 3) default 0.000               null comment 'Tiền  dịch vụ chuẩn đoán hình ảnh (XML3.cost_group_id=2)',
    func_exploration_money         decimal(20, 3) default 0.000               null comment 'Tiền dịch vụ thăm dò chức năng  (XML3.cost_group_id=3)',
    drug_ins_money                 decimal(20, 3) default 0.000               null comment 'Tiền thuốc BHYT chi trả (XML2.cost_group_id=4)',
    drug_out_ins_money             decimal(20, 3) default 0.000               null comment 'Tiền thuốc ngoài danh mục BHYT (XML2.cost_group_id=5)',
    drug_radio_money               decimal(20, 3) default 0.000               null comment 'Tiền thuốc thanh toán tỷ lệ  (XML2.cost_group_id=6)',
    blood_money                    decimal(20, 3) default 0.000               null comment 'Tiền máu và chế phẩm (XML2.cost_group_id=7)',
    surgery_money                  decimal(20, 3) default 0.000               null comment 'Tiền phẫu thuật thủ thuật (XML3.cost_group_id=8)',
    service_money                  decimal(20, 3) default 0.000               null comment 'Tiền dịch vụ kỹ thuật thanh toán theo tỷ lệ (XML3.cost_group_id=9)',
    material_ins_money             decimal(20, 3) default 0.000               not null comment 'Tiền vật tư y tế BHYT chi trả (XML3.cost_group_id=10)',
    material_radio_money           decimal(20, 3) default 0.000               null comment 'Tiền vật tư y tế thanh toán tỷ lệ (XML3.cost_group_id=11)',
    transfer_money                 decimal(20, 3) default 0.000               null comment 'Tiền vận chuyển (XML3.cost_group_id=12)',
    examinal_money                 decimal(20, 3) default 0.000               null comment 'Tiền khám (XML3.cost_group_id=13)',
    bed_out_money                  decimal(20, 3) default 0.000               null comment 'Tiền giường nằm ngoài (Ngày giường bệnh ban ngày) (XML3.cost_group_id=14)',
    bed_in_money                   decimal(20, 3) default 0.000               null comment 'Tiền giường bệnh điều trị nội trú(XML3.cost_group_id=15)',
    cancer_drug_money              decimal(20, 3) default 0.000               null comment 'Tiền thuốc ung thư',
    bed_temporary_money            decimal(20, 3) default 0.000               null comment 'Tiền giường lưu (XML3.cost_group_id=16)',
    blood_product_money            decimal(20, 3) default 0.000               null comment 'Tiền Chế phẩm máu (XML3.cost_group_id=17)',
    tricks_money                   decimal(20, 3) default 0.000               null comment 'Tiền Thủ thuật (XML3.cost_group_id=18)',
    personal_history               text                                       null comment 'Tiểu sử bệnh tật bản thân',
    family_history                 text                                       null comment 'Tiền sử gia đình',
    organization_id                int                                        null comment 'Đơn vị quản lý',
    military_object_id             int                                        null comment 'Diện quản lý',
    military_level_id              int                                        null comment 'Cấp bậc quân nhân',
    military_position_id           int                                        null comment 'Chức vụ quân nhân',
    dead_date                      datetime                                   null comment 'Thời gian tử vong',
    dead_time                      int(1)                                     null comment 'Khoảng thời gian tử vong sau khi vào viện (1=Trong 24 giờ vào viện; 2=Sau 24 giờ vào viện)',
    dead_form_id                   int                                        null comment 'Lý do tử vong (bảng cats_death_forms.dead_form_id)',
    dead_cause_primary             text                                       null comment 'Chẩn đoán nguyên nhân chính gây tử vong',
    dead_diseases_code             varchar(255)                               null comment 'Mã bệnh ICD10 - chính gây tử vong',
    dead_autopsy                   int(1)                                     null comment 'Khám nghiệm tử thi? (0=Chưa xác định, 1=Có, 2=Không, 3=Không biết)',
    dead_autopsy_result            text                                       null comment 'Chẩn đoán giải phẫu tử thi',
    is_delete                      bit            default b'0'                not null,
    is_active                      bit            default b'1'                not null,
    create_user_id                 varchar(50)                                null,
    create_date                    datetime       default current_timestamp() null comment 'Ngày tạo bản ghi - Ngày liên thông',
    update_user_id                 varchar(50)                                null,
    update_date                    datetime       default current_timestamp() null on update current_timestamp(),
    initialize_date                datetime                                   null comment 'Ngày lập bệnh án',
    last_initialize_date           datetime                                   null comment 'Ngày lập bệnh án cuối cùng trước update',
    initialize_day                 date as (cast(`initialize_date` as date)) stored,
    last_initialize_day            date as (cast(`last_initialize_date` as date)) stored,
    birth_year                     int(10) as (year(`birthday`)) stored,
    is_health_insurance            int(1)         default 1                   not null comment 'Xác định bệnh án có phải có thanh toán BHYT hay không (1=Có, 0=Không)',
    is_lock                        int            default 0                   not null comment 'Xác định hồ sơ có bị khóa (0=Chưa khóa, 1=Đã khóa)',
    is_check_data                  bit            default b'0'                not null comment 'Xác định là đã check Kiểm tra hồ sơ BHYT chưa (1=Đã check, 0=Chưa check)',
    check_data_date                datetime                                   null comment 'Ngày kiểm tra quy tắc dữ liệu thanh toán BHYT',
    check_data_content             text                                       null comment 'Kết quả kiểm tra quy tắc dữ liệu thanh toán BHYT',
    json_treatment_protocol        text                                       null comment 'Json phác đồ bác sĩ chỉ định của hồ sơ',
    object_id                      varchar(50)                                not null comment 'Bảng cats_object (1=BHXH, 2=Thu phí, 3=Khám sức khỏe, 4=Miễn, 99=Khác)',
    rule_id                        int                                        null comment 'ID Rule vi phạm (bảng insurance_rules)',
    alert_level                    int(2)                                     null comment 'Mức độ cảnh báo hồ sơ (1=Cảnh báo ; 2=Xuất toán)'
)
    comment 'Bảng hồ sơ bệnh án (XML1)';

create index idx_birth_year
    on medical_records (birth_year);

create index idx_birthday
    on medical_records (birthday);

create index idx_diseases_code
    on medical_records (diseases_code);

create index idx_examination_date
    on medical_records (examination_date);

create index idx_faculty_treatment_id
    on medical_records (faculty_treatment_id);

create index idx_finish_examination_date
    on medical_records (finish_examination_date);

create index idx_gender_id
    on medical_records (gender_id);

create index idx_healthfacilities_id
    on medical_records (healthfacilities_id);

create index idx_initialize_date
    on medical_records (initialize_date);

create index idx_initialize_day
    on medical_records (initialize_day);

create index idx_medical_record_type_id
    on medical_records (medical_record_type_id);

create index idx_mr_last_initialize_day
    on medical_records (last_initialize_day);

create index idx_mr_reason_code
    on medical_records (reason_code);

create index idx_mr_type_of_examination
    on medical_records (type_of_examination);

create index idx_treatment_result_id
    on medical_records (treatment_result_id);

create table medical_records_drugs
(
    drug_record_id             int auto_increment
        primary key,
    medical_record_id          int                                  not null comment 'Bảng medical_record_id.medical_record_id',
    his_id                     text                                 null comment 'XML2.MA_LK hoặc [cv365.YLenhThuocVatTu.sovaovien]',
    order_number               int(20)                              null comment 'XML2.STT',
    active_ingredient_code     varchar(255)                         null comment 'XML2.MA_THUOC hoặc [cv365.YLenhThuocVatTu.mathuocvattu_byt]',
    drug_code                  varchar(255)                         null comment 'XML2.MA_THUOC hoặc [cv365.YLenhThuocVatTu.mathuocvattu_byt]',
    processing_method          text                                 null comment 'XML2.MA_PP_CHEBIEN',
    drugs_healthfacilities_id  text                                 null comment 'XML2.MA_CSKCB_THUOC',
    cost_group_id              int                                  not null comment 'XML2.MA_NHOM',
    drug_name                  text                                 null comment 'XML2.TEN_THUOC hoặc [cv365.YLenhThuocVatTu.tenthuocvattu]',
    active_ingredient_name     text                                 null comment 'Hoạt chất XML2.TEN_THUOC',
    unit                       varchar(45)                          null comment 'XML2.DON_VI_TINH hoặc [cv365.YLenhThuocVatTu.donvitinh]',
    drug_concentration         varchar(1024)                        null comment 'XML2.HAM_LUONG',
    method_id                  varchar(50)                          null comment 'XML2.DUONG_DUNG (bảng cats_methods)',
    method_name                text                                 null comment 'XML2.DUONG_DUNG',
    dosage_forms               text                                 null comment 'XML2.DANG_BAO_CHE',
    dosage                     text                                 null comment 'XML2.LIEU_DUNG',
    dosage_description         text                                 null comment 'XML2.CACH_DUNG hoặc [cv365.YLenhThuocVatTu.cachdung]',
    register_number            varchar(255)                         null comment 'XML2.SO_DANG_KY',
    bidding_information        varchar(255)                         null comment 'XML2.TT_THAU',
    ranges                     varchar(50)                          null comment 'XML2.PHAM_VI (Phạm vi:1=Thuốc trong phạm vi hưởng BHYT, 2=Thuốc ngoài phạm vi hưởng BHYT)',
    payment_rate               decimal                              null comment 'XML2.TYLE_TT_BH',
    quantity                   decimal(10, 2)                       null comment 'XML2.SO_LUONG hoặc [cv365.YLenhThuocVatTu.soluongthuocvattu]',
    unit_prices_insurance      decimal(20, 3)                       null comment 'XML2.DON_GIA',
    total_money                decimal(20, 3)                       null comment 'XML2.THANH_TIEN_BV',
    total_money_insurance      decimal(20, 3)                       null comment 'XML2.THANH_TIEN_BH',
    state_budget_support       decimal(20, 3)                       null comment 'XML2.T_NGUONKHAC_NSNN',
    budget_support_in          decimal(20, 3)                       null comment 'XML2.T_NGUONKHAC_VTTN',
    budget_support_out         decimal(20, 3)                       null comment 'XML2.T_NGUONKHAC_VTNN',
    budget_support_other       decimal(20, 3)                       null comment 'XML2.T_NGUONKHAC_CL',
    other_souces_money         decimal(20, 3)                       null comment 'XML2.T_NGUONKHAC',
    level_insurance_coverage   decimal(20, 3)                       null comment 'XML2.MUC_HUONG',
    patient_money              decimal(20, 3)                       null comment 'XML2.T_BNTT',
    patient_pay_together_money decimal(20, 3)                       null comment 'XML2.T_BNCCT',
    insurance_money            decimal(20, 3)                       null comment 'XML2.T_BHTT',
    faculty_treatment_id       varchar(50)                          null comment 'XML2.MA_KHOA',
    doctor_certification_code  varchar(255)                         null comment 'XML2.MA_BAC_SI',
    service_code               varchar(255)                         null comment 'XML2.MA_DICH_VU',
    decision_date              datetime                             null comment 'XML2.NGAY_YL hoặc [cv365.YLenhThuocVatTu.ngaykedonthuoc]',
    payment_form_code          int                                  null comment 'XML2.MA_PTTT Mã phương thức thanh toán (0=Phí dịch vụ, 1=Định suất,2=Ngoài định suất,3=DRG)',
    source_arv                 int(1)                               null comment 'XML2.NGUON_CTRA (1: Bảo hiểm y tế; 2: Dự án/Viện trợ; 3: Chương trình mục tiêu Quốc gia; 4: Khác)',
    wound_recurs               int(1)                               null comment 'XML2.VET_THUONG_TP --> Mã hoá vết thương tái phát: chỉ ghi 1 nếu sử dụng thuốc có quy định tỷ lệ thanh toán BHYT để điều trị vết thương tái phát, bệnh tật tái phát cho đối tượng thương, người hưởng chính sách như thương binh, thương binh loại B, bệnh binh',
    backup                     text                                 null comment 'XML2.DU_PHONG',
    healthfacilities_id        varchar(50)                          null comment 'XML1.MA_CSKCB',
    form_code                  varchar(255)                         null comment 'Số phiếu  [cv365.YLenhThuocVatTu.sophieu]',
    doctor_name                text                                 null comment 'Tên bác sỹ chỉ định [cv365.YLenhThuocVatTu.bacsichidinh]',
    doctor_code                varchar(255)                         null comment 'Mã bác sĩ chỉ định [cv365.YLenhThuocVatTu.mabacsichidinh]',
    preliminary_diagnosis      text                                 null comment 'Chẩn đoán sơ bộ  [cv365.YLenhThuocVatTu.chandoansobo]',
    patient_object             varchar(255)                         null comment 'Đối tượng người bệnh  (cv365.YLenhThuocVatTu.doituongbn)',
    designation_code           varchar(255)                         null comment 'Mã chỉ định (cv365.YLenhThuocVatTu.machidinh)',
    groups                     varchar(255)                         null comment 'Nhóm (cv365.YLenhThuocVatTu.nhom)',
    drug_type                  varchar(255)                         null comment 'Loại thuốc (cv365.YLenhThuocVatTu.loaithuoc)',
    hospital_drug_code         varchar(255)                         null comment 'Mã thuốc vật tư của bệnh viện (cv365.YLenhThuocVatTu.mathuocvattu_bv)',
    drug_order_number          int(20)                              null comment 'Số thứ tự ngày dùng thuốc [cv365.YLenhThuocVatTu.sothutungaydungthuoc]',
    notes                      text                                 null comment 'Ghi chú y lệnh thuốc vật tư [cv365.YLenhThuocVatTu.ylenhthuocvattu_ghichu]',
    brand_drug_name            text                                 null comment 'Tên biệt dược',
    drug_concentration_unit    varchar(50)                          null comment 'Đơn vị nồng độ',
    morning_amount             int(3)                               null comment 'Liều dùng sáng',
    noon_amount                int(3)                               null comment 'Liều dùng trưa',
    afternoon_amount           int(3)                               null comment 'Liều dùng chiều',
    evening_amount             int(3)                               null comment 'Liều dùng tối',
    day_number                 varchar(50)                          null comment 'Số ngày',
    unit_prices                decimal(20, 3)                       null comment 'Đơn giá bệnh viện',
    external_capacity_money    decimal(20, 3)                       null comment 'Tiền ngoài định suất',
    diagnoses_code             varchar(255)                         null comment 'Mã bệnh chính',
    recording_user             text                                 null,
    recording_date             datetime                             null,
    amount                     varchar(50)                          null comment 'Liều lượng',
    dosage_units               varchar(45)                          null comment 'Đơn vị liều lượng',
    use_date                   datetime                             null comment 'Ngày sử dụng',
    is_health_insurance        bit      default b'0'                not null comment 'Xác định có thanh toán BHYT hay không (1=Có, 0=Không)',
    is_delete                  bit      default b'0'                not null,
    is_active                  bit      default b'1'                not null,
    is_sync                    int(1)   default 1                   null comment '1= Dữ liệu đồng bộ, 0= Dữ liệu người dùng nhập,2 = Dữ liệu bệnh nhân nhập',
    create_user_id             varchar(50)                          null,
    create_date                datetime default current_timestamp() not null,
    update_user_id             varchar(50)                          null,
    update_date                datetime default current_timestamp() null on update current_timestamp(),
    dosage_long                text                                 null,
    dosage_description_long    text                                 null,
    is_check_data              bit      default b'0'                null comment 'Xác định là đã check Kiểm tra hồ sơ BHYT chưa (1=Đã check, 0=Chưa check)',
    check_data_date            datetime                             null comment 'Ngày kiểm tra quy tắc dữ liệu thanh toán BHYT',
    check_data_content         tinytext                             null,
    rule_id                    int                                  null comment 'ID Rule vi phạm (bảng insurance_rules)',
    alert_level                tinyint(1)                           null comment 'Mức độ cảnh báo hồ sơ (1=Cảnh báo ; 2=Xuất toán)',
    decision_day               date as (cast(`decision_date` as date)) stored
)
    comment 'Bảng chứa thông tin thuốc (XML2)';

create index idx_medical_records_drugs_decision_date
    on medical_records_drugs (decision_date);

create index idx_medical_records_drugs_drug_code
    on medical_records_drugs (drug_code);

create index idx_medical_records_drugs_medical_record_id
    on medical_records_drugs (medical_record_id);

create index idx_mrd_cost_group_id
    on medical_records_drugs (cost_group_id);

create index idx_mrd_decision_day
    on medical_records_drugs (decision_day);

create index idx_mrd_hf_use_date
    on medical_records_drugs (healthfacilities_id, use_date);

create index idx_mrd_update_date
    on medical_records_drugs (update_date);

create index idx_mrd_use_date
    on medical_records_drugs (use_date);

create table treatment_days
(
    treatment_id         int auto_increment
        primary key,
    healthfacilities_id  varchar(50)                          not null comment 'ID CSKCB (cats_healthfacilities.code_vi)',
    month                tinyint(2)                           not null comment 'Tháng',
    year                 int                                  not null comment 'Năm',
    faculty_code         varchar(255)                         not null comment 'Khoa (cats_faculty.code_vi)',
    faculty_byt_code     varchar(255)                         not null comment 'Khoa (cats_faculty.byt_code_vi)',
    treatment_day_number decimal(10, 2)                       not null comment 'Tổng số ngày điều trị',
    order_number         int(4)   default 0                   not null,
    is_delete            bit      default b'0'                not null,
    is_active            bit      default b'1'                not null,
    create_user_id       varchar(50)                          null,
    create_date          datetime default current_timestamp() null,
    update_user_id       varchar(50)                          null,
    update_date          datetime default current_timestamp() null on update current_timestamp()
)
    comment 'Số ngày nằm điều trị' row_format = DYNAMIC;

create index idx_td_hf_year_month
    on treatment_days (healthfacilities_id, year, month);

create index idx_td_update_date
    on treatment_days (update_date);

create table treatment_department_days
(
    treatment_id         int auto_increment
        primary key,
    healthfacilities_id  varchar(50)                          not null comment 'ID CSKCB (cats_healthfacilities.code_vi)',
    year                 int                                  not null comment 'Năm',
    faculty_code         varchar(255)                         not null comment 'Khoa (cats_faculty.code_vi)',
    faculty_byt_code     varchar(255)                         not null comment 'Khoa (cats_faculty.byt_code_vi)',
    treatment_day_number decimal(10, 2)                       not null comment 'Tổng số ngày điều trị',
    order_number         int(4)   default 0                   not null,
    is_delete            bit      default b'0'                not null,
    is_active            bit      default b'1'                not null,
    create_user_id       varchar(50)                          null,
    create_date          datetime default current_timestamp() null,
    update_user_id       varchar(50)                          null,
    update_date          datetime default current_timestamp() null on update current_timestamp()
)
    comment 'Số ngày nằm điều trị theo khoa phòng' row_format = DYNAMIC;

create index idx_tdd_hf_year
    on treatment_department_days (healthfacilities_id, year);

create index idx_tdd_update_date
    on treatment_department_days (update_date);


create table cats_diseases_groups
(
    diseases_group_id     int auto_increment
        primary key,
    code                  varchar(50)                          not null,
    name                  varchar(255)                         not null,
    order_number          int(4)   default 0                   not null,
    is_delete             bit      default b'0'                not null,
    is_treatment_protocol bit      default b'0'                null comment 'phác đồ',
    is_dashboard          bit      default b'0'                not null comment 'Hiển thị báo cáo trên dashboard  (1=Có, 0=Không)',
    is_report_hiv         bit      default b'0'                null comment 'Báo cáo HIV (1=Có, 0=Không)',
    is_dashboard_disease  bit      default b'0'                null comment 'Hiển thị báo cáo bênh trên dashboard (1=Có, 0=Không)',
    is_report_leprosy     bit      default b'0'                null comment 'Báo cáo Phong (1=Có, 0=Không)',
    is_report_disease     bit      default b'0'                null comment 'Báo cáo Bệnh không lây nhiễm (1=Có, 0=Không)',
    is_report_infectious  bit      default b'0'                null comment 'Bệnh truyền nhiễm(1 = Có, 0 = Không)',
    is_add_malaria        bit      default b'0'                null comment 'Nhập bệnh sốt rét (1=Có, 0=Không)',
    is_add_mental_illness bit      default b'0'                null comment 'Nhập bệnh tâm thần (1=Có, 0=Không)',
    is_add_tuberculosis   bit      default b'0'                null comment 'Nhập bệnh lao (1=Có, 0=Không)',
    is_add_hiv            bit      default b'0'                null comment 'Nhập bệnh HIV (1=Có, 0=Không)',
    is_add_leprosy        bit      default b'0'                null comment 'Nhập bệnh phong (1=Có, 0=Không)',
    is_add_disease        bit      default b'0'                null comment 'Nhập bệnh không lây nhiễm  (1=Có, 0=Không)',
    warning_day           int(4)                               null comment 'Ngưỡng cảnh báo theo ngày',
    warning_quarter       int(10)                              null comment 'Ngưỡng cảnh báo theo quý',
    warning_month         int(10)                              null comment 'Ngưỡng cảnh báo theo tháng',
    warning_year          int(10)                              null comment 'Ngưỡng cảnh báo theo năm',
    description           varchar(1000)                        null,
    is_active             bit      default b'1'                null,
    create_user_id        varchar(50)                          null,
    create_date           datetime default current_timestamp() null,
    update_user_id        varchar(50)                          null,
    update_date           datetime default current_timestamp() null on update current_timestamp()
)
    comment 'Danh mục nhóm bệnh' row_format = DYNAMIC;

create table cats_diseases_groups_details
(
    detail_id         int auto_increment
        primary key,
    diseases_group_id int                                  not null comment 'ID danh mục nhóm bệnh',
    diseases_code     varchar(50)                          not null comment 'Mã bệnh ICD10',
    order_number      int(4)   default 0                   not null,
    description       varchar(1000)                        null,
    is_delete         bit      default b'0'                not null,
    is_active         bit      default b'1'                not null,
    create_user_id    varchar(50)                          null,
    create_date       datetime default current_timestamp() null,
    update_user_id    varchar(50)                          null,
    update_date       datetime default current_timestamp() null on update current_timestamp()
)
    comment 'Danh mục Chi tiết mã bệnh theo nhóm' row_format = DYNAMIC;

create index diseases_code_idx
    on cats_diseases_groups_details (diseases_code);

create table cats_icd10
(
    icd10_id              int(55) auto_increment
        primary key,
    code_vi               varchar(50)                          not null,
    name_vi               varchar(255)                         not null,
    name_en               varchar(255)                         null,
    system_url            varchar(255)                         null,
    defining_url          varchar(255)                         null,
    version               varchar(50)                          null,
    name_unmarked         varchar(255)                         null,
    group_id              int                                  null comment 'ID nhóm',
    chapter_id            int                                  null comment 'ID chương',
    type_id               int                                  null comment 'Id loại bệnh',
    group_range           varchar(45)                          null comment 'Phân nhóm, ví dụ A00-A09',
    itemicd               varchar(45)                          null comment 'Mục ICD - Trong bao cáo xa phuong',
    is_infectiousdiseases bit      default b'0'                not null comment 'Bệnh truyền nhiễm',
    type                  int                                  null,
    is_chronicdiseases    bit      default b'0'                not null comment 'Bệnh mãn tính',
    is_longtermdiseases   bit      default b'0'                not null comment 'Bệnh dài ngày',
    is_delete             bit      default b'0'                not null,
    is_active             bit      default b'1'                not null,
    create_user_id        varchar(50)                          null,
    create_date           datetime default current_timestamp() not null,
    update_user_id        varchar(50)                          null,
    update_date           datetime default current_timestamp() null on update current_timestamp(),
    ma_chuong_tam         varchar(50)                          null comment 'Mã chương tạm',
    ma_nhom_tam           varchar(50)                          null comment 'Mã nhóm tạm',
    ma_loai_tam           varchar(50)                          null comment 'Mã type tạm',
    is_sync               int                                  null comment 'is_sync=3 (Thêm mới mã bệnh từ 4210)'
)
    comment 'Danh mục bệnh ICD';

create index idx_code
    on cats_icd10 (code_vi);

create table cats_icd10_chapters
(
    chapter_id     int auto_increment
        primary key,
    code_vi        varchar(50)                          not null comment 'Cập nhật varchar (50) ngày 09/11/2020',
    name_vi        varchar(255)                         not null,
    name_en        varchar(255)                         null,
    system_url     varchar(255)                         null,
    defining_url   varchar(255)                         null,
    version        varchar(50)                          null,
    name_unmarked  varchar(255)                         null comment 'Tên không dấu',
    is_delete      bit      default b'0'                not null,
    is_active      bit      default b'1'                not null,
    create_user_id varchar(50)                          null,
    create_date    datetime default current_timestamp() not null,
    update_user_id varchar(50)                          null,
    update_date    datetime default current_timestamp() null on update current_timestamp()
)
    comment 'Danh mục chương bệnh';

create table medical_records_drugs_diagnoses
(
    diagnoses_id      int auto_increment
        primary key,
    medical_record_id int                                  not null comment 'Bảng medical_record_id.medical_record_id',
    patient_id        int                                  null comment 'ID bệnh nhân',
    drug_record_id    int                                  not null comment 'ID bảng medical_records_drugs',
    diseases_code     varchar(100)                         null comment 'Mã bệnh ICD10',
    diseases_tm_code  varchar(100)                         null comment 'Mã bệnh YHCT',
    diseases_name     text                                 null comment 'Tên bệnh ICD10',
    diseases_tm_name  text                                 null comment 'Tên bệnh YHCT',
    diagnostic_group  int(1)                               null comment 'Nhóm chẩn đoán (1 = ICD 10, 0 = YHCT)',
    notes             text                                 null comment 'Ghi chú',
    is_sync           int(1)   default 1                   null comment '1= Dữ liệu đồng bộ, 0= Dữ liệu người dùng nhập,2 = Dữ liệu bệnh nhân nhập',
    is_delete         bit      default b'0'                not null,
    is_active         bit      default b'1'                not null,
    create_user_id    varchar(50)                          null,
    update_user_id    varchar(50)                          null,
    create_date       datetime default current_timestamp() not null,
    update_date       datetime default current_timestamp() null on update current_timestamp()
)
    comment 'Chẩn đoán theo thuốc';

create index idx_medical_records_drugs_diagnoses_medical_record_id
    on medical_records_drugs_diagnoses (medical_record_id);

create table medical_records_diagnoses_discharge
(
    diagnoses_discharge_id int(11) unsigned auto_increment
        primary key,
    medical_record_id      int                                  not null comment 'Bảng medical_record_id.medical_record_id',
    diseases_code          varchar(50)                          null comment 'Mã bệnh ICD10',
    diseases_tm_code       varchar(50)                          null comment 'Mã bệnh YHCT',
    diseases_name          text                                 null comment 'Tên bệnh ICD10',
    diseases_tm_name       text                                 null comment 'Tên bệnh YHCT',
    recording_date         datetime                             null comment 'Ngày ghi nhận',
    recording_user         text                                 null comment 'Người ghi nhận',
    diagnoses_type         int(1)                               null comment 'Loại chẩn đoán: 1= Bệnh chính, 2=Biến chứng, 3=Bệnh kèm theo, 4=Chẩn đoán phân biệt ',
    diagnostic_group       int(1)                               null comment 'Nhóm chẩn đoán ( 1 = ICD 10, 0 = YHCT)',
    notes                  text                                 null comment 'Ghi chú',
    description            text                                 null comment 'Mô tả (trường hợp nhập text)',
    is_main                bit      default b'0'                null,
    is_sync                int(1)   default 1                   null comment '1= Dữ liệu đồng bộ, 0= Dữ liệu người dùng nhập,2 = Dữ liệu bệnh nhân nhập',
    is_delete              bit      default b'0'                not null,
    is_active              bit      default b'1'                not null,
    create_user_id         varchar(50)                          null,
    update_user_id         varchar(50)                          null,
    create_date            datetime default current_timestamp() not null,
    update_date            datetime default current_timestamp() null on update current_timestamp(),
    recording_day          date as (cast(`recording_date` as date)) stored,
    healthfacilities_id    varchar(50)                          null
)
    comment 'Chẩn đoán xuất viện (XML1)';

create index idx_medical_records_diagnoses_discharge_diseases_code
    on medical_records_diagnoses_discharge (diseases_code);

create index idx_medical_records_diagnoses_discharge_medical_record_id
    on medical_records_diagnoses_discharge (medical_record_id);

create index idx_mrdd_diagnoses_type
    on medical_records_diagnoses_discharge (diagnoses_type);

create index idx_mrdd_recording_date
    on medical_records_diagnoses_discharge (recording_date);

create index idx_mrdd_recording_day
    on medical_records_diagnoses_discharge (recording_day);



-- ADD: SHOW CREATE TABLE từ emr_datalake cho nhóm lượt khám CN_264–CN_286.
-- medical_records đã có ở trên, không ghi đè.

CREATE TABLE `cats_accidents` (
  `accident_id` varchar(50) NOT NULL DEFAULT '0',
  `name_vi` varchar(255) NOT NULL,
  `name_bhyt` varchar(255) NOT NULL,
  `code_bhyt` varchar(255) NOT NULL,
  `code_vi` varchar(255) DEFAULT NULL,
  `name_en` varchar(255) DEFAULT NULL,
  `system_url` varchar(255) DEFAULT NULL,
  `defining_url` varchar(255) DEFAULT NULL,
  `version` varchar(50) DEFAULT NULL,
  `order_number` int(4) NOT NULL DEFAULT 0,
  `accident_type` int(1) NOT NULL DEFAULT 1 COMMENT 'Loại (1=Nguyên nhân tai nạn, 2=Bộ phận bị thương)',
  `description` varchar(1000) DEFAULT NULL,
  `is_delete` bit(1) NOT NULL DEFAULT b'0',
  `is_active` bit(1) NOT NULL DEFAULT b'1',
  `create_user_id` varchar(50) DEFAULT NULL,
  `create_date` datetime DEFAULT current_timestamp(),
  `update_user_id` varchar(50) DEFAULT NULL,
  `update_date` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`accident_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Danh mục tai nạn'

CREATE TABLE `medical_records_services` (
  `record_service_id` int(11) NOT NULL AUTO_INCREMENT,
  `medical_record_id` int(11) DEFAULT NULL COMMENT 'Bảng medical_record_id.medical_record_id',
  `patient_id` int(11) DEFAULT NULL COMMENT 'Id bệnh nhân',
  `cost_group_id` int(11) NOT NULL COMMENT 'XML3.MA_NHOM (Mapping từ bảng cats_cost_groups.cost_group_id)',
  `his_id` varchar(100) DEFAULT NULL COMMENT 'XML3.MA_LK hoặc  cv365.KetquaChanDoanHinhAnh.sovaovien hoặc cv365.KetquaXetNghiem.sovaovien hoặc cv365.PhieuThuThuat.sovaovien hoặc cv365.PhieuPhauThuat.sovaovien',
  `order_number` int(11) DEFAULT NULL COMMENT 'XML3.STT',
  `service_code` varchar(50) DEFAULT NULL COMMENT 'XML3.MA_DICH_VU',
  `surgery_icd9_cm_code` varchar(50) DEFAULT NULL COMMENT 'XML3.MA_PTTT_QT',
  `material_code` varchar(50) DEFAULT NULL COMMENT 'XML3.MA_VAT_TU',
  `medical_supplies_package` varchar(50) DEFAULT NULL COMMENT 'XML3.GOI_VTYT',
  `material_name` text DEFAULT NULL COMMENT 'XML3.TEN_VAT_TU',
  `service_name` text NOT NULL COMMENT 'XML3.TEN_DICH_VU',
  `petrol_code` text DEFAULT NULL COMMENT 'XML3.MA_XANG_DAU',
  `unit` varchar(255) DEFAULT NULL COMMENT 'XML3.DON_VI_TINH',
  `ranges` varchar(50) DEFAULT NULL COMMENT 'XML3.PHAM_VI Ghi mã phạm vi của vật tư y tế (1: Vật tư y tế trong phạm vi hưởng BHYT (trong danh mục BHYT); 2: Vật tư y tế ngoài phạm vi hưởng BHYT (ngoài danh mục BHYT))',
  `quantity` decimal(11,2) DEFAULT 1.00 COMMENT 'XML3.SO_LUONG',
  `unit_prices` decimal(10,2) DEFAULT NULL COMMENT 'XML3.DON_GIA_BV',
  `unit_prices_insurance` decimal(10,2) DEFAULT NULL COMMENT 'XML3.DON_GIA_BH',
  `healthfacilities_id` varchar(255) DEFAULT NULL COMMENT 'XML1.MA_CSKCB',
  `bidding_information` varchar(255) DEFAULT NULL COMMENT 'XML3.TT_THAU',
  `payment_rate` decimal(20,0) DEFAULT 0 COMMENT 'XML3.TYLE_TT_DV',
  `payment_rate_insurance` decimal(20,0) DEFAULT 0 COMMENT 'XML3.TYLE_TT_BH',
  `total_money` decimal(20,2) DEFAULT 0.00 COMMENT 'XML3.THANH_TIEN_BV',
  `total_money_insurance` decimal(20,2) DEFAULT 0.00 COMMENT 'XML3.THANH_TIEN_BH',
  `payment_ceiling` decimal(20,2) DEFAULT 0.00 COMMENT 'XML3.T_TRANTT',
  `level_insurance_coverage` decimal(20,2) DEFAULT 0.00 COMMENT 'XML3.MUC_HUONG',
  `state_budget_support` decimal(15,2) DEFAULT NULL COMMENT 'XML3.T_NGUONKHAC_NSNN',
  `budget_support_out` decimal(15,2) DEFAULT NULL COMMENT 'XML3.T_NGUONKHAC_VTNN',
  `budget_support_in` decimal(15,2) DEFAULT NULL COMMENT 'XML3.T_NGUONKHAC_VTTN',
  `budget_support_other` decimal(15,2) DEFAULT NULL COMMENT 'XML3.T_NGUONKHAC_CL',
  `other_souces_money` decimal(20,2) DEFAULT 0.00 COMMENT 'XML3.T_NGUONKHAC',
  `patient_pay_together_money` decimal(20,2) DEFAULT 0.00 COMMENT 'XML3.T_BNCCT',
  `insurance_money` decimal(20,2) DEFAULT 0.00 COMMENT 'XML3.T_BHTT',
  `patient_money` decimal(20,2) DEFAULT 0.00 COMMENT 'XML3.T_BNTT',
  `faculty_treatment_id` varchar(50) DEFAULT NULL COMMENT 'XML3.MA_KHOA hoặc cv365.KetquaXetNghiem.khoa HOẶC cv365.PhieuThuThuat.khoa_ma; HOẶC (cv365.PhieuPhauThuat.khoa_ma)',
  `faculty_treatment_name` varchar(255) DEFAULT NULL COMMENT 'XML3.MA_KHOA hoặc cv365.KetquaXetNghiem.khoa HOẶC cv365.PhieuThuThuat.khoa; HOẶC (cv365.PhieuPhauThuat.khoa)',
  `bed_code` varchar(50) DEFAULT NULL COMMENT 'XML3.MA_GIUONG hoặc  (cv365.PhieuThuThuat.giuong) HOẶC (cv365.PhieuPhauThuat.giuong)',
  `doctor_decision_code` varchar(255) DEFAULT NULL COMMENT 'XML3.MA_BAC_SI hoặc cv365.KetquaChanDoanHinhAnh.mabacsichidinh hoặc  cv365.KetquaXetNghiem.mabacsichidinh',
  `doctor_decision_name` varchar(255) DEFAULT NULL COMMENT 'XML3.MA_BAC_SI cv365.KetquaChanDoanHinhAnh.bacsichidinh hoặc  cv365.KetquaXetNghiem.bacsichidinh',
  `doctor_implementation_code` varchar(255) DEFAULT NULL COMMENT 'XML3.NGUOI_THUC_HIEN hoặc cv365.KetquaChanDoanHinhAnh.mabacsithuchien hoặc cv365.KetquaXetNghiem.manguoithuchienxetnghiem HOẶC cv365.PhieuThuThuat.maphauthuatvien; HOẶC cv365.PhieuPhauThuat.maphauthuatvien',
  `doctor_implementation_name` varchar(255) DEFAULT NULL COMMENT 'XML3.NGUOI_THUC_HIEN hoặc cv365.KetquaChanDoanHinhAnh.bacsithuchien hoặc cv365.KetquaXetNghiem.nguoithuchienxetnghiem HOẶC cv365.PhieuThuThuat.phauthuatvien; HOẶC cv365.PhieuPhauThuat.phauthuatvien',
  `diagnoses_code` varchar(255) DEFAULT NULL COMMENT 'XML3.MA_BENH hoặc cv365.PhieuThuThuat.maicd',
  `diagnoses_name` varchar(255) DEFAULT NULL COMMENT 'cv365.PhieuThuThuat.tenicd',
  `diagnoses_desc` text DEFAULT NULL COMMENT 'cv365.PhieuThuThuat.motabenh',
  `diagnoses_code_tm` varchar(255) DEFAULT NULL COMMENT 'XML3.MA_BENH_YHCT',
  `decision_date` datetime DEFAULT NULL COMMENT 'XML3.NGAY_YL',
  `implementation_date` datetime DEFAULT NULL COMMENT 'XML3.NGAY_TH_YL',
  `result_date` datetime DEFAULT NULL COMMENT 'XML3.NGAY_KQ hoặc cv365.KetquaChanDoanHinhAnh.ngayketqua',
  `payment_form_code` int(11) DEFAULT NULL COMMENT 'XML3.MA_PTTT --> Mã phương thức thanh toán (0: Phí dịch vụ; 1: định suất; 2: ngoài định suất; 3: DRG)',
  `wound_recurs` int(1) DEFAULT NULL COMMENT 'XML3.VET_THUONG_TP',
  `surgery_insensitivity_method` varchar(255) DEFAULT NULL COMMENT 'XML3.PP_VO_CAM hoặc  (cv365.PhieuThuThuat.phuongphapvocam)',
  `body_part_id` varchar(50) DEFAULT NULL COMMENT 'XML3.VI_TRI_TH_DVKT',
  `body_part_name` varchar(255) DEFAULT NULL COMMENT 'XML3.VI_TRI_TH_DVKT',
  `equiqment_code` text DEFAULT NULL COMMENT 'XML3.MA_MAY',
  `product_code` varchar(255) DEFAULT NULL COMMENT 'XML3.MA_HIEU_SP',
  `is_reuse` tinyint(1) DEFAULT NULL COMMENT 'XML3.TAI_SU_DUNG',
  `backup` text DEFAULT NULL COMMENT 'XML3.DU_PHONG',
  `form_code` varchar(255) DEFAULT NULL COMMENT 'cv365.KetquaChanDoanHinhAnh.sophieu hoặc  cv365.KetquaXetNghiem.sophieu hoặc cv365.PhieuThuThuat.sophieu; hoặc cv365.PhieuPhauThuat.sophieu',
  `designation_code` varchar(255) DEFAULT NULL COMMENT 'Mã chỉ định (cv365.KetquaChanDoanHinhAnh.machidinh)',
  `diagnose_desc` varchar(255) DEFAULT NULL COMMENT 'Chẩn đoán (cv365.KetquaChanDoanHinhAnh.chandoan hoặc  cv365.KetquaXetNghiem.chandoan hoặc cv365.PhieuThuThuat.cdsauphauthuat)',
  `image_desc` varchar(255) DEFAULT NULL COMMENT 'Hình ảnh (cv365.KetquaChanDoanHinhAnh.hinhanh)',
  `suggestions` text DEFAULT NULL COMMENT 'Đề nghị (cv365.KetquaChanDoanHinhAnh.kqcls_denghi)',
  `concludes` text DEFAULT NULL COMMENT 'Kết luận (cv365.KetquaChanDoanHinhAnh.kqcls_ketluan)',
  `results` text DEFAULT NULL COMMENT 'Kết quả (cv365.KetquaChanDoanHinhAnh.kqcls_mota)',
  `notes` text DEFAULT NULL COMMENT 'Ghi chú (cv365.KetquaXetNghiem.ghichu hoặc cv365.PhieuThuThuat.ghichu)',
  `link_pacs_view` text DEFAULT NULL COMMENT 'Link PacsViewDicom(cv365.KetquaChanDoanHinhAnh.kqcls_linkhinhanh)',
  `patient_object` varchar(255) DEFAULT NULL COMMENT 'Đối tượng người bệnh (cv365.KetquaXetNghiem.doituongbn)',
  `execution_date` datetime DEFAULT NULL COMMENT 'Ngày giờ lấy mẫu (cv365.KetquaXetNghiem.giolaymau)',
  `specimen_code` varchar(255) DEFAULT NULL COMMENT 'Mã số bệnh phẩm (cv365.KetquaXetNghiem.masobenhpham)',
  `designated_place` varchar(255) DEFAULT NULL COMMENT 'Nơi thực hiện chỉ định (cv365.KetquaXetNghiem.noithuchienchidinh)',
  `sample_type` varchar(255) DEFAULT NULL COMMENT 'Loại mẫu ',
  `surgery_name` text DEFAULT NULL COMMENT 'Tên loại PTTT [cv365.PhieuPhauThuat.dvpt]',
  `surgery_method` text DEFAULT NULL COMMENT 'Phương pháp PTTT (cv365.PhieuThuThuat.phuongphapphauthuat)',
  `surgery_procedures` text DEFAULT NULL COMMENT 'Trình tự PTTT (cv365.PhieuThuThuat.trinhtuphauthuatthuthuat; HOẶC cv365.PhieuPhauThuat.trinhtuphauthuatthuthuat)',
  `surgery_room` varchar(255) DEFAULT NULL COMMENT 'Buồng (cv365.PhieuThuThuat.buong) HOẶC (cv365.PhieuPhauThuat.buong)',
  `examination_date` datetime DEFAULT NULL COMMENT 'Ngày giờ vào viện (cv365.PhieuThuThuat.ngaygiovaovien) HOẶC (cv365.PhieuPhauThuat.ngaygiovaovien)',
  `surgery_gender` varchar(255) DEFAULT NULL COMMENT 'Giới tính  (cv365.PhieuThuThuat.gioitinh) HOẶC (cv365.PhieuPhauThuat.gioitinh)',
  `surgery_wick` varchar(255) DEFAULT NULL COMMENT 'Bấc (cv365.PhieuThuThuat.bac)',
  `surgical_diagram` text DEFAULT NULL COMMENT 'Lược đồ phẫu thuật (cv365.PhieuThuThuat.luocdophauthuat) HOẶC [cv365.hieuPhauThuat.luocdophauthuat]',
  `surgery_date` varchar(50) DEFAULT NULL COMMENT 'Ngày giờ phẫu thuật (cv365.PhieuThuThuat.ngaygiophauthuat) HOẶC [cv365.hieuPhauThuat.ngaygiophauthuat]',
  `surgery_anesthesiologist_code` varchar(255) DEFAULT NULL COMMENT 'Mã bác sĩ gây mê hồi sức (cv365.PhieuThuThuat.mabacsigaymehoisuc) HOẶC (cv365.PhieuPhauThuat.mabacsigaymehoisuc)',
  `surgery_anesthesiologist_name` varchar(255) DEFAULT NULL COMMENT 'Bác sĩ gây mê hồi sức (cv365.PhieuThuThuat.bacsigaymehoisuc) HOẶC (cv365.PhieuPhauThuat.bacsigaymehoisuc)',
  `surgery_sub_anesthesiologist_code` varchar(255) DEFAULT NULL COMMENT 'Mã Bác sĩ gây mê hồi sức phụ 1(cv365.PhieuPhauThuat.mabacsigaymehoisuc_phu1)',
  `surgery_sub_anesthesiologist_name` varchar(255) DEFAULT NULL COMMENT 'Bác sĩ gây mê hồi sức phụ 1  (cv365.PhieuPhauThuat.bacsigaymehoisuc_phu1)',
  `year_old` int(11) DEFAULT NULL COMMENT 'Tuổi (cv365.PhieuThuThuat.tuoi) Hoặc [cv365.PhieuPhauThuat.tuoi]',
  `surgery_code` varchar(255) DEFAULT NULL COMMENT 'Mã loại PTTT ',
  `surgery_type` text DEFAULT NULL COMMENT 'Loại PTTT (cv365.PhieuThuThuat.loaiphauthuat) Hoặc [cv365.PhieuPhauThuat.loaiphauthuat]',
  `surgery_sutures_withdraw_date` datetime DEFAULT NULL COMMENT 'Ngày rút chỉ (cv365.PhieuThuThuat.ngayrutchi)',
  `surgery_sutures_cut_date` datetime DEFAULT NULL COMMENT 'Ngày cắt chỉ (cv365.PhieuThuThuat.ngaycatchi)',
  `surgery_drain` varchar(255) DEFAULT NULL COMMENT 'Dẫn lưu (cv365.PhieuThuThuat.danluu)',
  `surgery_accessories` text DEFAULT NULL COMMENT 'Phụ dụng cụ (cv365.PhieuPhauThuat.phudungcu)',
  `surgery_surgical_assistant` text DEFAULT NULL COMMENT 'Phụ phẫu thuật (cv365.PhieuPhauThuat.phuphauthuat)',
  `surgery_outpatient_nursing` varchar(255) DEFAULT NULL COMMENT 'Điều dưỡng vòng ngoài (cv365.PhieuPhauThuat.ddvongngoai)',
  `surgery_notes` varchar(255) DEFAULT NULL,
  `surgery_icd9_cm_name` varchar(1024) DEFAULT NULL COMMENT 'Tên theo ICD-9 CM Vol3',
  `external_capacity_money` decimal(20,2) DEFAULT 0.00 COMMENT 'Tiền ngoài định suất',
  `sample_status` text DEFAULT NULL COMMENT 'Tình trạng mẫu',
  `treatments` text DEFAULT NULL COMMENT 'Phương pháp điều trị khi kết thúc ra viện',
  `is_health_insurance` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Xác định có thanh toán BHYT hay không (1=Có, 0=Không)',
  `is_delete` bit(1) NOT NULL DEFAULT b'0',
  `is_active` bit(1) NOT NULL DEFAULT b'1',
  `is_sync` int(1) DEFAULT 1 COMMENT '1= Dữ liệu đồng bộ, 0= Dữ liệu người dùng nhập,2 = Dữ liệu bệnh nhân nhập',
  `create_user_id` varchar(50) DEFAULT NULL,
  `create_date` datetime NOT NULL DEFAULT current_timestamp(),
  `update_user_id` varchar(50) DEFAULT NULL,
  `update_date` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `doctor_implementation_code_long` text DEFAULT NULL,
  `equiqment_code_long` text DEFAULT NULL,
  `decision_day` date GENERATED ALWAYS AS (cast(`decision_date` as date)) STORED,
  `implementation_day` date GENERATED ALWAYS AS (cast(`implementation_date` as date)) STORED,
  `result_day` date GENERATED ALWAYS AS (cast(`result_date` as date)) STORED,
  `execution_day` date GENERATED ALWAYS AS (cast(`execution_date` as date)) STORED,
  `last_decision_date` datetime DEFAULT NULL,
  `last_decision_day` date GENERATED ALWAYS AS (cast(`last_decision_date` as date)) STORED,
  `last_implementation_date` datetime DEFAULT NULL,
  `last_implementation_day` date GENERATED ALWAYS AS (cast(`last_implementation_date` as date)) STORED,
  `medical_record_number` varchar(20) DEFAULT NULL,
  `preoperative_diagnosis` text DEFAULT NULL COMMENT 'Chuẩn đoán trước PT/TT',
  `start_time` datetime DEFAULT NULL COMMENT 'Thời gian bắt đầu PT/TT',
  `end_time` datetime DEFAULT NULL COMMENT 'Thời gian kết thúc PT/TT',
  `surgeon_name` varchar(255) DEFAULT NULL COMMENT 'Bác sĩ PT/TT',
  `procedure_description` text DEFAULT NULL COMMENT 'Diễn biến phẫu thuật (Mô tả)',
  `procedure_result` varchar(20) DEFAULT NULL COMMENT 'Kết quả',
  `complications` varchar(50) DEFAULT NULL COMMENT 'Tai biến',
  `postoperative_condition` text DEFAULT NULL COMMENT 'Tình trạng sau PT/TT',
  `is_check_data` bit(1) DEFAULT b'0' COMMENT 'Xác định là đã check Kiểm tra hồ sơ BHYT chưa (1=Đã check, 0=Chưa check)',
  `check_data_date` datetime DEFAULT NULL COMMENT 'Ngày kiểm tra quy tắc dữ liệu thanh toán BHYT',
  `check_data_content` tinytext DEFAULT NULL,
  `rule_id` int(11) DEFAULT NULL COMMENT 'ID Rule vi phạm (bảng insurance_rules)',
  `alert_level` tinyint(1) DEFAULT NULL COMMENT 'Mức độ cảnh báo hồ sơ (1=Cảnh báo ; 2=Xuất toán)',
  `treatment_direction` text DEFAULT NULL COMMENT 'Hướng điều trị tiếp',
  PRIMARY KEY (`record_service_id`) USING BTREE,
  KEY `idx_medical_records_services_medical_record_id` (`medical_record_id`) USING BTREE,
  KEY `idx_medical_records_services_cost_group_id` (`cost_group_id`) USING BTREE,
  KEY `idx_decision_date` (`decision_date`) USING BTREE,
  KEY `idx_mrs_decision_day` (`decision_day`) USING BTREE,
  KEY `idx_mrs_diagnoses_code` (`diagnoses_code`) USING BTREE,
  KEY `idx_mrs_doctor_decision_code` (`doctor_decision_code`) USING BTREE,
  KEY `idx_mrs_faculty_treatment_id` (`faculty_treatment_id`) USING BTREE,
  KEY `idx_mrs_healthfacilities_id` (`healthfacilities_id`) USING BTREE,
  KEY `idx_mrs_material_code` (`material_code`) USING BTREE,
  KEY `idx_mrs_service_code` (`service_code`) USING BTREE,
  KEY `idx_mrs_surgery_icd9_cm_code` (`surgery_icd9_cm_code`) USING BTREE,
  KEY `idx_mrs_rpt_decision` (`healthfacilities_id`(191),`cost_group_id`,`is_active`,`is_delete`,`decision_date`),
  KEY `idx_mrs_rpt_implementation` (`healthfacilities_id`(191),`cost_group_id`,`is_active`,`is_delete`,`implementation_date`),
  KEY `idx_mrs_report_implementation_no_hf` (`cost_group_id`,`is_active`,`is_delete`,`implementation_date`,`medical_record_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19119671 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Bảng chứa thông tin xét nghiệm, chẩn đoán hình ảnh, PTTT, VTYT,..'

CREATE TABLE `cats_cost_groups` (
  `cost_group_id` int(11) NOT NULL AUTO_INCREMENT,
  `code_vi` varchar(50) NOT NULL,
  `name_vi` varchar(255) NOT NULL,
  `name_en` varchar(255) DEFAULT NULL,
  `system_url` varchar(255) DEFAULT NULL,
  `defining_url` varchar(255) DEFAULT NULL,
  `version` varchar(50) DEFAULT NULL,
  `order_number` int(4) NOT NULL DEFAULT 0,
  `description` varchar(1000) DEFAULT NULL,
  `is_delete` bit(1) NOT NULL DEFAULT b'0',
  `is_active` bit(1) NOT NULL DEFAULT b'1',
  `create_user_id` varchar(50) DEFAULT NULL,
  `create_date` datetime DEFAULT current_timestamp(),
  `update_user_id` varchar(50) DEFAULT NULL,
  `update_date` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `type_of_cost` int(11) DEFAULT NULL COMMENT '1. Dịch vụ kỹ thuật; 2.Thuốc; 3. Vật tư y tế; 4. Máu và chế phẩm máu',
  PRIMARY KEY (`cost_group_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COMMENT='Danh mục Nhóm chi phí 4210'
