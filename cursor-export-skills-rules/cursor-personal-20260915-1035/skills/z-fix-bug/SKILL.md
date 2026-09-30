---
name: z-fix-bug
description: >-
  Sửa lỗi root cause đa ngôn ngữ/framework: tự nhận source → language →
  framework → ngữ cảnh, tái hiện, khoanh vùng, giải thích, vá, verify. Dùng
  khi Sửa lỗi, /z-fix-bug, /fix-bug, exception, hành vi sai. Lệnh cũ
  /z-fix-bug-next|-vue|-angular9 cũng chạy skill này.
disable-model-invocation: true
---

# z-fix-bug — Sửa lỗi (root cause trước)

Không skill nhánh. **Detect trước** → [stack-and-source.md](../z-dev-standards/references/stack-and-source.md); gợi ý lỗi → mục framework trong [stack-playbooks.md](../z-dev-standards/references/stack-playbooks.md) (+ Generic).

Áp dụng `/z-dev-standards`.

Tham chiếu cộng đồng: reproduce → isolate → root cause → fix → verify.

## Bước

0. **Nhận diện** source đang lỗi (path log / file mở / URL). In: `Source | Language | Framework | Role`.
1. **Tái hiện** — bước, expected vs actual, log/stack. Thiếu info: ≤2–3 câu hoặc tự reproduce đúng toolchain source đó.
2. **Khoanh vùng** — file, hàm, điều kiện; đối chiếu gợi ý **Fix** trong playbook đã chọn.
3. **Root cause** — vì sao sai (contract, config, race, lifecycle… — không dừng ở triệu chứng).
4. **Giải thích tiếng Việt** — chỗ sai + vì sao.
5. **Vá** đúng convention **source đó**; comment `UPDATE` đúng syntax ngôn ngữ + root cause ngắn. Nêu rủi ro hồi quy.
6. **Verify** — test/lint hẹp (`/z-test` nếu cần) hoặc checklist tái hiện trên đúng runtime (Node/JDK/Python/…).
7. Liệt kê file đã đụng.

Không commit trừ khi user yêu cầu. Nhiều hướng / lớn → `/z-plan`. Auth/input/secret → gợi ý `/z-security`.

## Khi chưa khớp playbook tên

Dùng **Generic** + đọc 2–3 file kế bên cùng layer (handler/service/view) để bắt pattern xử lý lỗi của repo — không import thói quen framework khác source.
