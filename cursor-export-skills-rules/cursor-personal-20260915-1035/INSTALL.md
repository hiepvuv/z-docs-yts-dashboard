# Cài skill & rules Cursor trên laptop mới

Export từ máy: `hiepv` · Ngày: 2026-09-15  
**Không** gồm `~/.cursor/skills-cursor/` (skill built-in của Cursor — máy mới tự có).

## Cấu trúc gói

```
cursor-personal-*/
├── skills/          → copy vào ~/.cursor/skills/
├── rules/           → copy vào ~/.cursor/rules/
├── user-rules/      → dán vào Cursor Settings → Rules (User Rules)
└── INSTALL.md
```

## 1. Skills (personal)

Trên Windows laptop mới:

```powershell
# Tạo thư mục nếu chưa có
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.cursor\skills" | Out-Null

# Copy toàn bộ skill từ gói (đổi đường dẫn SOURCE cho đúng)
$src = "D:\path\to\cursor-personal-*\skills\*"
Copy-Item -Path $src -Destination "$env:USERPROFILE\.cursor\skills\" -Recurse -Force
```

Trên macOS/Linux:

```bash
mkdir -p ~/.cursor/skills
cp -R ./skills/* ~/.cursor/skills/
```

Sau khi copy, mở lại Cursor (hoặc New Agent chat). Gõ `/z-help` hoặc `/z-workflow` để kiểm tra.

## 2. Rules (user-level `.mdc`)

```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.cursor\rules" | Out-Null
Copy-Item -Path ".\rules\*" -Destination "$env:USERPROFILE\.cursor\rules\" -Force
```

| File | Vai trò |
|------|---------|
| `z-dev-workflow.mdc` | `alwaysApply: true` — workflow z-* tiếng Việt |
| `user.mdc` | Rule cá nhân (gắn `@user` khi cần) |

## 3. User Rules (Cursor Settings)

Các rule trong `user-rules/*.md` **không** tự load từ file — phải dán thủ công:

1. Cursor → **Settings** → **Rules** → **User Rules**
2. Tạo / dán nội dung từng file trong `user-rules/` (hoặc gộp một block lớn).
3. Bật apply theo nhu cầu.

| File | Nội dung |
|------|----------|
| `01-git-commit.md` | Quy trình commit git an toàn |
| `02-pull-request.md` | Quy trình tạo PR bằng `gh` |
| `03-frontend-design.md` | Chuẩn UI/landing (tránh generic AI look) |
| `04-communication.md` | Cách trả lời ngắn gọn |
| `05-z-dev-workflow-prompt.md` | Prompt kích hoạt + Rule 1/2 (trùng một phần `z-dev-workflow.mdc`) |

> Nếu đã có `z-dev-workflow.mdc` (`alwaysApply`), có thể **không** dán lại `05-...` để tránh trùng.

## 4. Kiểm tra nhanh

1. Agent chat → gõ `/z-help`
2. Gõ `Onboard` / `/z-start-project` trên một repo thử
3. Xác nhận agent trả lời tiếng Việt + biết `z_docs`

## Lưu ý

- Đăng nhập **cùng tài khoản Cursor** có thể đồng bộ một phần User Rules cloud — vẫn nên mang file `user-rules/` để chắc chắn.
- Project rules (`.cursor/rules` trong từng repo) **không** nằm trong gói này — commit theo repo nếu cần.
- `skills-cursor` (create-skill, share, canvas…) là built-in — **không** copy.
