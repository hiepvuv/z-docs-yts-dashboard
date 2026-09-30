# 03 — Dynamic Report (`cdc-web`)

Tài liệu yêu cầu / khảo sát chi tiết. Không ghi đè khi refresh trừ khi user yêu cầu.

Nguồn: `src/app/pages/bao-cao-dieu-hanh/dynamic-report/**`, `services/dynamic-report.service.ts`, `app.routes.ts`.

## 1. Mục tiêu nghiệp vụ

Thiết kế biểu mẫu báo cáo động (cột, header lồng, ma trận dọc, thuyết minh Word) rồi lưu cấu hình lên BE `.../api/v1/dynamicreport`.  
Nhập liệu theo kỳ/org là luồng **tách** (`data-entry`, `report-dashboard`).

## 2. Phân tách config vs nhập liệu

| IN (cấu hình) | OUT (nhập liệu) |
|---|---|
| list, designer | data-entry |
| narrative-list, narrative-designer | report-dashboard |
| API `/configs*`, `/columns*`, `/vertical-rows*`, `/templates/parse-docx`, `/configs/save-word` | API `/data*`, `/periods*`, `/submit*`, `/aggregated-data`, `/narrative/compile`, `/narrative/export-docx` |

## 3. Designer (kéo-thả)

- CDK `DragDropModule`: reorder FormArray `columns`.
- Nested headers (nhiều tầng, colspan).
- Vertical rows editor (parentId, orderIndex, level).
- Preview HTML table (không jspreadsheet trong flow hiện tại).
- Save: `POST /configs` hoặc `PUT /configs/{id}`; `storageType: 'columnar'`.

## 4. List

- Load: `getConfigsFlatAndVertical()`.
- Actions: thiết kế mới, sửa (`:id`), xóa, mở nhập liệu (`/nhap-lieu/:id`).
- Không clone.

## 5. File copy tối thiểu (sang app khác — tham chiếu)

```
pages/bao-cao-dieu-hanh/dynamic-report/list/**
pages/bao-cao-dieu-hanh/dynamic-report/designer/**
services/dynamic-report.service.ts   # cắt method data nếu chỉ config
services/notification.service.ts
services/header-action.service.ts
```

Optional narrative: `narrative-list/**`, `narrative-designer/**` + `mammoth`.

Không copy: `data-entry/**`, `report-dashboard/**`.

## 6. Rủi ro khi mang sang `emr_web` (Angular 9)

- Standalone → phải bọc NgModule + lazy `loadChildren`.
- CDK 19 API vs CDK 9 — kiểm tra `DragDropModule` / import path.
- Không có path alias ở cdc; emr dùng `@app` / `@shared`.
- Menu/action theo `menu-code` / `action-code` / DB SYS_MENU của EMR.
- BE host: giữ `localhost:9001` dynamicreport hay gắn gateway EMR — cần chốt khi implement.
