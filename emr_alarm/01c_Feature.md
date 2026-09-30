# 01c — Chức năng `emr_alarm`

API chi tiết: [01d_ListAPIs.md](./01d_ListAPIs.md). Schema: [01b_DBschema.md](./01b_DBschema.md). FE tương ứng: [../emr_web/01c_Feature.md](../emr_web/01c_Feature.md).

> Refresh 2026-09-08. Clone chart BE: `POST /alarm/config-charts/clone/{id}` (không phải `/copy`).

## 1. Module chính (dashboard / chart)

| Chức năng | Resource | Entity / bảng |
|---|---|---|
| Cấu hình biểu đồ CRUD + preview + clone | `ConfigChartResource` | `config_chart`, `config_chart_item`, `config_query_chart`, `config_display_query` |
| Cấu hình màn / dashboard (screen + area) | `ConfigScreenResource`, `ConfigAreaResource` | `config_screen`, `config_area`, `config_map_chart_area` |
| Profile dashboard | `ConfigProfileResource` | `config_profile` |
| Runtime lấy số liệu chart | `BuildChartResource` `GET /alarm/get-chart-result/{id}` | query SQL + datalake |
| Catalog loại chart / param | `CatItemResource` | `cat_item` (`TYPE_CHART`, …) |
| Phân tích SQL khi cấu hình | `BuildChartResource` `POST /alarm/analyze-sql` | — |

Luồng xem dashboard (FE gọi):

```
GET /alarm/config-screens/{id}
  → areas + mapCharts
GET /alarm/get-chart-result/{chartId}
  → series/data cho ECharts
```

Popup chi tiết: nếu chart có `chart_id_nextto` → FE mở screen đó (`GET /alarm/config-screens/{chartIdNextto}`). Field `popupAction` / `businessScreenCode` trên DB **không** thấy bind ở FE repo (xem docs FE).

## 2. Module phụ

Cùng `/alarm`: REST KPI/alarm/BTS/WO (Boc2*, AlarmKpi*, TicketWo*, ConfAlert, catalog KPI, địa bàn, email/MinIO, `TableDatawarehouse` `/alarm/datawarehouse`…). Không phải luồng Cấu hình biểu đồ EMR.

Ngoài `/alarm`: `KhamLapController` (`/kham-lap`); một số Resource JHipster `@RequestMapping("/api")`. Đọc annotation từng class.

## 3. File chính khi sửa chart/dashboard

| Việc | File |
|---|---|
| HTTP chart | `web/rest/ConfigChartResource.java` |
| HTTP screen | `web/rest/ConfigScreenResource.java` |
| HTTP data runtime | `web/rest/BuildChartResource.java` |
| Hằng số | `config/Constants.java` |
| Local auth | `LocalDevSecurityConfig.java`, `RequestFilter.java` |

## 4. Auth liên quan chức năng

Local: anonymous trên `/alarm/**` (cờ `permit-alarm-anonymous`). Prod: Keycloak + `RequestFilter` + `sys_users`. Không tạo user/menu trên service này — menu FE/`SYS_MENU` thuộc `emr_resource`.
