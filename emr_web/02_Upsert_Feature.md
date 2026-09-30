# 02 — Upsert chức năng (`emr_web`)

Angular **9.1.9**: NgModule + lazy `loadChildren`, `*ngIf`/`*ngFor`, ReactiveForms. Không standalone, không `inject()`, không `@if`/`@for`.

Đọc: [01a_Structure.md](./01a_Structure.md), [01b_Modules_Components.md](./01b_Modules_Components.md), [01d_ListAPIs.md](./01d_ListAPIs.md). BE: [../emr_alarm/02_Upsert_Feature.md](../emr_alarm/02_Upsert_Feature.md).

> Refresh 2026-09-08. (Tên file repo: `02_Upsert_Feature.md` — tương đương checklist Add/Edit.)

## 1. Thông tin trước khi code

| Hạng mục | Bắt buộc | Ghi chú |
|---|---|---|
| Tên (UI + breadcrumb) | Có | Tiếng Việt, khớp i18n |
| URL path | Có | kebab-case, `routes-routing.module.ts` |
| Mã menu (`menuCode`) | Có | `menu-code.ts` + `menu-tree.ts`; **DB SYS_MENU cùng code** |
| Mã action | Có | `action-code.ts`; `[0]` = VIEW |
| API | Có | Không bịa. Chart/dashboard → `api_alarm`. Login/user/menu → `api_resource` |
| Pattern mẫu | Có | Copy module/màn tương tự trong `routes/` |

**Menu chart/dashboard đã có (không đổi nếu DB đang dùng):**

| Màn | Path | Constant route | Giá trị |
|---|---|---|---|
| Cấu hình biểu đồ | `thiet-lap/cau-hinh-bieu-do` | `configurationChartMenuCode.configurationChart` | CN98.1 |
| Cấu hình dashboard | `thiet-lap/cau-hinh-dashboard` | `configurationMenuCode.configurationDashboard` | CN9.15 |
| (menu-tree dashboard) | cùng path | `configurationDashboardMenuCode.configurationDashboard` | CN99.1 |

## 2. Checklist file đăng ký (Angular)

Thứ tự khi **thêm màn hình** (không phải chỉ cấu hình SQL chart):

1. `core/const/menu-code.ts`
2. `core/const/action-code.ts` — VIEW/ADD/EDIT/DELETE; `[0]` VIEW
3. `core/const/menu-tree.ts`
4. `routes/routes-routing.module.ts` — lazy, `menuCode`, `actionsView`
5. Feature `*.module.ts`, `*-routing.module.ts`, list + add/edit
6. `shared/services/...` — bám service cùng domain / `HttpClient` như `ConfigChartService`
7. `assets/i18n/vi-VN.json`
8. Guard: dùng `MenuGuard` + `ActionGuard` (`AuthenGuard` luôn yêu cầu token)

Khi **thêm biểu đồ / dashboard** (không tạo route mới):

- Chart: UI `thiet-lap/cau-hinh-bieu-do/new` (SQL + cột + filter) — **không** thêm file routing.
- Dashboard: `thiet-lap/cau-hinh-dashboard` — gắn chart vào area.
- Chỉ sửa FE khi thiếu loại chart, popup, hoặc component render (`chart-dynamic`, **ECharts**).

`// ADD:` tại điểm đăng ký route / menu / action / service.

## 3. Pattern Add vs Edit

Cùng 1 component:

- Chart: `UpdateChartsComponent` — `new` (resolve rỗng) vs `:id/edit` (`findConfigChart`) — file `config-chart.routing.module.ts`.
- Dashboard: `UpdateDashboardComponent` — `new` vs `:id/edit` (`DashboardService.find`).

Không tách AddComponent / EditComponent trừ khi module mẫu đã tách.

## 4. Việc không làm trên frontend

- Không tạo menu/action trên DB (`SYS_MENU`) — người dùng/DBA làm.
- Không đổi `bypassMode` theo hướng cắt Bearer **mọi** API (làm hỏng login resource). Chỉ skip Bearer `api_alarm` khi `bypassMode` (xem `token.interceptor.ts`).
- Không xóa menu/action/API cũ nếu DB đang dùng (CN9.15 vs CN99.1, FE `copy` vs BE `clone`, …).
- Không bịa field `popupAction` trên FE nếu chưa có bind.
- Không giả định FE `GET .../copy/{id}` khớp BE `POST .../clone/{id}` — ghi lệch ở 01d.

## 5. Definition of done

- Route + menuCode + actionsView `[0]` khớp.
- HTTP method/path khớp service hiện có hoặc Resource BE.
- Chart mới: component `echarts` nếu cùng nhóm `chart-dynamic`.
- i18n tiếng Việt.
- Liệt kê file đã sửa + `z_docs/emr_web/` đã đọc/cập nhật + việc DB (nếu có).
