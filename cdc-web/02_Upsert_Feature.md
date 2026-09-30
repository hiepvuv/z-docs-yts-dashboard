# 02 — Upsert chức năng (`cdc-web`)

Angular **19** standalone. Comment `// ADD:` / `// UPDATE:`. Không commit trừ khi được yêu cầu.

Đọc: [01a_Structure.md](./01a_Structure.md), [03_Dynamic_Report.md](./03_Dynamic_Report.md).

## 1. Thông tin trước khi code

| Hạng mục | Bắt buộc |
|---|---|
| Path URL trong `app.routes.ts` | Có |
| Component standalone + imports | Có |
| API trong `dynamic-report.service` (hoặc service mới) | Có — không bịa path |
| Menu mock (`menu-routing.service`) nếu cần hiện sidebar | Có |

## 2. Checklist đăng ký (standalone)

1. Component `standalone: true` dưới `pages/...`
2. Import vào `app.routes.ts` + path + `canActivate` nếu cần
3. Service `providedIn: 'root'` hoặc inject
4. Env keys nếu host API mới
5. Không tạo NgModule trừ khi repo đã có pattern đó (cdc-web hiện không có)

## 3. Pattern Add vs Edit (dynamic-report)

Cùng designer: `thiet-ke` vs `thiet-ke/:id`. List gọi `deleteConfig`.

## 4. Việc không làm trên FE

- Không giả định BE schema/period đã seed.
- Không mang data-entry khi chỉ làm cấu hình.
- Không bật quyền giả nếu authGuard đang bypass — ghi chú khi sửa.

## 5. DoD

- Route mở được; CRUD gọi đúng method service.
- `// ADD` tại route/service.
- Cập nhật `03_Dynamic_Report.md` / 01d nếu API mới.
