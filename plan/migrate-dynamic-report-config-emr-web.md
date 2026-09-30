# Plan: Mang dynamic-report (cấu hình) từ cdc-web → emr_web

> Đã chốt 2026-09-14. Lưu tại `z_docs/plan/migrate-dynamic-report-config-emr-web.md`.

## Mục tiêu

- Port **CRUD + designer kéo-thả** báo cáo động từ `cdc-web` sang `emr_web`.
- Chỉ phần **cấu hình / thiết kế** biểu mẫu (`flat_grid` / `vertical_matrix`).
- **Không** mang nhập liệu, narrative Word, periods.

## Phạm vi / ngoài phạm vi

**In**
- List cấu hình: list, create, edit, delete.
- Designer: cột, CDK drag-drop reorder, nested headers, vertical rows, preview HTML, save/update config.
- Service HTTP chỉ nhánh config (`/configs*`, `/columns*`, `/vertical-rows*` — stub schema DB nếu giữ UI).
- Route + menu/action theo convention EMR.
- Env trỏ **`dynamicreportbe`**.

**Out**
- `data-entry/**`, `report-dashboard/**`.
- Narrative Word (`narrative-list` / `narrative-designer`, `/configs/save-word`, parse-docx, compile/export).
- Periods (`/periods*`) và mọi API data/submit/aggregate.
- Gắn API vào `emr_alarm`.
- Clone (cdc cũng không có).

## Source & stack

| Source | Stack | Role | Docs |
|---|---|---|---|
| `cdc-web` (FE nguồn) | Angular **^19.2** standalone | fe | `z_docs/cdc-web/03_Dynamic_Report.md` |
| `emr_web` (FE đích) | Angular **9.1.9** NgModule | fe | `z_docs/emr_web/01a_Structure.md` |
| `dynamicreportbe` (BE) | Spring Boot **3.5.14**, Java **21** | be | `dynamicreportbe/` (chưa bộ 01+02) |

**Rủi ro chính:** downgrade standalone A19 → NgModule A9.

## URL (đã chốt)

| Việc | Path (hash) |
|---|---|
| List | `/#/thiet-lap/bao-cao-dong` |
| Designer create | `/#/thiet-lap/bao-cao-dong/thiet-ke` |
| Designer edit | `/#/thiet-lap/bao-cao-dong/thiet-ke/:id` |

Lazy dưới parent `thiet-lap` (cùng pattern `cau-hinh-bieu-do`).

## BE — `dynamicreportbe` (đã chốt)

Nguồn: `dynamicreportbe/src/main/resources/application.properties`, `pom.xml`.

| Mục | Giá trị |
|---|---|
| Artifact | `DynamicReport` `0.0.1-SNAPSHOT` |
| Port | **9001** |
| Context-path | **`/api/v1/dynamicreport`** |
| Base URL FE | `http://localhost:9001/api/v1/dynamicreport` |
| DB | MariaDB `cdc_datawarehouse` @ `10.60.158.45:8036` |

Controller cấu hình (IN): `DynamicReportConfigController` (`/configs`), `DynamicReportColumnsController` (`/columns`), vertical-rows.  
Controller OUT: Period, Data, Submit, Narrative, AggregatedData.

## File sẽ đụng (dự kiến)

| File | Việc |
|---|---|
| `emr_web/src/app/routes/dynamic-report/` (mới) | Module + routing + list + designer |
| `emr_web/src/app/shared/services/dynamic-report.service.ts` (mới) | Interfaces template + method config only |
| `emr_web/src/app/routes/routes-routing.module.ts` | Lazy `bao-cao-dong` dưới `thiet-lap` |
| `emr_web/src/app/core/const/menu-code.ts` | Mã menu mới |
| `emr_web/src/app/core/const/action-code.ts` | `ACT_*_VIEW/ADD/EDIT/DELETE` |
| `emr_web/src/app/core/const/menu-tree.ts` | Node menu |
| `emr_web/src/environments/environment.ts` (+ local) | `api_dynamicreport` → `:9001` |
| `emr_web/src/assets/i18n/vi-VN.json` | Title / label |
| `z_docs/emr_web/01c` + `01d` | Sau khi code |

