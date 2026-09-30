# 01a — Cấu trúc `cdc-web` (trọng tâm dynamic-report)

Source: `cdc-web/`.  
Chi tiết modules: [01b_Modules_Components.md](./01b_Modules_Components.md) · chức năng: [01c_Feature.md](./01c_Feature.md) · API: [01d_ListAPIs.md](./01d_ListAPIs.md) · upsert: [02_Upsert_Feature.md](./02_Upsert_Feature.md) · dynamic-report: [03_Dynamic_Report.md](./03_Dynamic_Report.md).

Mục lục workspace: [../01a_Structure.md](../01a_Structure.md).

> Start 2026-09-14 — quét `bao-cao-dieu-hanh/dynamic-report` + service/API. Phân tích kỹ: **bật** (phạm vi dynamic-report; không khảo sát toàn bộ màn CDC).

## Nhận diện

```
Source: cdc-web
Language: TypeScript
Framework: Angular ^19.2.0 (standalone, không NgModule)
Role: fe
Docs: z_docs/cdc-web/
Playbook: Angular (≥14 standalone)
```

## 1. Stack

| Mục | Giá trị (file thật) |
|---|---|
| npm name | `cdc-web` |
| Angular | **^19.2.0** (`@angular/core`) — **standalone** |
| CDK | `@angular/cdk` ^19.2.19 (DragDrop dùng designer) |
| UI | ng-zorro-antd ^19.3.1, ng-bootstrap, ngx-toastr |
| Khác | `mammoth` (narrative import docx), `jspreadsheet-ce` / `jsuites` (global `angular.json`; designer bảng **không** còn dùng preview jspreadsheet) |
| Routing | `src/app/app.routes.ts` (không feature `*.module.ts`) |
| Path alias | **Không** khai báo `paths` trong `tsconfig.json` |
| Project | `cdc-web` (`angular.json`) |

**Serve:** `npm start` → `ng serve`.

## 2. Cây (phần liên quan dynamic-report)

```
cdc-web/src/app/
├── app.routes.ts
├── environments/environment.ts
├── services/
│   ├── dynamic-report.service.ts   # interfaces + HTTP
│   ├── notification.service.ts
│   └── header-action.service.ts
└── pages/bao-cao-dieu-hanh/
    ├── dynamic-report/
    │   ├── list/           # CRUD list (config)
    │   ├── designer/       # kéo-thả design (config)
    │   ├── data-entry/     # NHẬP LIỆU (ngoài phạm vi migrate config)
    │   ├── narrative-list/
    │   └── narrative-designer/
    └── report-dashboard/   # mở nhập liệu theo domain
```

## 3. Environment / API base

File: `src/environments/environment.ts`

| Key | Dev |
|---|---|
| `serverUrl.api_dynamicreport` | `http://localhost:9001` |
| `API_PATH.BASE_API_PATH` | `/api/v1` |
| `SERVICES_PATH.DYNAMICREPORT` | `/dynamicreport` |

Base service: `api_dynamicreport` + `BASE_API_PATH` + `DYNAMICREPORT` → **`http://localhost:9001/api/v1/dynamicreport`**.

(`apiUrlDynamicReport` tồn tại nhưng service **không** dùng.)

## 4. Bootstrap / routing (dynamic-report)

- Guard: `authGuard` trên parent `bao-cao-dong` (hiện `return true` đầu hàm — dead code check phía dưới).
- Eager import component trong `app.routes.ts` (không lazy `loadChildren`).

| Path | Component | Vai trò |
|---|---|---|
| `/bao-cao-dong` | List | CRUD cấu hình |
| `/bao-cao-dong/thiet-ke` | Designer | Create |
| `/bao-cao-dong/thiet-ke/:id` | Designer | Edit |
| `/bao-cao-dong/nhap-lieu/:id` | DataEntry | **Nhập liệu** |
| `/bao-cao-dong/danh-sach-thuyet-minh` | NarrativeList | Config word |
| `/bao-cao-dong/thiet-ke-thuyet-minh` (+ `/:code`) | NarrativeDesigner | Config word |
| `/reports/dynamic/:reportCode` | DataEntry | **Nhập liệu** |
| `/reports/dashboard/:domainGroup` | ReportDashboard | → mở nhập liệu |

## 5. Quy ước (quan sát từ code)

- Component: `standalone: true`, selector kebab.
- Navigate designer bằng **path `:id`**; narrative bằng **`:code`**.
- Không clone.
- Comment / log prefix `[DynamicReport]`.

## 6. Liên quan migration sang `emr_web`

`emr_web` = Angular **9.1.9 NgModule** — không copy nguyên standalone. Chi tiết plan: `.cursor/plans/migrate-dynamic-report-config-emr-web.md`.
