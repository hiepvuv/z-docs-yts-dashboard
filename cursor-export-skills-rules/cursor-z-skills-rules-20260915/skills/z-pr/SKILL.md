---
name: z-pr
description: >-
  Tạo pull request: kiểm tra branch/diff, push nếu cần, gh pr create với
  summary + test plan. Đa repo. Dùng khi /z-pr, tạo PR, open pull request,
  đề nghị merge.
disable-model-invocation: true
---

# z-pr — Tạo pull request

Chỉ chạy khi user **yêu cầu tạo PR** (hoặc `/z-pr`).

Áp dụng `/z-dev-standards` + git safety: không force-push main/master; không `--no-verify`; không sửa git config.

## Trước khi tạo

Chạy **song song**:

- `git status`
- `git diff` / `git diff --staged`
- `git log` / `git diff <base>...HEAD`
- Kiểm tra track remote + ahead/behind

Nếu còn thay đổi chưa commit: **hỏi** user có muốn commit trước không — không tự commit trừ khi user đã bảo commit + PR.

Khuyến nghị trước PR (không bắt buộc block): `/z-review` nhanh; vùng nhạy cảm → `/z-security`.

## Bước

1. Base branch: `main` / `master` / `develop` — lấy từ remote mặc định repo.
2. Push `-u` nếu chưa có upstream (`git push -u origin HEAD`).
3. `gh pr create` với title ngắn + body:

```markdown
## Summary
- …

## Test plan
- [ ] …
- [ ] …

## Notes
- DB/env cần làm (nếu có): …
```

4. Trả về **URL PR** cho user.

## Title

Conventional nếu repo đang dùng (`feat:`, `fix:`, …). Không thì 1 câu “why”.

## Không làm

- PR trống (không diff)
- Đẩy secret (`.env`, key) — cảnh báo và dừng
- Tự merge / tự approve
