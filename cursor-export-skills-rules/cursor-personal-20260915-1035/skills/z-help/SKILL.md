---
name: z-help
description: >-
  Hướng dẫn cách dùng bộ skill z-*: danh sách lệnh, khi nào gọi, chuỗi
  làm việc, ví dụ prompt, mẹo detect source/stack. Dùng khi /z-help, help,
  hướng dẫn skill, cách dùng z-*, liệt kê skill.
disable-model-invocation: true
---

# z-help — Hướng dẫn dùng skill z-*

Skill này **chỉ hướng dẫn** (không sửa code). Trả lời tiếng Việt, ngắn trước — chi tiết khi user hỏi sâu.

Vị trí: `~/.cursor/skills/` (personal). Gọi bằng `/tên-skill` trong Agent chat.

Chưa chắc skill nào → `/z-workflow` (router) hoặc đọc bảng dưới.

---

## Cách gọi

1. Mở **Agent** chat.
2. Gõ `/` → chọn skill, hoặc gõ đủ `/z-help`, `/z-start-project`, …
3. Viết thêm ngữ cảnh sau lệnh (path, bug, tên chức năng).

Hầu hết skill `z-*` có `disable-model-invocation: true` → **chỉ chạy khi bạn gọi `/…`** (trừ `/z-dev-standards` có thể được agent tự áp khi đang code).

---

## Bản đồ nhanh

| Bạn muốn… | Gõ | Ghi chú |
|---|---|---|
| Xem hướng dẫn này | `/z-help` | |
| Chọn skill hộ | `/z-workflow` | Router 1 skill chính |
| Onboard / tạo `z_docs` | `/z-start-project` hoặc `/onboard` | Không ghi đè 01+02 đã có |
| Ghi đè lại docs | `/z-refresh-docs` hoặc `Refresh z_docs` | |
| Hiểu code, không sửa | `/z-explain` | Read-only |
| Lập kế hoạch trước | `/z-plan` | Chờ bạn duyệt rồi mới code |
| Thêm / sửa chức năng | `/z-add-edit` | |
| Sửa lỗi (root cause) | `/z-fix-bug` | |
| Refactor giữ hành vi | `/z-refactor` | |
| Viết / chạy test | `/z-test` | |
| Review diff | `/z-review` | Mặc định không tự vá |
| Audit bảo mật | `/z-security` | |
| Tạo pull request | `/z-pr` | Chỉ khi bạn yêu cầu PR |
| Chuẩn comment / DoD | `/z-dev-standards` | Nền cho mọi skill khác |

Lệnh nhánh cũ (`/z-*-next`, `-vue`, `-angular9`) → dùng skill gộp tương ứng ở trên.

---

## Chuỗi làm việc khuyến nghị

```
Lần đầu repo:
  /z-start-project
      → /z-explain (nếu cần hiểu)
      → /z-plan (đổi lớn)
      → /z-add-edit  hoặc  /z-fix-bug  hoặc  /z-refactor
      → /z-test
      → /z-review  (+ /z-security nếu auth/upload/…)
      → /z-pr      (khi bạn muốn mở PR)
```

- Task nhỏ, rõ ràng: bỏ `/z-plan`, vào thẳng `/z-add-edit` hoặc `/z-fix-bug`.
- Đổi docs đã có: `/z-refresh-docs` (không dùng start để ghi đè).

---

## Từng skill — dùng thế nào

### `/z-start-project` (`/onboard`)
**Làm gì:** Nhận từng source (language/framework/role), quét code, ghi `z_docs` (`01a`…`01d`, `02`).
**Prompt mẫu:**
- `/z-start-project`
- `/z-start-project` chỉ source `web` — start nhẹ
- `/onboard` phân tích kỹ

### `/z-refresh-docs`
**Làm gì:** Quét lại và **ghi đè** 01–02. Không đụng `03_*` / `04_*` trừ khi bạn nói rõ.
**Prompt mẫu:** `/z-refresh-docs` toàn bộ · `/z-refresh-docs` source `backend`

### `/z-explain`
**Làm gì:** Trace luồng, giải thích — **không sửa file**.
**Prompt mẫu:** `/z-explain` luồng đăng nhập · `/z-explain` file `…` này làm gì

