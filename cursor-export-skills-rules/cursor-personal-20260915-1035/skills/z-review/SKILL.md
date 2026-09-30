---
name: z-review
description: >-
  Review code/diff theo checklist đa stack: correctness, regression,
  convention, test, bảo mật bề mặt. Dùng khi /z-review, review PR, review
  thay đổi, kiểm tra trước merge, “xem giúp diff”.
disable-model-invocation: true
---

# z-review — Code review

Tham chiếu: Cursor `/review`, community code-review skills, ivomarvan reviewer pattern (đối chiếu DoD).

**Mặc định không sửa code** — chỉ báo cáo. Sửa khi user bảo “vá luôn”.

Áp dụng `/z-dev-standards`. **Detect** từng source trong diff: [stack-and-source.md](../z-dev-standards/references/stack-and-source.md) + [stack-playbooks.md](../z-dev-standards/references/stack-playbooks.md). Review theo convention **đúng language/framework của file**, không gộp một checklist cho cả monorepo.

## Phạm vi diff

Ưu tiên theo thứ tự có sẵn:

1. Uncommitted / staged (nếu user nói “thay đổi hiện tại”)
2. Branch vs base (`main`/`master`/`develop`)
3. File user chỉ định

Không review toàn repo trừ khi được yêu cầu.

## Checklist chung

- [ ] Đúng yêu cầu / không scope creep
- [ ] Edge case & lỗi đã xử lý (null, empty, race rõ ràng)
- [ ] Không phá API/contract hiện có (trừ khi cố ý version)
- [ ] Bám pattern repo (đặt tên, folder, i18n, guard)
- [ ] Comment ADD/UPDATE tại điểm đăng ký nếu là upsert (đúng syntax ngôn ngữ)
- [ ] Test cập nhật hoặc nêu cách test thủ công
- [ ] Không hardcode secret; không log PII thừa
- [ ] FE: không bịa schema BE; BE: transaction/auth nếu đụng dữ liệu nhạy cảm

## Gợi ý theo stack

Sau detect: đọc mục **Fix** / **Standards** trong playbook của từng source xuất hiện trong diff. Không áp gợi ý Next cho file `.java`, v.v.

Comment ADD/UPDATE: đúng syntax ngôn ngữ file (không bắt buộc `//` trên Python).

## Format feedback

```
### Verdict: APPROVE | REQUEST CHANGES | COMMENT

### Critical (phải sửa)
- file:line — … — vì sao

### Suggestion
- …

### Nice to have
- …

### Đã ổn
- …
```

Critical = bug/security/data loss. Không nâng style preference thành Critical.

## Chuyển skill

- Vá bug tìm thấy → `/z-fix-bug`
- Nghi ngờ bảo mật sâu → `/z-security`
- Thiếu test → `/z-test`
