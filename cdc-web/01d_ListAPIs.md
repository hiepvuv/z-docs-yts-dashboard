# 01d — APIs client dynamic-report (`cdc-web`)

Service: `src/app/services/dynamic-report.service.ts`.  
Base: `environment.serverUrl.api_dynamicreport` + `API_PATH.BASE_API_PATH` + `SERVICES_PATH.DYNAMICREPORT`  
→ dev: **`http://localhost:9001/api/v1/dynamicreport`**.

Envelope: `{ status, message, data }` — unwrap `data`.

## 1. API cấu hình / template (IN SCOPE migrate config)

| Method service | HTTP | Path sau base |
|---|---|---|
| `saveConfig` | POST | `/configs` |
| `getConfigs` | GET | `/configs` |
| `getConfigsFlatAndVertical` | GET | `/configs?reportTypes=flat_grid,vertical_matrix` |
| `getConfigByCode` | GET | `/configs/by-code/{reportCode}` |
| `getConfigById` | GET | `/configs/{id}` |
| `updateConfig` | PUT | `/configs/{id}` |
| `deleteConfig` | DELETE | `/configs/{id}` |
| `saveColumnarColumns` | POST | `/columns/{reportCode}` |
| `getColumnarColumns` | GET | `/columns/{reportCode}` |
| `getVerticalRows` | GET | `/vertical-rows/{reportCode}` |
| `saveWordConfig` | POST | `/configs/save-word` |
| `getWordConfigs` | GET | `/configs?reportType=word_narrative` |
| `deleteWordConfig` | DELETE | `/configs/{id}` |
| `parseDocFile` | POST | `/templates/parse-docx` |
| `getDatabaseTables` / `getTableSchema` | — | **MOCK throw** (chưa BE) |

## 2. API nhập liệu / kỳ (OUT OF SCOPE)

| Method | HTTP | Path |
|---|---|---|
| `getData` / `saveData` | GET/POST | `/data/{reportCode}` |
| `checkPeriodData` | GET | `/data/check` |
| `getSubmittedRecords` | GET | `/data/submission-status` |
| `saveColumnarData` / `getColumnarData` | POST/GET | `/data/columnar` |
| `getColumnarAggregate` | GET | `/data/aggregate` |
| `saveAggregatedData` / `getAggregatedData` | POST/GET | `/aggregated-data` |
| `getPeriods` / `getAllPeriods` | GET | `/periods`, `/periods/all` |
| `upsertPeriod` | POST | `/periods/upsert` |
| `togglePeriodLock` | PATCH | `/periods/{id}/toggle-lock` |
| `deletePeriod` | DELETE | `/periods/{id}` |
| `autoGeneratePeriods` | POST | `/periods/auto-generate` |
| `submitReport` | POST | `/submit/{reportCode}` |
| `compileNarrative` | POST | `/narrative/compile` |
| `exportWordDocx` | POST | `/narrative/export-docx` (blob) |

## 3. Model template chính

`DynamicReportConfig`: `reportName`, `reportCode`, `reportType?` (`flat_grid` \| `vertical_matrix` \| `word_narrative`), `storageType?`, `columns[]`, `nestedHeaders?`, `verticalRows?`, `configJson?`, `status?`.

Designer save thực tế hardcode `storageType: 'columnar'`; **không set `reportType`** trong payload save (BE có thể suy từ verticalRows/columns).
