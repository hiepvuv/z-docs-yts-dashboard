---
name: z-ask
description: >-
  Trao đổi và đánh giá ý tưởng dựa trên code đang có: đọc source, schema,
  caller rồi kết luận làm được hay không. Không sửa code. Dùng khi /z-ask,
  đánh giá phương án, đổi thiết kế, “có nên”, “bỏ được không”, so sánh hướng.
disable-model-invocation: true
---

# z-ask — Đánh giá ý tưởng

**Không sửa file. Không commit.** Chỉ kết luận sau khi đã đọc code liên quan.

Khác skill khác:

| Skill | Việc |
|---|---|
| `/z-explain` | Code đang làm gì |
| `/z-ask` | Ý tưởng này có đúng với code và dữ liệu không |
| `/z-plan` | Đã chốt hướng, viết các bước sửa |
| `/z-review` | Diff đã viết có lỗi không |

Áp dụng `/z-dev-standards`. Detect source: [stack-and-source.md](../z-dev-standards/references/stack-and-source.md). Không bịa API, cột, bảng, index.

## Bước

1. **Một câu** — ý tưởng là quyết định gì (đổi bảng, bỏ cột, đổi join, đổi lịch…).
2. **Đọc** file, DDL, caller mà ý tưởng đụng. Không đánh giá từ trí nhớ nếu file nằm trong workspace.
3. **Tách** ba lớp, không trộn:
   - Thấy trong code hoặc DDL
   - Suy ra từ cái đã thấy
   - Chưa có trong repo — nói chưa biết, không đoán tên cột
4. **Hệ quả** — số liệu, grain, null và chuỗi rỗng, contract cột đích, hiệu năng, việc nằm ngoài source (index lake, dashboard đọc cột).
5. **Kết luận trước**, rồi dẫn chứng.

User bảo “làm luôn” / “sửa đi” thì dừng đánh giá và chuyển `/z-fix-bug`, `/z-add-edit`, hoặc `/z-plan` nếu đụng nhiều file.

## Format

```
### Kết luận
Làm được | Làm được nếu … | Không nên

### Đã thấy
- path — fact ngắn

### Hệ quả
- …

### Chưa biết
- …

### Nếu làm
- skill tiếp theo và phạm vi, không viết patch
```

Kết luận một hướng. Không liệt kê nhiều phương án ngang nhau trừ khi hai hướng cùng khớp code và khác hệ quả thật.

## Không làm

- Không sửa code, SQL, docs trong lượt `/z-ask`.
- Không nâng sở thích style thành lý do từ chối.
- Không coi tài liệu cũ đúng hơn DDL hoặc SQL đang chạy nếu hai bên lệch — nêu lệch đó.
