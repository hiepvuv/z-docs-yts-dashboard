# Cài bộ skill/rules z-* trên laptop mới

Gói **chỉ** nội dung `z-*` (không gồm git/PR/FE design/communication, không gồm `onboard` / `user.mdc`).

## Nội dung

| Thư mục | File |
|---------|------|
| `skills/` | `z-add-edit`, `z-dev-standards` (+ `references/`), `z-explain`, `z-fix-bug`, `z-help`, `z-plan`, `z-pr`, `z-refactor`, `z-refresh-docs`, `z-review`, `z-security`, `z-start-project`, `z-test`, `z-workflow` |
| `rules/` | `z-dev-workflow.mdc` (`alwaysApply: true`) |
| `user-rules/` | `z-dev-workflow-prompt.md` — dán Settings nếu cần (trùng một phần `.mdc`) |

## Cài đặt (Windows)

```powershell
Expand-Archive .\cursor-z-skills-rules-20260915.zip -DestinationPath .
$pack = Get-ChildItem .\cursor-z-skills-rules-* -Directory | Select-Object -First 1
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.cursor\skills","$env:USERPROFILE\.cursor\rules" | Out-Null
Copy-Item "$($pack.FullName)\skills\*" "$env:USERPROFILE\.cursor\skills\" -Recurse -Force
Copy-Item "$($pack.FullName)\rules\*" "$env:USERPROFILE\.cursor\rules\" -Force
```

Tùy chọn: Cursor → Settings → Rules → User Rules → dán `user-rules\z-dev-workflow-prompt.md`.

Kiểm tra: Agent chat → `/z-help` hoặc `/z-workflow`.
