# Báo cáo động (cấu hình) — `emr_web`

> Port từ `cdc-web` 2026-09-14. Chỉ CRUD + designer. Plan: [../plan/migrate-dynamic-report-config-emr-web.md](../plan/migrate-dynamic-report-config-emr-web.md).

## URL

| Màn | Path |
|---|---|
| List | `/#/thiet-lap/bao-cao-dong` |
| Create | `/#/thiet-lap/bao-cao-dong/thiet-ke` |
| Edit | `/#/thiet-lap/bao-cao-dong/thiet-ke/:id` |

## Quyền

| Mục | Giá trị |
|---|---|
| Menu | `CN1005.1` (`dynamicReportMenuCode.baoCaoDong`) |
| Action | `ACT_DYNAMIC_REPORT_VIEW` / `_ADD` / `_EDIT` / `_DELETE` |

User/DBA cần seed `SYS_MENU` cùng mã trên.

## BE

`dynamicreportbe` — `http://localhost:9001/api/v1/dynamicreport`  
Env FE: `serverUrl.api_dynamicreport` + `API_PATH.DYNAMICREPORT_BASE` + `SERVICES_PATH.DYNAMICREPORT`.

## File chính

| File | Việc |
|---|---|
| `routes/dynamic-report/dynamic-report.module.ts` | NgModule + CDK DragDrop |
| `routes/dynamic-report/list/*` | List full content + tìm mã/tên + phân trang |
| `routes/dynamic-report/designer/*` | Designer; nút Quay lại / Lưu ở footer (`app-base-button`) |
| `shared/services/dynamic-report.service.ts` | Config API only |

## Ngoài phạm vi

data-entry, narrative Word, periods, aggregate/submit.
