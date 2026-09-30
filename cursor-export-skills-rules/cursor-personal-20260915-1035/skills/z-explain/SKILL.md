---
name: z-explain
description: >-
  Giải thích codebase / luồng / kiến trúc ở chế độ chỉ đọc: trace file,
  không sửa code, không bịa API. Đa stack. Dùng khi /z-explain, giải thích,
  trace luồng, “code này làm gì”, kiến trúc, onboarding hiểu nhanh.
disable-model-invocation: true
---

# z-explain — Giải thích (read-only)

**Không sửa file** (trừ khi user đổi sang skill khác). Không tạo commit.

Áp dụng `/z-dev-standards`. **Detect** [stack-and-source.md](../z-dev-standards/references/stack-and-source.md).

## Bước

1. Xác định câu hỏi + **detect** source (lang/fw/role).
2. Đọc `z_docs` đúng source nếu có; nếu thiếu và câu hỏi rộng → gợi ý `/z-start-project`, vẫn trả lời được phần đã trace.
3. Trace từ entry (route / controller / page) → service → data / API client.
4. Trả lời tiếng Việt: ngắn trước, chi tiết theo mức cần.

## Format trả lời

1. **Một câu** tóm tắt vai trò.
2. **Luồng** (3–7 bước) kèm path file chính.
3. **Điểm đáng chú ý** (guard, side-effect, config) — chỉ cái đã thấy trong code.
4. **Lỗ hổng hiểu biết** (chưa đọc / phụ thuộc runtime) — nói rõ, không đoán.

## Cite code

Dùng citation theo format Cursor khi trích đoạn quan trọng. Không dump cả file.

## Khi nào chuyển skill

| User muốn… | Chuyển |
|---|---|
| Sửa bug vừa chỉ ra | `/z-fix-bug` |
| Thêm/sửa chức năng | `/z-add-edit` (hoặc `/z-plan` nếu lớn) |
| Đổi cấu trúc giữ hành vi | `/z-refactor` |
