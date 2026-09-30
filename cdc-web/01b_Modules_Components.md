# 01b — Modules / components `cdc-web` (dynamic-report)

Không ghi schema BE. API: [01d_ListAPIs.md](./01d_ListAPIs.md). Chi tiết nghiệp vụ: [03_Dynamic_Report.md](./03_Dynamic_Report.md).

> Angular 19 **standalone** — không có feature NgModule.

## 1. Config / design (IN SCOPE khi migrate)

| Component | Path | Vai trò |
|---|---|---|
| `DynamicReportListComponent` | `pages/.../dynamic-report/list/` | List `flat_grid` + `vertical_matrix`; tạo / sửa / xóa; link nhập liệu |
| `DynamicReportDesignerComponent` | `.../designer/` | Form cột + CDK DragDrop reorder + nested headers + vertical rows; save/update |
| `NarrativeListComponent` | `.../narrative-list/` | List `word_narrative` |
| `NarrativeDesignerComponent` | `.../narrative-designer/` | HTML/Word design; `saveWordConfig`; import docx (`mammoth`) |

## 2. Nhập liệu (OUT OF SCOPE migrate config)

| Component | Path | Vai trò |
|---|---|---|
| `DynamicReportDataEntryComponent` | `.../data-entry/` | Kỳ, org, save/submit data, aggregate |
| `ReportDashboardListComponent` | `pages/.../report-dashboard/` | Filter theo `domainGroup` → navigate data-entry |

## 3. Service / shared

| File | Vai trò |
|---|---|
| `services/dynamic-report.service.ts` | Interfaces template + instance; HTTP config + data |
| `services/notification.service.ts` | Toast |
| `services/header-action.service.ts` | Header actions list/designer |
| `services/role.service.ts` | Dùng ở data-entry (OUT) |

## 4. Designer — phụ thuộc UI

- `@angular/cdk/drag-drop`: `cdkDropList` / `cdkDrag` / `moveItemInArray` trên FormArray `columns`.
- Reactive Forms.
- Nested headers + vertical rows modal **inline** cùng component (không tách file).
- Modal schema DB gọi `getDatabaseTables` / `getTableSchema` — service **throwError** stub.

## 5. Pattern Add vs Edit

- List → `/bao-cao-dong/thiet-ke` (add) hoặc `/bao-cao-dong/thiet-ke/:id` (edit).
- Cùng `DynamicReportDesignerComponent`; `editId` từ `ActivatedRoute.params['id']`.
