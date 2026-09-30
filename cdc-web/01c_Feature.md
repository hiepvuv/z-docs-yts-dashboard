# 01c — Chức năng `cdc-web` (dynamic-report)

Chi tiết: [03_Dynamic_Report.md](./03_Dynamic_Report.md). API: [01d_ListAPIs.md](./01d_ListAPIs.md).

## 1. Báo cáo động — cấu hình

| Chức năng | URL | File chính |
|---|---|---|
| Danh sách biểu mẫu bảng | `/bao-cao-dong` | `dynamic-report-list` |
| Thiết kế mới / sửa | `/bao-cao-dong/thiet-ke` · `/thiet-ke/:id` | `dynamic-report-designer` |
| Danh sách thuyết minh | `/bao-cao-dong/danh-sach-thuyet-minh` | `narrative-list` |
| Thiết kế thuyết minh | `/bao-cao-dong/thiet-ke-thuyet-minh` (+ `/:code`) | `narrative-designer` |

CRUD list: create, edit, delete. **Không** clone.  
Designer: kéo-thả cột (CDK), nested header, vertical matrix rows, preview HTML table.

## 2. Báo cáo động — nhập liệu (không mang sang emr_web theo yêu cầu)

| Chức năng | URL |
|---|---|
| Nhập liệu theo id | `/bao-cao-dong/nhap-lieu/:id` |
| Nhập liệu theo code | `/reports/dynamic/:reportCode` |
| Dashboard domain | `/reports/dashboard/:domainGroup` |

## 3. Menu mock (cdc)

`menu-routing.service.ts`: module `MOD_BAO_CAO_DONG` → `/bao-cao-dong`; roles mock `ROLE_CDC_ADMIN`.