### `/z-plan`
**Làm gì:** Hỏi làm rõ + viết plan (file, rủi ro, DoD). **Không code** đến khi bạn OK (hoặc bảo “làm luôn”).
**Prompt mẫu:** `/z-plan` thêm màn báo cáo X · `/z-plan` rồi làm luôn sau khi duyệt

### `/z-add-edit`
**Làm gì:** Upsert chức năng theo `02_Upsert_Feature` + pattern repo; comment ADD/UPDATE.
**Prompt mẫu:** `/z-add-edit` thêm danh sách thiết bị path `/devices` · `/z-add-edit` sửa form chỉnh sửa Y

### `/z-fix-bug`
**Làm gì:** Tái hiện → root cause → vá → verify.
**Prompt mẫu:** `/z-fix-bug` nộp form bị 500, log: … · `/z-fix-bug` UI không cập nhật sau save

### `/z-refactor`
**Làm gì:** Đổi cấu trúc, **giữ hành vi**; từng bước + verify.
**Prompt mẫu:** `/z-refactor` tách service từ controller Z — không đổi API

### `/z-test`
**Làm gì:** TDD hoặc bổ sung/chạy test đúng runner của source.
**Prompt mẫu:** `/z-test` TDD cho validate email · `/z-test` cover case null id

### `/z-review`
**Làm gì:** Review diff → verdict (APPROVE / REQUEST CHANGES). Không tự sửa trừ khi bạn bảo “vá luôn”.
**Prompt mẫu:** `/z-review` thay đổi hiện tại · `/z-review` branch so với main

### `/z-security`
**Làm gì:** Rà authz, injection, secret, XSS/IDOR trên phạm vi chỉ định.
**Prompt mẫu:** `/z-security` diff lần này · `/z-security` API admin

### `/z-pr`
**Làm gì:** Push (nếu cần) + `gh pr create`. Không tự commit nếu bạn chưa yêu cầu commit.
**Prompt mẫu:** `/z-pr` · commit rồi `/z-pr` (nếu chưa commit: nói rõ “commit và tạo PR”)

### `/z-dev-standards`
**Làm gì:** Chuẩn chung (tiếng Việt, comment, DoD, ranh giới source). Thường đi kèm skill khác.
**Prompt mẫu:** ít khi gọi một mình; agent áp khi đang upsert/fix.

### `/z-workflow`
**Làm gì:** Chọn **một** skill phù hợp và chạy tiếp (không chỉ liệt kê nếu đã đủ info).

---

## Detect tự động (mọi z-* khi làm việc)

Agent sẽ xác định rồi in ngắn:

```
Source | Language | Framework | Role | Docs
```

- **Nhiều source** (monorepo): nêu rõ source (`web`, `backend`, …) trong prompt nếu biết.
- **Không đoán** version/API/schema — lấy từ file thật / `z_docs`.
- Chi tiết protocol: `z-dev-standards/references/stack-and-source.md`.

---

## `z_docs` — cần biết

| | Vị trí |
|---|---|
| Một source | `z_docs/01a…`, `02…` |
| Nhiều source | `z_docs/<ten_source>/…`; gốc chỉ mục lục |

| File | Ý nghĩa |
|---|---|
| `01a_Structure.md` | Stack, cấu trúc, env |
| `01b_*` | DB / Pages / Views / Modules / Screens / Packages |
| `01c_Feature.md` | Chức năng |
| `01d_ListAPIs.md` | API |
| `02_Upsert_Feature.md` | Checklist thêm/sửa |

Start **không** ghi đè 01+02 đã có. Muốn ghi đè → `/z-refresh-docs`.

---

## Mẹo prompt tốt

- Một việc / một lệnh; tránh “onboard + làm feature + PR” trong một hơi trừ khi cố ý.
- Kèm: path file, URL màn, expected vs actual, source name.
- Đổi lớn: `/z-plan` trước.
- Không commit/push/PR trừ khi bạn nói rõ.

---

## Khi user gọi `/z-help`

1. Tóm tắt bảng **Bản đồ nhanh** + chuỗi khuyến nghị (ngắn).
2. Nếu họ nêu mục tiêu cụ thể → chỉ **một** skill + 1 prompt mẫu; đề nghị chạy luôn nếu họ muốn.
3. Không sửa code trong `/z-help`.