**Không đụng source:** `cdc-web` (chỉ đọc), `emr_alarm`, narrative/periods code.

## Ảnh hưởng lib / code hiện có của `emr_web`

### Kết luận ngắn

- **Không cần cài thêm npm dependency** cho phạm vi đã chốt (list + designer CDK).
- **Không nâng / hạ version** Angular, CDK, Material, RxJS.
- Ảnh hưởng chủ yếu là **thêm file mới** + **chỉnh đăng ký** (routing, menu, env, i18n). Không đụng logic `config-chart` / ECharts / Highcharts.

### Libs — dùng lại (đã có trong `package.json`)

| Lib | Version emr_web | Việc khi migrate |
|---|---|---|
| `@angular/cdk` | `^9.2.4` | **Tái sử dụng** `DragDropModule` / `moveItemInArray` — đã dùng ở `config-chart`, `material.module`, nhiều module cấu hình |
| `@angular/material` | `^9.2.4` | Không bắt buộc cho màn mới; giữ nguyên |
| `@angular/forms` | `~9.1.9` | ReactiveForms — đã có qua `SharedModule` / feature modules |
| `@angular/common` / `HttpClient` | `~9.1.9` | Service gọi `dynamicreportbe` |
| `@angular/router` | `~9.1.9` | Lazy route mới |
| `@ngx-translate/core` | `^12.1.2` | Key i18n mới |
| `rxjs` | `~6.5.4` | Port API RxJS 7 (cdc) → 6 (pipe/`toPromise` theo convention EMR) — **không đổi version package** |
| `ngx-toastr` / `NotificationService` repo | đã có | Thay `NotificationService` của cdc bằng service EMR hiện có |

### Libs — **không** thêm (Out / không cần)

| Lib (cdc dùng / có sẵn) | Lý do bỏ |
|---|---|
| `mammoth` | Narrative Word — Out |
| `jspreadsheet-ce` / `jsuites` | Designer bảng dùng preview HTML; không mang |
| `ng-zorro-antd` mới / API A19 | emr đã có ng-zorro 9; designer cdc gần như không phụ thuộc Zorro cho CRUD config |
| Nâng `@angular/cdk` lên 19 | Phá Material 9 — **cấm** |
| `ngx-file-drag-drop` | Khác CDK DragDrop; không dùng cho reorder cột |

### Thay đổi file hiện có (sửa, không thay lib)

| File | Mức | Thay đổi |
|---|---|---|
| `routes-routing.module.ts` | Sửa | Thêm 1 child lazy dưới `thiet-lap`: `bao-cao-dong` |
| `core/const/menu-code.ts` | Sửa (additive) | Thêm constant menu |
| `core/const/action-code.ts` | Sửa (additive) | Thêm `ACT_*_VIEW/ADD/EDIT/DELETE` |
| `core/const/menu-tree.ts` | Sửa (additive) | Thêm node menu |
| `environments/environment.ts` (+ `environment.local.ts`, có thể `dev`) | Sửa (additive) | Thêm `serverUrl.api_dynamicreport`, path `/api/v1` + `/dynamicreport` |
| `assets/i18n/vi-VN.json` | Sửa (additive) | Title / label màn |
| `token.interceptor.ts` | **Không đổi** (mặc định) | Chỉ skip Bearer cho `api_alarm` khi bypass. Request tới `:9001` **vẫn gửi Bearer** nếu có token — phù hợp `dynamicreportbe`. Chỉ sửa nếu test phát hiện 9001 treo/JWKS (giống alarm cũ) |

### File / module hiện có — **không đụng**

