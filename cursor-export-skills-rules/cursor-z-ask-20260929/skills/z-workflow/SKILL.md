---
name: z-workflow
description: >-
  Router bộ skill z-*: chọn skill phù hợp theo giai đoạn (onboard, plan,
  upsert, fix, review, refactor, test, security, PR, docs). Dùng khi
  /z-workflow, chưa biết skill nào, hoặc hỏi luồng làm việc z-*.
  Hướng dẫn đầy đủ cách dùng: /z-help.
disable-model-invocation: true
---

# z-workflow — Chọn skill theo giai đoạn

Bộ skill cá nhân dùng chung **đa source / đa ngôn ngữ / đa framework**. Không gắn workspace cụ thể.

Hướng dẫn cách dùng + ví dụ prompt: `/z-help`.

Áp dụng `/z-dev-standards`. Mọi skill `z-*`: trước khi làm việc có sửa/docs, chạy protocol nhận diện [stack-and-source.md](../z-dev-standards/references/stack-and-source.md) rồi playbook [stack-playbooks.md](../z-dev-standards/references/stack-playbooks.md).

## Bản đồ nhanh

| Nhu cầu | Skill | Khi nào |
|---|---|---|
| Hướng dẫn cách dùng | `/z-help` | Help, liệt kê skill, ví dụ prompt |
| Onboard / quét repo / tạo `z_docs` | `/z-start-project` (`/onboard`) | Dự án mới hoặc thiếu 01a+02 |
| Ghi đè lại docs | `/z-refresh-docs` | User nói Refresh z_docs |
| Hiểu code, không sửa | `/z-explain` | Hỏi luồng / kiến trúc / “giải thích” |
| Đánh giá ý tưởng, chưa sửa | `/z-ask` | “Có nên”, đổi thiết kế, so phương án |
| Lập kế hoạch trước khi code | `/z-plan` | Đổi nhiều file, API mới, không rõ phạm vi |
| Thêm / sửa chức năng | `/z-add-edit` | Có yêu cầu upsert màn/API/module |
| Sửa lỗi (root cause) | `/z-fix-bug` | Bug, exception, hành vi sai |
| Refactor an toàn | `/z-refactor` | Chỉ cấu trúc, không đổi hành vi |
| Viết / chạy test | `/z-test` | TDD, thiếu test, verify sau sửa |
| Review diff | `/z-review` | Trước merge, sau agent run |
| Rà soát bảo mật | `/z-security` | Auth, input, secret, IDOR |
| Commit đúng phạm vi | `/z-commit` | Chỉ file chức năng được note, hoặc file vừa trao đổi |
| Mở PR | `/z-pr` | User yêu cầu tạo pull request |

Chuẩn luôn nền: `/z-dev-standards` (có thể auto-invoke).

## Chuỗi khuyến nghị (cộng đồng: plan → build → verify)

```
z-start-project (lần đầu)
    → z-explain (nếu cần)
    → z-ask (ý tưởng chưa chốt)
    → z-plan (đổi lớn)
    → z-add-edit | z-fix-bug | z-refactor
    → z-test
    → z-review (+ z-security nếu nhạy cảm)
    → z-commit (khi user yêu cầu commit)
    → z-pr (khi user yêu cầu)
```

Task nhỏ / quen thuộc: bỏ qua `z-plan`, vào thẳng `z-add-edit` hoặc `z-fix-bug`.

## Nguyên tắc chung (mọi skill z-*)

1. **Detect trước** — `Source | Language | Framework | Role | Docs`; không đoán stack.
2. **Một việc / một skill** — không nhồi onboard + PR trong cùng lần trừ khi user yêu cầu.
3. **Convention đúng source** — không bịa API/field/schema; version từ file thật; không lẫn playbook source khác.
4. **Tiếng Việt** với user; comment ADD/UPDATE theo syntax ngôn ngữ (`z-dev-standards`).
5. **Không commit/push** trừ khi user yêu cầu rõ.
6. **Không ghi đè** `03_*.md` / `04_*.md` yêu cầu; `Refresh z_docs` chỉ qua `/z-refresh-docs`.
7. Skill nhánh cũ `-next`/`-vue`/`-angular9` → skill gộp tương ứng.

## Cách trả lời khi user gọi `/z-workflow`

1. Hỏi ngắn mục tiêu nếu chưa rõ (1 câu).
2. Chỉ **một** skill chính + (tuỳ chọn) skill verify kế tiếp.
3. Chạy skill đó ngay nếu đã đủ thông tin — không chỉ liệt kê.
