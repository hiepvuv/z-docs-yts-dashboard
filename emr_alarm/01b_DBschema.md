# 01b — Schema DB `emr_alarm`

Nguồn: `@Entity` / `@Table` trong `emr_alarm/src/main/java/.../domain/mcc/`. Dev Liquibase **tắt** — bảng chart/dashboard **không** có changelog trong `master.xml`; schema dựa DB `emr_alarm` có sẵn.

> Refresh 2026-09-08.

Còn ~99 entity MCC + changelog KPI/alarm cũ (Liquibase) — **không** liệt kê hết dưới đây.

Datasource MCC: MariaDB `emr_alarm` @ `10.60.158.45:8036` (dev). Datalake số liệu: schema `datawarehouse` (entity `domain.datawarehouse`).

## 1. Nhóm cấu hình chart / dashboard

### `config_chart` — `ConfigChart.java`

Cột (entity): `id`, `chart_code`, `chart_name`, `title_chart`, `type_chart`, `time_type_default`, `chart_id_nextto`, `order_index`, `video_link`, `description`, `chart_config` (JSON), `create_date`, `create_user_id`, `update_date`, `update_user_id`, `is_active`, `is_delete`.

PK `id` generator `increment`. `chart_id_nextto`: screen chi tiết khi click (popup). `type_chart`: khớp `cat_item` category `TYPE_CHART` (COLUMN, LINE, PIE, TABLE, …).

Liquibase: **không có**.

### `config_screen` — `ConfigScreen.java`

Cột: `id`, `SCREEN_CODE`, `SCREEN_NAME`, `IS_DEFAULT`, `ORDER_INDEX`, `PROFILE_ID`, `PARENT_ID`, `MENU_ITEM_ID`, `STATUS`, `DESCRIPTION`, `UPDATE_TIME`, `UPDATE_USER`, `IS_DASHBOARD`, `IS_ACTIVE`, `IS_DELETE`, `CREATE_DATE`, `UPDATE_DATE`, `CREATE_USER_ID`, `UPDATE_USER_ID`, `REQUEST_FILTER`, `AREA_DATA`, `PROVINCE_ID`, `DISTRICT_ID`, `WARD_ID`.

`IS_DEFAULT` / loại màn: `Constants.SCREEN_NORMAL=0`, `SCREEN_DEFAULT=1`, `SCREEN_SLIDE=4`, `SCREEN_DETAIL_CHILD=5`.

Liquibase: **không có**.

### `config_profile` — `ConfigProfile.java`

Cột: `id`, `profile_code`, `profile_name`, `is_default`, `order_index`, `type`, `role_code`, `status`, `description`, `update_time`, `update_user`.

`Constants.PROFILE_MAIN=1`, `PROFILE_NORMAL=0`.

### `config_area` — `ConfigArea.java`

Area trên gridster: `area_code`, `area_name`, `order_index`, `position_json`, `screen_id`, `time_refresh`, `status`, …

### `config_map_chart_area` — `ConfigMapChartArea.java`

Gắn chart vào area: `chart_id`, `area_id`, `order_index`, `screen_id_nextto`, `status`, …

### `config_map_screen_area` — `ConfigMapScreenArea.java`

Gắn screen con / area: `screen_id`, `area_id`, `order_index`, `screen_id_nextto`, …

### `config_chart_item` — `ConfigChartItem.java`

Item trong chart: `chart_id`, `type_chart`, `has_avg_line`, `list_color`, `query_id`, `condition1`–`5`, `input_condition`, …

### `config_query_chart` — `ConfigQueryChart.java`

SQL nguồn: `query_data`, `default_value`, `query_max_prd_id`, `status`, …

### `config_display_query` — `ConfigDisplayQuery.java`

Map cột SQL → cột chart: `item_chart_id`, `column_query`, `data_type`, `column_chart`, `is_require`, …

### `cat_item` — `CatItem.java`

PK entity: `item_id`. Cột: `item_code`, `item_name`, `item_value`, `category_id`, `category_code`, `position`, `description`, `editable`, `parent_item_id`, `status`, `query_condition`, `data_source`, …

Loại chart: `category_code = TYPE_CHART` (`Constants.TYPE_CHART_CATITEM`). Param chart: `PARAM_CHART`.

File Liquibase `20220526113615_added_entity_CatItem.xml` **tồn tại** nhưng **không** include trong `master.xml`; PK changelog là `id` (lệch entity `item_id`).

### `category` — `Category.java`

`category_id`, `category_name`, `category_code`, `editable`, `is_active`, `is_delete`. Changelog file có, không trong `master.xml`.

### `sys_users` — `SysUserEntity.java`

PK: `keycloak_user_id`. Dùng `RequestFilter` (prod) map token → `PER_DATA`, `ROLE_TYPE`, `USER_ID`. Cột: `fullname`, `province_id`, `district_id`, `ward_id`, `village_id`, `role_type`, `doctor_id`, `is_admin`, `username`, `is_updated_password`, …

Liquibase: **không có**.

## 2. Entity liên quan (rút gọn)

| @Table | Class |
|---|---|
| `config_query_kpi` | ConfigQueryKpi |
| `config_menu` / `config_menu_item` | ConfigMenu / ConfigMenuItem |
| `config_dashboard_pc` | ConfigDashboardPc |
| `config_map_chart_child` / `_links` / `_menu_item` / `_group_chart_area` | ConfigMapChart* |
| `config_map_kpi_query`, `config_input_kpi_query`, `config_input_table_query_kpi`, `config_column_query_kpi` | mapping KPI |
| `sys_menu_dashboard` | SysMenuDashboardEntity (menu dashboard; FE còn gọi `emr_resource`) |

`ConfigChartDetail` — `@Entity` không `@Table` (projection/detail).

## 3. Hằng số màn / loại chart

File: `config/Constants.java`

- Screen: `SCREEN_NORMAL=0`, `SCREEN_DEFAULT=1`, `SCREEN_SLIDE=4`, `SCREEN_DETAIL_CHILD=5`.
- Time: `TIME_TYPE_DATE/MONTH/QUARTER/YEAR` = 1..4.
- Category code (field Java → string): `TYPE_CHART_CATITEM = "TYPE_CHART"`, `PARAM_CHART_CATITEM = "PARAM_CHART"`, `MAP_CHART_TYPE = "MAP_CHART"`, `ITEM_MAP_CHART_TYPE = "ITEM_MAP"`.
- Cột thời gian data: `DATA_PRD_ID = "thoi_gian"`.
- Profile: `PROFILE_MAIN=1`, `PROFILE_NORMAL=0`.

## 4. Việc người dùng / DBA

- Tạo/sửa bản ghi `config_chart`, `config_screen`, map area: qua UI FE hoặc SQL trên schema `emr_alarm`.
- Bảng nguồn số liệu: schema `datawarehouse` (không giả định đã seed).
- Không dựa Liquibase repo để tạo bảng dashboard.
