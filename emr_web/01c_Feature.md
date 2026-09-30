# 01c — Chức năng `emr_web`

Cấu trúc: [01a_Structure.md](./01a_Structure.md). API: [01d_ListAPIs.md](./01d_ListAPIs.md). BE: [../emr_alarm/01c_Feature.md](../emr_alarm/01c_Feature.md). Báo cáo động: [03_Dynamic_Report.md](./03_Dynamic_Report.md).

> Refresh 2026-09-08; bổ sung dynamic-report 2026-09-14.

## 1. Cấu hình biểu đồ

- URL: `/#/thiet-lap/cau-hinh-bieu-do` — child: `management` | `new` | `:id/edit` (+ `screen-kpi`, `alarm-unusual`)
- Menu route: **CN98.1** (`configurationChartMenuCode.configurationChart`); action `ACT_CONFIG_CHART_*`; i18n `configChart.label.title`
- Render preview/dashboard: **ECharts** (`echarts` directive / `NgxEchartsModule`)
- Lưu: `POST /alarm/config-charts` (add) / `POST /alarm/config-charts-update` (edit)
- Field "Screen chi tiết" = `chartIdNextto` (ID `config_screen`)

## 2. Cấu hình dashboard

- URL: `/#/thiet-lap/cau-hinh-dashboard`
- Routing `menuCode`: **CN9.15** (`configurationMenuCode.configurationDashboard`); `menu-tree`: **CN99.1** (`configurationDashboardMenuCode.configurationDashboard`)
- Action `ACT_CONFIG_DASHBOARD_*`
- Gắn chart đã tạo vào area gridster; lưu `POST/PUT /alarm/config-screens`

## 2b. Cấu hình báo cáo động (dynamic-report)

> Thêm 2026-09-14 — migrate từ `cdc-web` (chỉ cấu hình). Plan: [../plan/migrate-dynamic-report-config-emr-web.md](../plan/migrate-dynamic-report-config-emr-web.md).

- URL list: `/#/thiet-lap/bao-cao-dong`
- Designer create: `/#/thiet-lap/bao-cao-dong/thiet-ke`
- Designer edit: `/#/thiet-lap/bao-cao-dong/thiet-ke/:id`
- Menu: **CN1005.1** (`dynamicReportMenuCode.baoCaoDong`); action `ACT_DYNAMIC_REPORT_VIEW/ADD/EDIT/DELETE`
- BE: **`dynamicreportbe`** `:9001` context `/api/v1/dynamicreport`
- Scope: list + designer CDK (cột, nested headers, vertical rows). **Không** data-entry / narrative Word / periods
- List: tìm theo **mã** / **tên**; phân trang `page`/`size` qua `GET /configs`
- Module: `routes/dynamic-report/`; HTTP: `shared/services/dynamic-report.service.ts`

## 3. Trang chủ dashboard

- URL: `/#/trang-chu` → `DashboardAlarmConfigModule`
- `GET /alarm/config-screens/{id}` → areas/mapCharts → `GET /alarm/get-chart-result/{chartId}`
- Có `chartIdNextto`: toolbox mở `PopUpDashboardComponent` → load screen đó

`popupAction` / `businessScreenCode` trên bản ghi DB **không** thấy bind trong FE.

## 4. Đăng nhập

- `/#/sessions/login` → `emr_resource` `signin_v2` + `getLoginUserInfo` (cần Bearer)
- `AuthenGuard` **vẫn** yêu cầu token (không bypass)
- Không gửi Bearer tới `api_alarm` khi `bypassMode` — không làm hỏng login resource

## 5. File chính

| Chức năng | File |
|---|---|
| Route lazy | `routes/routes-routing.module.ts` |
| Chart routing | `routes/config-chart/config-chart.routing.module.ts` |
| Chart HTTP | `shared/services/config-chart.service.ts` |
| Dynamic report | `routes/dynamic-report/**`, `shared/services/dynamic-report.service.ts` |
| Dashboard HTTP | `shared/services/dashboard.service.ts` |
| Viewer | `chart-viewer/chart-viewer.component.ts` |
| Login | `sessions/login/login.component.ts`, `login.service.ts` |