- Toàn bộ `routes/config-chart/**`, ECharts, Highcharts, dashboard-config logic nghiệp vụ.
- `config-chart.service`, `dashboard.service`, `emr_alarm` clients.
- `package.json` / `package-lock.json` — **không** thêm package (trừ khi sau này phát hiện thiếu — hiện CDK đủ).
- `SharedModule` / `MaterialModule` — không bắt buộc sửa; feature module tự `imports: [DragDropModule, …]` như các module cấu hình khác.

### File mới (không ghi đè)

| Path mới | Ghi chú |
|---|---|
| `routes/dynamic-report/**` | Module, routing, list, designer (port A9) |
| `shared/services/dynamic-report.service.ts` | Tên mới — không trùng service EMR hiện có (grep: chưa có `DynamicReport`) |

### Rủi ro tương thích API CDK 9 vs code cdc (CDK 19)

- API cơ bản `cdkDropList` / `cdkDrag` / `CdkDragDrop` / `moveItemInArray` **đã dùng trên EMR 9** → giữ pattern EMR, không copy selector/API mới của CDK 19.
- Template/HTML cdc dùng class/CSS riêng — copy CSS component; không đụng global style EMR trừ khi conflict selector (ưu tiên style scoped component).

## Pattern bám theo

- EMR: `config-chart` — list + cùng form `thiet-ke` / `thiet-ke/:id`, lazy, `MenuGuard` + `ActionGuard`.
- Logic: `cdc-web/.../dynamic-report/list|designer` + cắt method data/narrative/periods khỏi service.

## API config dùng

| Việc | Method | Path (sau context) |
|---|---|---|
| List flat+vertical | GET | `/configs?reportTypes=flat_grid,vertical_matrix` |
| Get by id | GET | `/configs/{id}` |
| Create | POST | `/configs` |
| Update | PUT | `/configs/{id}` |
| Delete | DELETE | `/configs/{id}` |
| Columns | POST/GET | `/columns/{reportCode}` |
| Vertical rows | GET | `/vertical-rows/{reportCode}` |

**Quyền FE:** menu + action trên EMR; **SYS_MENU** do user/DBA seed.

**Việc user phải làm**
- [ ] Seed SYS_MENU cùng `menuCode` đã khai báo.
- [ ] Chạy `dynamicreportbe` (9001) khi test.
- [ ] Chốt mã menu cụ thể (vd. dưới `CN1005`) nếu chưa có trong DB.

## Thứ tự bước

1. Env + `DynamicReportService` (config only) trên emr_web → base `dynamicreportbe`.
2. `DynamicReportModule` + routing: `''` list, `thiet-ke`, `thiet-ke/:id`.
3. Port list → A9; **ẩn/bỏ** nút nhập liệu.
4. Port designer → A9 + `DragDropModule`.
5. Đăng ký lazy + menu/action/menu-tree + i18n; `// ADD:`.
6. Test CRUD; cập nhật `z_docs/emr_web`.

## Rủi ro & hồi quy

| Rủi ro | Giảm thiểu |
|---|---|
| A19 → A9 | Port theo màn mẫu A9; không `inject()` / `@if` |
| CDK DragDrop | **Đã có** `@angular/cdk` 9 + dùng ở nhiều module; không nâng version |
| Gọi nhầm API periods/narrative | Service chỉ chứa config methods |
| Auth Bearer → 9001 | Bám interceptor EMR; kiểm tra CORS/`permission.ignore` BE |
| Menu DB thiếu | DoD + hướng dẫn seed |

## DoD

- [x] `/#/thiet-lap/bao-cao-dong` mở list (login + quyền).
- [x] Tạo / sửa / xóa config; designer kéo-thả + save qua `dynamicreportbe`.
- [x] Không có narrative Word, periods, data-entry trên emr_web.
- [x] `// ADD` tại routing, menu, action, service.
- [x] Cập nhật `z_docs/emr_web/01c` + `01d`.
- [ ] Test thủ công: list → designer by id → save → delete. *(user / DBA: seed SYS_MENU `CN1005.1` + chạy BE :9001)*

## Skill tiếp theo

- `/z-add-edit` trên `emr_web` theo plan này (khi user bảo làm).
