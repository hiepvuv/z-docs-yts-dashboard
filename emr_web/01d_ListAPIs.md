# 01d — APIs client `emr_web`

Base alarm: `environment.serverUrl.api_alarm` + `API_URL_SERVICE.api_alarm` → `http://localhost:8087/alarm`.  
Resource: `serverUrl.api` / `api_resource` → `http://localhost:9005/`.

Nguồn service FE. Path BE đầy đủ: [../emr_alarm/01d_ListAPIs.md](../emr_alarm/01d_ListAPIs.md).

`BasicService`: `get-all` / `get-detail` / `saveOrUpdate`. Chart/dashboard alarm dùng `HttpClient` trực tiếp, **không** extend BasicService.

> Refresh 2026-09-08 — đối chiếu `config-chart.service.ts`, `dashboard.service.ts`, BE `emr_alarm` docs.

## 1. ConfigChartService

File: `shared/services/config-chart.service.ts`  
`this.api` = `api_alarm` + `/alarm`.

| Method FE | HTTP | Path sau `/alarm` |
|---|---|---|
| `query` | POST | `/config-charts/get-all` |
| `getAllChart` | POST | `/config-chart/get-all` *(không `s`)* |
| `find` / `findWithParam` | GET | `/config-charts/get-chart-result/{id}` |
| `findConfigChart` | GET | `/config-charts/{id}` |
| `preview` | POST | `/config-charts/preview` |
| `save` | POST | `/config-charts` |
| `update` | POST | `/config-charts-update` |
| `delete` | GET | `/config-charts/delete` |
| `deleteAll` | POST | `/config-charts/delete-all` |
| `checkDelete` | GET | `/config-charts/check-delete` |
| `clone` | GET | `/config-charts/copy/{id}` |
| `getChartResult` | GET | `/get-chart-result/{chartId}` |
| `getDataSource` | GET | `/cat-items/find-by-category/21` |
| `getGroupChart` | GET | `/cat-group-charts` |
| `analyzeSql` | POST | `/analyze-sql` |
| permission* | GET/POST | `/config-charts/permission...` |

**Lệch FE vs BE (giữ nguyên — đừng “sửa cho đẹp” nếu đang chạy):**

| Việc | FE (`config-chart.service.ts`) | BE (`emr_alarm` Resource, theo `z_docs/emr_alarm/01d`) |
|---|---|---|
| Clone | `GET /config-charts/copy/{id}` | `POST /config-charts/clone/{id}` |
| List phụ `getAllChart` | `POST /config-chart/get-all` | List chính: `POST /config-charts/get-all` (`query`) |
| Xóa 1 | `GET /config-charts/delete` | `DELETE /config-charts/{id}` |

Khi thêm API mới: bám path **Resource Java**, rồi mới thêm method FE.

## 2. DashboardService

File: `shared/services/dashboard.service.ts`

| Method FE | HTTP | Path |
|---|---|---|
| `query` / `getDashboard` | GET | `/config-screens` |
| `find` | GET | `/config-screens/{id}` |
| `create` | POST | `/config-screens` |
| `update` | PUT | `/config-screens` |
| `delete` | DELETE | `/config-screens/{id}` |
| `deleteAll` | POST | `/config-screens/delete-all` |
| `clone` | POST | `/config-screens/copy/{id}` |
| `findByKey` | POST | `/config-screens/find-keyword` |
| `findScreenHome` | GET | `/config-screens/find-screen-home` |
| `getMainScreenKpi` | POST | `/get-main-screen-alarm-kpi` |
| `checkSysLogDevice` | POST | **api_resource** `sys-users/sys-log-device/` |

## 3. DashboardAlarmService

Prefix `/alarm-kpi-currents/...`: `get-header-table`, `search`, `search-v2`, `find-list-alarm-class`, `get-kpi-alarm-by-channel-and-unit`, `get-list-call-out`, …

## 4. Auth / menu (emr_resource)

| Chỗ gọi | HTTP | Path |
|---|---|---|
| `LoginService.login` | POST | `http://localhost:9005/authentication/signin_v2` (hardcode trong service) |
| `UserService.getLoginUserInfo` | (resource) | user sau login |
| `SysMenuDashboardService` | | `api_resource` + `sys-menu-dashboard/` (`get-all-dashboard`) |

`prefix-api.ts`: `dashboardAPIs` là path báo cáo/patient — **không** phải REST cấu hình biểu đồ alarm.

## 5. DynamicReportService (dynamicreportbe)

> Thêm 2026-09-14. File: `shared/services/dynamic-report.service.ts`.  
> Base: `serverUrl.api_dynamicreport` + `API_PATH.DYNAMICREPORT_BASE` + `SERVICES_PATH.DYNAMICREPORT`  
> → `http://localhost:9001/api/v1/dynamicreport`.

| Method FE | HTTP | Path sau `/dynamicreport` |
|---|---|---|
| `searchConfigs` | GET | `/configs?page&size&reportCode&reportName&reportTypes=` |
| `getConfigs` / `getConfigsFlatAndVertical` | GET | `/configs` (wrapper trên search) |
| `getConfigById` | GET | `/configs/{id}` |
| `getConfigByCode` | GET | `/configs/by-code/{reportCode}` |
| `saveConfig` | POST | `/configs` |
| `updateConfig` | PUT | `/configs/{id}` |
| `deleteConfig` | DELETE | `/configs/{id}` |
| columns* | POST/GET | `/columns/{reportCode}` |
| vertical rows | GET | `/vertical-rows/{reportCode}` |

**Response list:** `{ items, total, page, size }` (`PageResultDTO`).  
**Search:** `reportCode` / `reportName` — like ignore-case. Mặc định `isActive=true` (loại xóa mềm).

**Không gọi từ emr_web:** periods, data/submit/aggregate, narrative Word.

## 6. Service alarm khác

`config-menu.service.ts` → `/config-menus`; `profile-config.service.ts`; `kpi-report.service.ts`; `kpi-catalog.service.ts` `/catalog-kpi/`; `group-kpi.service.ts` `/cat-items/`.
