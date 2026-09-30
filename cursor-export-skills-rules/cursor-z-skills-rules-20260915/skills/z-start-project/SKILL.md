---
name: z-start-project
description: >-
  Bắt đầu dự án đa ngôn ngữ/framework: tự nhận từng source (language,
  framework, role), quét code, ghi z_docs 01a/01b/01c/01d + 02_Upsert_Feature.
  Một source ở gốc z_docs/; nhiều source trong z_docs/<ten>/. Dùng khi Bắt đầu
  dự án, Onboard, /onboard, /z-start-project, thiếu z_docs. Refresh: /z-refresh-docs.
disable-model-invocation: true
---

# z-start-project — Bắt đầu dự án

Bộ 01a + 02 của **từng source** đã có: **chỉ ĐỌC**, trừ `/z-refresh-docs` / `Refresh z_docs`.

Không skill nhánh (`-next`/`-vue`/`-angular9`). **Tự nhận diện** theo [stack-and-source.md](../z-dev-standards/references/stack-and-source.md); quét/02 theo [stack-playbooks.md](../z-dev-standards/references/stack-playbooks.md).

Áp dụng `/z-dev-standards`. Bản đồ: `/z-workflow`.

## Tên file chuẩn

| File | Vai trò |
|---|---|
| `01a_Structure.md` | Language, framework, tree, DB/env, bootstrap, config, naming |
| `01b_*` | Theo bảng 01b trong stack-and-source (DB / Pages / Views / Modules / Screens / Packages) |
| `01c_Feature.md` | Chức năng / module / màn + file chính (trace được) |
| `01d_ListAPIs.md` | method, path, class/handler/chỗ gọi |
| `02_Upsert_Feature.md` | Checklist upsert **của stack đã nhận** |

### Đổi tên cũ → mới (refresh thì đổi; start thường: đọc nếu chưa đổi)

| Cũ | Mới |
|---|---|
| `01b_DB_Schema.md` | `01b_DBschema.md` |
| `01c_Chuc_nang.md` | `01c_Feature.md` |
| `01d_APIs.md` | `01d_ListAPIs.md` |
| `02_Add_Edit_Common.md` | `02_Upsert_Feature.md` |
| `01_Project_Structure.md`, `01A_*` | `01a_Structure.md` |
| `01a_<ten>_Structure.md` ở gốc khi đa source | `z_docs/<ten>/01a_Structure.md` |

Không ghi đè `03_*.md` / `04_*.md` tài liệu yêu cầu.

## Bước chạy

1. **Locate** mọi source (protocol §1). Tạo `z_docs/` (+ `z_docs/<ten_source>/` nếu nhiều).
2. **Với từng source:** detect language → framework → role → context (§2–4). In block nhận diện.
3. Đọc config theo playbook khớp (+ Generic).
4. Ghi `01a_Structure.md` (nội dung đúng chỗ):
   - Language + version toolchain; framework + version
   - Role; cây thư mục; path alias
   - DB + version **nếu** BE/ORM trong source; FE thuần: không bịa schema
   - Bootstrap / routing / DI
   - Config hay đụng; quy ước đặt tên; lệnh dev/test/build thật
   - Docs cũ: hợp nhất, không xoá trừ khi user yêu cầu
5. Phân tích kỹ (mặc định **bật**; tắt: `start nhẹ` / `không phân tích kỹ`):
   - Ghi `01b_*` đúng loại §5 stack-and-source
   - `01c_Feature.md`, `01d_ListAPIs.md` — chỉ mục có nguồn trace
6. Ghi `02_Upsert_Feature.md`: mục bắt buộc dưới đây + checklist playbook (hoặc Generic copy từ màn mẫu).
7. Nhiều source: cập nhật mục lục gốc 01a–01d + 02 (tóm tắt + link, không nhét chi tiết).
8. Tóm tắt tiếng Việt: mỗi source (lang/fw/role), file tạo/đọc, bước tiếp (`/z-plan` hoặc `/z-add-edit`).

## Nội dung bắt buộc `02_Upsert_Feature.md`

- Thông tin trước khi code: tên, URL/path, quyền, API (đã có hoặc user yêu cầu)
- Checklist file đăng ký **theo playbook đã detect**
- Pattern Add vs Edit / upsert (cùng màn hay tách) — bám repo
- Việc không làm trên FE (menu DB, seed, secret) nếu role fe
- DoD + comment ADD/UPDATE đúng syntax ngôn ngữ

## Anti-pattern

- Một bộ docs cho cả monorepo khi có nhiều source
- Gán “Angular” cho mọi `package.json`
- Bịa endpoint/cột vì “thường thấy ở framework X”
