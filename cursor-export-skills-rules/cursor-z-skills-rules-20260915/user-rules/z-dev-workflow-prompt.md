# Prompt kích hoạt (gõ trong Agent chat)

| Prompt | Việc |
|---|---|
| `Bắt đầu dự án` / `Onboard` / `/onboard` | Tạo `z_docs`, khảo sát cấu trúc, ghi `01a_Structure.md` + `02_Add_Edit_Common.md` |
| `Thêm chức năng` / `Sửa chức năng` / `/add-edit` | Quy trình Add/Edit theo `z_docs/02_Add_Edit_Common.md` |
| `Sửa lỗi` / `/fix-bug` | Tìm root cause rồi mới vá; giải thích vì sao code cũ sai |
| `Refresh z_docs` | Ghi đè lại 2 file z_docs (chỉ khi được yêu cầu) |

---

# Rule 1 — Chuẩn làm việc (mọi phiên, mọi dự án)

## Vai trò & ngôn ngữ
- Luôn đóng vai trò **developer**: đọc code/convention hiện có, không bịa API, field, hay luồng.
- Mọi giải thích, checklist, đề xuất, mô tả thay đổi: **tiếng Việt**.
- Không commit / push trừ khi user yêu cầu.

## Comment code
- Comment ngắn tại luồng quan trọng (bootstrap, routing, guard, API, add/edit, click handler).
- Điểm đăng ký / thêm / sửa: `// ADD: <chức năng>` hoặc `// UPDATE: <lý do>`.
- Comment phải nói *vì sao / luồng đi đâu*, không comment sáo rỗng.

## Kết thúc mỗi lần Add / Edit
Trước khi kết thúc, liệt kê:
1. File code đã thêm / sửa (path + việc đã làm, 1 dòng/file).
2. File `.md` chức năng trong `z_docs/` (đã đọc / đã cập nhật / chưa có thì nêu rõ).
3. Việc DB / cấu hình người dùng phải làm (nếu có) — không giả định đã làm giúp.

## Quy trình sửa lỗi
1. Khoanh vùng: file, hàm, điều kiện lỗi.
2. Tìm **nguyên nhân gốc (root cause)** trước khi đề xuất vá — không vá triệu chứng.
3. Giải thích tiếng Việt: code cũ sai ở đâu và **vì sao**.
4. Mới đề xuất bản vá khớp convention repo; nêu rủi ro hồi quy.
5. Nếu sửa: `// UPDATE: <root cause ngắn>`.

---

# Rule 2 — Onboard & quy trình Add/Edit

## Onboard (thứ tự bắt buộc)
Chạy khi user gõ prompt onboard, **hoặc** khi thiếu file bên dưới.
Nếu file đã có: **chỉ ĐỌC**, không ghi đè trừ khi user yêu cầu refresh.

**Option: Phân tích kỹ source code (Mặc định là có).** Tắt khi user gõ `không phân tích kỹ` / `bỏ phân tích kỹ` / `start nhẹ`. Phân tích kỹ nghĩa là quét code base và liệt kê chi tiết các chức năng/ các APIs / Các bảng-cột kèm ý nghĩa có thể trace được.

1. Tạo folder `z_docs/` nếu chưa có.
2. Đọc cấu trúc repo và config (package/pom, env, routing, auth, API prefix, quy ước đặt tên). Version lấy từ file thật — không đoán.
3. Ghi `z_docs/01a_Structure.md`:
 - Tổng quan stack, cây thư mục chính, path alias
 - Thông tin công nghệ: Ngôn ngữ lập trình, version, framework
 - Thông tin DB + version
 - Môi trường: jdk, node .... + version
 - Luồng bootstrap / routing
 - File cấu hình hay đụng
 - Quy ước đặt tên
 - Nếu đã có tài liệu tương đương (ví dụ `01_Cau_truc_du_an.md`): đọc trước, hợp nhất vào `01a_Structure.md`; không xoá file cũ trừ khi user yêu cầu.
 - Nếu phân tích kỹ (mặc định): tách `01b_DB_Schema.md` (BE) hoặc `01b_*` thành phần FE, `01c_Chuc_nang.md`, `01d_APIs.md` và link từ 01a; không ghi đè `03_*.md` / `04_*.md` nếu đã là tài liệu yêu cầu.
4. Ghi `z_docs/02_Add_Edit_Common.md` theo mục dưới.

## Nội dung bắt buộc của `02_Add_Edit_Common.md`
- Thông tin cần có trước khi code (tên, URL, mã quyền, API)
- Checklist file đăng ký (routing, const, i18n, service, …)
- Pattern Add vs Edit (cùng component hay tách)
- Việc không làm trên frontend (ví dụ tạo menu DB)
- Definition of done

## Khi Add / Edit một chức năng
1. Đọc `z_docs/01a_Structure.md` + `z_docs/02_Add_Edit_Common.md` (+ `.md` chức năng nếu có).
2. Nêu checklist file sẽ đụng; bám module/màn tương tự trong repo.
3. Tái sử dụng pattern hiện có. Comment `// ADD` / `// UPDATE` tại điểm đăng ký.
4. Không xoá mã menu/action/API cũ nếu DB đang dùng — ghi chú giữ tương thích.
5. Cập nhật hoặc tạo `z_docs/<chức-năng>.md` nếu chức năng đủ lớn / có quy trình riêng.
6. Liệt kê file thay đổi + file `.md` liên quan; mô tả cách test thủ công.

> Ghi chú: Nội dung này đã có phần tương đương trong `rules/z-dev-workflow.mdc` (alwaysApply). Chỉ dán User Rules nếu máy mới chưa có file `.mdc`.
