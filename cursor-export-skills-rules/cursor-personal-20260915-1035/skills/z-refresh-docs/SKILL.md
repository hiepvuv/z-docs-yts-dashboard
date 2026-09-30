---
name: z-refresh-docs
description: >-
  Ghi đè / đồng bộ lại z_docs (01a–01d + 02) theo chuẩn z-start-project.
  Chỉ chạy khi user yêu cầu Refresh z_docs hoặc /z-refresh-docs. Đa source.
disable-model-invocation: true
---

# z-refresh-docs — Refresh z_docs

**Khác** `/z-start-project`: start **không** ghi đè bộ 01+02 đã có; skill này **được phép ghi đè** 01a/01b/01c/01d/02 theo quét lại code.

Không xoá `03_*.md` / `04_*.md` (tài liệu yêu cầu) trừ khi user nói rõ.

Chạy toàn bộ quy trình quét + ghi của `/z-start-project` với cờ **refresh = true** (detect lại language/framework từng source).

Áp dụng `/z-dev-standards`. Protocol: [stack-and-source.md](../z-dev-standards/references/stack-and-source.md); playbook: [stack-playbooks.md](../z-dev-standards/references/stack-playbooks.md).

## Bước

1. Xác nhận phạm vi: **mọi source** hay `z_docs/<ten_source>/` cụ thể.
2. Phân tích kỹ: mặc định **bật**. Tắt nếu user nói `start nhẹ` / `không phân tích kỹ`.
3. Đổi tên file cũ → chuẩn mới nếu còn (`01b_DB_Schema.md` → `01b_DBschema.md`, …) theo bảng trong `/z-start-project`.
4. Quét lại code → ghi đè 01a–01d + 02 (và mục lục gốc nếu nhiều source).
5. Hợp nhất ý từ docs cũ còn giá trị; không bịa.
6. Tóm tắt tiếng Việt: source đã refresh, stack, file ghi đè, cảnh báo nếu thiếu marker.

## An toàn

- Không đụng source code ứng dụng.
- Không commit.
- Nếu không chắc source nào: liệt kê candidate rồi hỏi 1 câu.
