# 01a — Mục lục cấu trúc workspace DASHBOARD

Workspace: `d:\YTS_LAKE_2026\CODE\DASHBOARD`. Không phải monorepo chung.

> Cập nhật 2026-09-14: bổ sung source **`cdc-web`** (dynamic-report). `emr_resource` vẫn chưa có bộ 01+02.

Phân tích kỹ: **bật**.

## Source

| Source | Stack | Port / URL | Bộ 01+02 |
|---|---|---|---|
| `emr_web` | Angular **9.1.9** (NgModule) | `localhost:4200`, hash `/#/` | [emr_web/01a_Structure.md](./emr_web/01a_Structure.md) |
| `emr_alarm` | Java **21**, Spring Boot **2.7.18** | `localhost:8087`; chart `/alarm` | [emr_alarm/01a_Structure.md](./emr_alarm/01a_Structure.md) |
| `cdc-web` | Angular **^19.2** (standalone) | `ng serve`; dynamic-report → `localhost:9001/api/v1/dynamicreport` | [cdc-web/01a_Structure.md](./cdc-web/01a_Structure.md) · [03_Dynamic_Report.md](./cdc-web/03_Dynamic_Report.md) |

## Mục lục theo loại

| File gốc | Link chi tiết |
|---|---|
| [01b.md](./01b.md) | [emr_web/01b…](./emr_web/01b_Modules_Components.md), [emr_alarm/01b…](./emr_alarm/01b_DBschema.md), [cdc-web/01b…](./cdc-web/01b_Modules_Components.md) |
| [01c_Feature.md](./01c_Feature.md) | [emr_web](./emr_web/01c_Feature.md), [emr_alarm](./emr_alarm/01c_Feature.md), [cdc-web](./cdc-web/01c_Feature.md) |
| [01d_ListAPIs.md](./01d_ListAPIs.md) | [emr_web](./emr_web/01d_ListAPIs.md), [emr_alarm](./emr_alarm/01d_ListAPIs.md), [cdc-web](./cdc-web/01d_ListAPIs.md) |
| [02_Upsert_Feature.md](./02_Upsert_Feature.md) | [emr_web](./emr_web/02_Upsert_Feature.md), [emr_alarm](./emr_alarm/02_Upsert_Feature.md), [cdc-web](./cdc-web/02_Upsert_Feature.md) |

## Plan liên quan

- Migrate dynamic-report **config** → emr_web: [plan/migrate-dynamic-report-config-emr-web.md](./plan/migrate-dynamic-report-config-emr-web.md)  
  (BE: `dynamicreportbe` `:9001` `/api/v1/dynamicreport`; URL: `/#/thiet-lap/bao-cao-dong`; không narrative Word / periods)
