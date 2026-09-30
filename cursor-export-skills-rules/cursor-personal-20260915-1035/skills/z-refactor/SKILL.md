---
name: z-refactor
description: >-
  Refactor an toàn: giữ hành vi, từng bước nhỏ, verify bằng test/lint.
  Phân tích smell → safeguard → transform → verify. Đa stack. Dùng khi
  /z-refactor, refactor, làm sạch code, extract, tách module, không đổi
  nghiệp vụ.
disable-model-invocation: true
---

# z-refactor — Refactor giữ hành vi

Tham chiếu: community refactoring-kit (analyze → safeguard → transform → verify), aliev `/refactor`.

Áp dụng `/z-dev-standards`. **Detect** [stack-and-source.md](../z-dev-standards/references/stack-and-source.md) + playbook. Không đổi paradigm framework “tiện tay” (xem ranh giới `z-dev-standards`).

## Ranh giới

| Cho phép | Không làm trong skill này |
|---|---|
| Đổi tên, extract, move, giảm trùng, rõ dependency | Đổi behaviour / API public / schema DB |
| Cải thiện cấu trúc trong phạm vi đã thống nhất | Rewrite lớn không có test / plan |

Nếu cần đổi hành vi → `/z-add-edit` hoặc `/z-fix-bug`. Đổi lớn → `/z-plan` trước.

## Bước

1. **Analyze** — mục tiêu, file phạm vi, smell chính (ngắn).
2. **Safeguard** — có test? Nếu không: characterization test tối thiểu **hoặc** checklist thủ công tái hiện + rủi ro rõ ràng. Hỏi user nếu thiếu cả hai.
3. **Transform** — **một** thay đổi có nghĩa mỗi lần (extract method/component, rồi mới bước sau). Comment `// UPDATE: refactor <ý>` tại điểm then chốt.
4. **Verify** — chạy test/lint liên quan sau mỗi bước; đỏ → dừng, sửa hoặc revert bước đó.
5. **Report** tiếng Việt: trước/sau, file đụng, test đã chạy, việc còn lại.

## Anti-pattern

- “Dọn” kèm feature mới trong cùng PR tư duy
- Đổi Options ↔ Composition / Pages ↔ App Router “tiện tay”
- Xoá mã menu/action/API vì “không thấy dùng” khi DB có thể còn tham chiếu

## DoD

- [ ] Hành vi quan sát được không đổi
- [ ] Test/lint liên quan xanh (hoặc lý do không chạy được + checklist thủ công)
- [ ] Diff reviewable (không mega-commit logic lẫn refactor)
