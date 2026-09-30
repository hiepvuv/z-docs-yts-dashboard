---
name: z-commit
description: >-
  Commit đúng phạm vi: file code của chức năng được ghi kèm lệnh, hoặc file
  vừa trao đổi trong hội thoại nếu không ghi chức năng. Không commit cả
  working tree, không push. Dùng khi /z-commit, commit chức năng, commit
  phần vừa sửa.
disable-model-invocation: true
---

# z-commit — Commit đúng phạm vi

Chỉ chạy khi user gọi `/z-commit` hoặc yêu cầu commit. Không push trừ khi user nói rõ.

Áp dụng git safety trong user rules: không sửa git config, không `--no-verify`, không `git add -i`, không commit secret (`.env`, credential, key).

## Chọn file

1. **Có ghi chức năng** sau lệnh (tên, path, “chỉ …”) — stage file code của đúng chức năng đó.
2. **Không ghi gì** — stage file đã sửa trong trao đổi code phía trên cuộc hội thoại này. Không lấy toàn bộ `git status`.

File code gồm source, SQL, config của chức năng đó. File `.md` chỉ vào commit khi chính trao đổi hoặc ghi chú chức năng đã sửa file đó.

Bỏ file không thuộc phạm vi dù đang dirty. Không chắc file nào thì **để ngoài** và nói tên file, không commit đại.

Không có file đúng phạm vi → không tạo commit rỗng.

## Bước

1. Song song: `git status`, `git diff` (staged + unstaged), `git log` gần đây để bắt style message.
2. Lập danh sách vào / để ngoài. Đối chiếu diff thật, không dựa tên file.
3. `git add` từng path trong danh sách vào.
4. Commit message 1–2 câu, vì sao, theo style `git log`.
5. `git status` sau commit. Trả lời: hash ngắn, message, file đã vào, file dirty còn để ngoài.

`/z-pr` không tự gọi skill này. User muốn PR thì gọi riêng.