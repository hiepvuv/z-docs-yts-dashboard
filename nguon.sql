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

