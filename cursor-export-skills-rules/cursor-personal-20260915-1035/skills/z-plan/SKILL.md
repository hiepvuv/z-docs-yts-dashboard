---
name: z-plan
description: >-
  Lập kế hoạch trước khi sửa code: khảo sát repo, hỏi làm rõ, viết plan
  (file paths, rủi ro, DoD, thứ tự bước). Đa stack/đa source. Dùng khi
  /z-plan, Plan, lập kế hoạch, thiết kế chức năng lớn, hoặc đổi nhiều file
  trước khi implement.
disable-model-invocation: true
---

# z-plan — Plan trước khi code

Tham chiếu: Cursor Agent Best Practices (Plan Mode), Superpowers `/write-plan`.

**Không sửa code** trong skill này trừ khi user bảo “làm luôn sau plan”.

Áp dụng `/z-dev-standards`. **Detect** [stack-and-source.md](../z-dev-standards/references/stack-and-source.md) + playbook [stack-playbooks.md](../z-dev-standards/references/stack-playbooks.md). Nếu thiếu `01a`+`02` của source → gợi ý `/z-start-project` trước (không ghi đè). Plan phải ghi rõ Language/Framework từng source đụng tới.

## Khi nào dùng

- Đổi ≥ 3 file hoặc chạm API + UI + quyền
- Yêu cầu mơ hồ / nhiều hướng hợp lệ
- User muốn duyệt plan trước

Bỏ qua: typo, 1-file fix rõ ràng → thẳng `/z-fix-bug` hoặc `/z-add-edit`.

## Bước chạy

1. **Khoanh source + stack** — đọc `z_docs` đúng source nếu có; tìm màn/module tương tự.
2. **Hỏi làm rõ** (tối đa 3–5 câu, có đề xuất mặc định). Bỏ câu đã trả lời được bằng cách đọc code.
3. **Viết plan** theo template dưới. Ưu tiên lưu `.cursor/plans/<slug>.md` nếu workspace cho phép; không thì output trong chat.
4. **Dừng chờ duyệt** — không implement cho đến khi user OK (hoặc nói “làm luôn”).
5. Sau duyệt: chỉ định skill tiếp (`/z-add-edit`, `/z-fix-bug`, `/z-refactor`, `/z-test`).

## Template plan

```markdown
# Plan: <tiêu đề ngắn>

## Mục tiêu
- …

## Phạm vi / ngoài phạm vi
- In: …
- Out: …

## Source & stack
- Source: …
- Stack: … (version từ file)

## File sẽ đụng (dự kiến)
| File | Việc |
|---|---|
| path | … |

## Pattern bám theo
- File/màn mẫu: `…`

## API / quyền / DB (nếu có)
- Chỉ liệt kê cái đã tồn tại hoặc user yêu cầu tạo mới
- Việc user phải làm trên DB/env: …

## Thứ tự bước
1. …
2. …

## Rủi ro & hồi quy
- …

## DoD
- [ ] Hành vi …
- [ ] Test / kiểm tra thủ công …
- [ ] Cập nhật z_docs (nếu chức năng lớn)
- [ ] Comment // ADD | // UPDATE tại điểm đăng ký
```

## Anti-pattern

- Plan dài lý thuyết không có path file
- Bịa endpoint/cột DB
- Trộn nhiều epic vào một plan — tách hoặc đánh dấu phase
