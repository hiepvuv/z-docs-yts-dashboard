---
name: z-dev-standards
description: >-
  Chuẩn developer đa ngôn ngữ/framework: tự nhận source → language →
  framework → ngữ cảnh, tiếng Việt, comment // ADD // UPDATE, liệt kê file +
  z_docs, root cause, verify. Dùng mọi phiên code z-*. Lệnh cũ
  /z-dev-standards-next|-vue|-angular9 cũng dùng skill này. Bản đồ: /z-workflow.
---

# z-dev-standards — Chuẩn làm việc (đa nền tảng)

## Bắt buộc mỗi phiên có sửa code / docs

1. Chạy protocol nhận diện trong [references/stack-and-source.md](references/stack-and-source.md).
2. Áp **Chung** dưới đây + playbook khớp trong [references/stack-playbooks.md](references/stack-playbooks.md) (Generic nếu không khớp tên).
3. In ngắn: `Source | Language | Framework | Role | Docs`.

Không đoán version / API / schema. Bản đồ skill: `/z-workflow`.

---

## Chung (mọi ngôn ngữ)

### Vai trò & ngôn ngữ giao tiếp
- Developer: đọc convention **đúng source** đang làm.
- Giải thích với user: **tiếng Việt**.
- Không commit / push trừ khi user yêu cầu.

### Comment (theo syntax file)
| Ngữ cảnh | ADD / UPDATE |
|---|---|
| `//` languages (JS/TS/Java/Go/Rust/C#/… ) | `// ADD: …` / `// UPDATE: …` |
| JSX/TSX | `{/* ADD: … */}` |
| Vue/Svelte/HTML template | `<!-- ADD: … -->` |
| Python | `# ADD: …` |
| CSS/SCSS | `/* ADD: … */` |

Chỉ comment tại luồng quan trọng / điểm đăng ký — vì sao / đi đâu, không sáo rỗng.

### Kết thúc upsert
1. File code (path + 1 dòng/file).
2. `z_docs` đã đọc/cập nhật/chưa có — đúng `z_docs/<ten_source>/` nếu nhiều source.
3. Việc DB/env/user phải làm — không giả định đã làm giúp.

### Sửa lỗi
Root cause trước. Giải thích vì sao code cũ sai. `UPDATE` theo syntax trên + root cause ngắn.

### Verify
Lint/test hẹp của **source đó** nếu có script; không thì checklist thủ công. Đổi lớn → `/z-plan`; sau đó → `/z-review`.

### Ranh giới source
- Không áp convention Angular lên Spring (và ngược lại).
- FE không bịa schema BE; BE không bịa màn FE ngoài source.
- Không đổi major paradigm (Options↔Composition, NgModule↔standalone, Pages↔App Router) trừ khi user yêu cầu hoặc playbook/repo đã chuyển.

---

## Áp playbook

Đọc **chỉ** mục framework đã detect (+ Generic). Không nhét toàn bộ playbooks vào context nếu không cần.

Stack cũ “Angular 9 / Next / Vue / Spring” vẫn cover đầy đủ trong playbooks; thêm Nest, React, Python, .NET, Go, Rust, PHP, Flutter, …
