# 01b — Modules / components `emr_web`

Không ghi schema DB backend. API: [01d_ListAPIs.md](./01d_ListAPIs.md). Cấu trúc: [01a_Structure.md](./01a_Structure.md).

Pattern: **NgModule + lazy `loadChildren`**. List và form: **cùng** component Add vs Edit (`new` / `:id/edit`).

> Refresh 2026-09-08.

## 1. Core

| Thành phần | Path |
|---|---|
| AppModule / APP_INITIALIZER | `src/app/app.module.ts` |
| StartupService | `core/bootstrap/startup.service.ts` |
| ActionService / MenuService | `core/bootstrap/` |
| Guards | `core/guards/authen.guard.ts`, `menu.guard.ts`, `action.guard.ts` |
| TokenInterceptor | `core/interceptors/token.interceptor.ts` |
| menu / action const | `core/const/menu-code.ts`, `action-code.ts`, `menu-tree.ts` |
| BasicService | `core/services/basic.service.ts` (chart alarm **không** extend) |

## 2. Feature — Cấu hình biểu đồ (`config-chart`)

Module: `routes/config-chart/config-chart.module.ts`  
Routing: `config-chart.routing.module.ts`  
Lib render: **ngx-echarts** (`NgxEchartsModule`), template `echarts [options]`.

| Component | Vai trò |
|---|---|
| `ChartManagementComponent` | List |
| `UpdateChartsComponent` | Add (`new`) + Edit (`:id/edit`) — `ChartConfigResolve` |
| `ChartBasicInfoComponent` | Tên, loại chart (`typecharts$` từ cat-item) |
| `QueryTabComponent` / column / filter / order | SQL + map cột |
| `ChartPreviewComponent` | Preview |
| `ChartViewerComponent` | Render 1 chart trên dashboard |
| `PopUpDashboardComponent` | Popup screen `chartIdNextto` |
| `DashboardChartComponent` | Khung chart trên màn xem (`screen-kpi`) |
| `AlarmUnusualComponent` | Route `alarm-unusual` |

**chart-dynamic** (ECharts): `chart-column`, `chart-line`, `chart-pie`, `chart-pie-3d`, `chart-bar`, `chart-area`, `chart-stack`, `chart-combo`, `chart-group-bar`, `chart-correlate`, `chart-share-time`, `table-chart`, `chart-video`, `ban-do-dia-ban` (Viettel Maps), `chart-info-summary`, rank/infra, …

Một số `*.component.ts` import `ThemeService` từ `ng2-charts` — **không** vẽ Chart.js cho màn cấu hình chính.

Child route (`config-chart.routing.module.ts`):

- `''` → redirect `management` → list
- `new` → Add, resolve object rỗng (`chartConfig` default)
- `:id/edit` → Edit, `findConfigChart(id)`, parse `chartConfig` JSON
- thêm: `screen-kpi`, `alarm-unusual`

## 3. Feature — Cấu hình dashboard

Module: `routes/dashboard-config/dashboard.module.ts`  
Routing: `dashboard-routing.module.ts`

- List: `DashboardManagementComponent`
- Add/Edit: cùng `UpdateDashboardComponent` + `DashboardResolve` (`new` / `:id/edit`)
- Gắn chart vào area (gridster)

Còn route `pages/config-dashboard` → cùng `DashboardModule`.

## 4. Feature — Trang chủ xem dashboard

Module: `routes/dashboard-alarm-config/`

- `DashboardConfigComponent` (routing khai báo title Trang chủ)
- Path: `trang-chu`, `exploitation`, `dashboard/:name/:id`

Luồng: `GET config-screens/{id}` → `ChartViewerComponent` → `GET get-chart-result/{chartId}`.

## 5. Sessions

`sessions/login/LoginComponent` — `LoginService.login` → `http://localhost:9005/authentication/signin_v2` (hardcode trong `login.service.ts`). Sau token: `getLoginUserInfo` + `StartupService.load()`.

## 6. Shared services (chart/dashboard)

| Service | File |
|---|---|
| ConfigChartService | `shared/services/config-chart.service.ts` |
| DashboardService | `shared/services/dashboard.service.ts` |
| DashboardAlarmService | `shared/services/dashboard-alarm.service.ts` |
| echart-untils | `shared/services/echart-untils.service.ts` |
| ChartService / HighchartsService | helper Highcharts (không phải màn cấu hình chính) |

## 7. Module khác trong `routes/`

Nhiều module EMR (bác sĩ, BHYT, danh mục, báo cáo, chatbot, …) — lazy trong `routes-routing.module.ts`. Khi upsert màn EMR: copy module tương tự, không đụng `config-chart` trừ khi liên quan chart.

## 8. Pipe / directive quyền

- `permissionOnly` — `bypassMode` hoặc `hasPermission`
- `hasPermission` — `CommonUtils.havePermission`
