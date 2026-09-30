---
name: z-add-edit
description: >-
  Upsert chức năng đa ngôn ngữ/framework: tự nhận source → language →
  framework → ngữ cảnh, đọc 01a+02 đúng source, checklist theo playbook,
  comment ADD/UPDATE. Dùng khi Thêm/Sửa chức năng, /z-add-edit, /add-edit,
  thêm màn/API/module. Lệnh cũ /z-add-edit-next|-vue|-angular9 cũng chạy skill này.
disable-model-invocation: true
---

# z-add-edit — Upsert chức năng

Không skill nhánh. **Detect** → [stack-and-source.md](../z-dev-standards/references/stack-and-source.md); checklist → [stack-playbooks.md](../z-dev-standards/references/stack-playbooks.md) mục **02** / framework (+ Generic).

Áp dụng `/z-dev-standards`. Đổi lớn → `/z-plan` trước.

## Bước

0. **Nhận diện** source từ path đang sửa / URL chức năng. In: `Source | Language | Framework | Role | Docs`.
1. Thiếu 01a + 02 của **source đó**:
   - Một source: `z_docs/01a_Structure.md` + `z_docs/02_Upsert_Feature.md`
   - Nhiều source: `z_docs/<ten_source>/01a_…` + `02_…` (không dùng mục lục gốc làm nội dung)
   → `/z-start-project` (không ghi đè). Tên cũ `02_Add_Edit_Common.md`: ĐỌC nếu chưa đổi.
2. Đọc 01a + 02 (+ 01b/01c/01d / `.md` chức năng) **đúng source**.
3. Nêu checklist file sẽ đụng = playbook **02** đã detect, tinh chỉnh theo màn/module mẫu trong repo.
4. Implement tái sử dụng pattern hiện có. Comment ADD/UPDATE đúng syntax ngôn ngữ tại điểm đăng ký.
5. Không xoá mã menu/action/API/permission cũ nếu DB/hệ ngoài có thể còn dùng — ghi chú tương thích.
6. Chức năng lớn: tạo/cập nhật `z_docs/<ten_source?>/<chức-năng>.md`.
7. Verify: test hẹp hoặc checklist thủ công; tuỳ chọn `/z-test` / `/z-review`.
8. Kết thúc — liệt kê:
   - File code (path + 1 dòng/file)
   - File `.md` liên quan
   - Việc DB / cấu hình user (nếu có)
   - Cách test thủ công

Giải thích tiếng Việt.

## Checklist — nguyên tắc (chi tiết trong playbook)

| Role | Thường đụng |
|---|---|
| fe | route/page/view, component, i18n, API client, guard/menu nếu có |
| be | router/controller/handler, DTO/validation, service, DI/module register, migration chỉ khi user yêu cầu |
| fullstack cùng source | cả hai lớp **trong source đó**; không sửa source khác trừ khi user nêu |
| mobile | screen/widget, navigation, state management **đúng lib repo** |
| lib/cli | public API surface + test + đăng ký export/entrypoint |

**Không có mục playbook tên?** Copy checklist từ feature gần nhất cùng language/framework trong repo (Generic).

## Anti-pattern

- Làm FE bằng thói quen Spring (hoặc ngược lại)
- Thêm framework/state lib mới khi repo đã có cái tương đương
- Bịa path API vì “chuẩn REST”
