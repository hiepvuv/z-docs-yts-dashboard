# 01d — APIs `emr_alarm`

Prefix chart/dashboard: **`/alarm`**. Context-path `/`. Local: `http://localhost:8087/alarm/...`.

Nguồn: `web/rest/*Resource.java` (**78** `@RestController`). Không bịa path.

> Refresh 2026-09-08. Chart clone = `POST /alarm/config-charts/clone/{id}` — **không** có `/copy` trên chart (copy là screen).

## 1. ConfigChartResource

File: `web/rest/ConfigChartResource.java`

| Method | Path | Java | Ý nghĩa |
|---|---|---|---|
| POST | `/alarm/config-charts` | `createConfigChart` | Tạo |
| POST | `/alarm/config-charts-icon` | `createConfigChartIcon` | Tạo + icon multipart |
| POST | `/alarm/config-charts-update` | `updateConfigChart` | Sửa |
| POST | `/alarm/config-charts-update-icon` | `updateConfigChartIcon` | Sửa + icon |
| POST | `/alarm/config-charts/get-all` | `getAllConfigCharts` | List/search (FE `ConfigChartService.query`) |
| GET | `/alarm/config-charts/get-all-assign` | | Chart theo ID assign |
| GET | `/alarm/config-charts/get-all-by-ids` | | Theo list id |
| GET | `/alarm/config-charts/{id}` | `getConfigChart` | Chi tiết (SaveChartDTO) |
| DELETE | `/alarm/config-charts/{id}` | `deleteConfigChart` | Xóa 1 |
| POST | `/alarm/config-charts/delete-all` | | Xóa nhiều |
| GET | `/alarm/config-charts/get-chart-detail/{chartId}` | `findByChartId` | Detail query |
| POST | `/alarm/config-charts/preview` | `previewConfigChart` | Preview |
| POST | `/alarm/config-charts/clone/{id}` | `cloneConfigChart` | Clone |
| POST | `/alarm/config-charts/search-chart` | `onSearchChart` | Search combo |

## 2. ConfigScreenResource

File: `web/rest/ConfigScreenResource.java`

| Method | Path | Ý nghĩa |
|---|---|---|
| POST | `/alarm/config-screens` | Tạo màn |
| PUT | `/alarm/config-screens` | Sửa |
| GET | `/alarm/config-screens` | List |
| GET | `/alarm/config-screens/{id}` | Chi tiết (areas + charts) |
| DELETE | `/alarm/config-screens/{id}` | Xóa |
| POST | `/alarm/config-screens/delete-all` | Xóa nhiều |
| POST | `/alarm/config-screens/copy/{id}` | Copy |
| GET | `/alarm/config-screens/get-slide-screen` | Slide theo profile |
| GET | `/alarm/config-screens/find-screen-by-profile-id` | Theo profile |
| GET | `/alarm/config-screens/find-screen-by-profile-and-parent` | Profile + parent |
| GET | `/alarm/config-screens/find-screen-root` | Root |
| GET | `/alarm/config-screens/find-screen-home` | Home |
| GET | `/alarm/config-screens/find-tabs-for-screen` | Tabs |
| POST | `/alarm/config-screens/find-keyword` | Search keyword |
| GET | `/alarm/config-screens/find-screen-detail-child` | Detail child + normal |
| GET | `/alarm/config-screens/find-screen-home/{unit}` | Home theo unit |
| GET | `/alarm/config-screens/find-sub-screen-home/{unit}` | Sub home |
| GET | `/alarm/config-screens/find-screen-type/{screenId}` | Type CatItem |

## 3. BuildChartResource (runtime)

File: `web/rest/BuildChartResource.java`

| Method | Path | Ý nghĩa |
|---|---|---|
| GET | `/alarm/get-chart-result/{id}` | **Data chart** (FE preview + dashboard) |
| POST | `/alarm/analyze-sql` | Phân tích SQL khi cấu hình |
| GET | `/alarm/build-chart/get-description/{tableName}` | Mô tả bảng |
| GET | `/alarm/get-table-description` | Mô tả bảng (map) |
| GET | `/alarm/get-table-field` | Field bảng |
| GET | `/alarm/get-time-type-by-kpis` | Time type KPI |
| GET | `/alarm/get-data-chart-maps` | Data map |
| GET | `/alarm/get-max-time-of-kpi` | Max time KPI |
| GET | `/alarm/get-range-of-color` | Range màu map |
| GET | `/alarm/get-screen-maps-id/{profileId}` | Screen map id |
| GET | `/alarm/build-chart/find-tree-kpi` | Cây KPI |
| POST | `/alarm/build-chart/find-tree-kpi-v2` | Cây KPI v2 |
| POST | `/alarm/catalog-graph-kpi/save` | Lưu catalog graph KPI |
| GET | `/alarm/get-category/{id}` | Category |
| GET | `/alarm/catalog-graph-kpi/{id}` | Catalog KPI by id |
| POST | `/alarm/catalog-graph-kpi/get-all` | List catalog KPI |
| POST | `/alarm/add-catalog` | Thêm catalog |
| POST | `/alarm/config-catalog/get-all` | List config catalog |
| PUT | `/alarm/catalog/delete-all` | Xóa catalog |
| PUT | `/alarm/catalog-graph-kpi/delete-all` | Xóa catalog graph |
| GET | `/alarm/cat-items-get-list-category` | List category |
| POST | `/alarm/get-main-screen-alarm-kpi` | Main screen alarm KPI |
| POST | `/alarm/get-all-area-chart-reason` | Area chart reason |
| POST | `/alarm/update-data-line` | Update data line |

## 4. ConfigProfileResource / ConfigAreaResource / CatItem

| Method | Path | Class |
|---|---|---|
| POST/PUT/GET/DELETE | `/alarm/config-profiles` (+ `/{id}`, `delete-all`, `copy/{id}`) | ConfigProfileResource |
| CRUD | `/alarm/config-areas` (+ `/{id}`) | ConfigAreaResource |
| GET | `/alarm/config-dashboard-pc/getTop5` | ConfigDashboardPcResource |
| GET | `/alarm/auth-info` | AuthInfoResource |
| CRUD + query | `/alarm/cat-items…`, `find-by-category`, `get-catItem-by-categoryCode`, `find-table-by-database`, … | CatItemResource |
| GET | `/alarm/get-all` | CatItemResource |

## 5. Nhóm REST khác (78 class `web/rest`)

Cùng `/alarm`: ConfigMapChart*, ConfigQuery*, ConfigMenu*, AlarmKpi*, TicketWo*, CatalogKpi*, Boc2*/Rpt*, ConfAlert, Emails/Messages/MinIO, địa bàn/staff, …

Prefix riêng (vẫn trong cùng app):

| Class | RequestMapping |
|---|---|
| `TableDatawarehouse` | `/alarm/datawarehouse` |
| `CatalogKpiAlarm` | `/alarm/catalog-kpi-alarm` |
| `AlarmQualifierDetail` | `/alarm/alarm_qualifier_detail` |
| `KhamLapController` | `/kham-lap` |
| `AlarmKpiSnapShotResource`, `AlarmQueryResource`, `EmailsResource`, `MessagesResource`, … | `/api` |

Đọc từng Resource trước khi gọi. FE map: [../emr_web/01d_ListAPIs.md](../emr_web/01d_ListAPIs.md).
