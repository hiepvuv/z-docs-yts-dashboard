---
name: onboard
description: >-
  Onboard dự án: alias /z-start-project — tự nhận language/framework từng
  source, ghi z_docs 01+02. Dùng khi Bắt đầu dự án, Onboard, /onboard, thiếu
  z_docs. Refresh: /z-refresh-docs. Bản đồ: /z-workflow.
disable-model-invocation: true
---

# Onboard dự án

Chạy **toàn bộ** `/z-start-project` (tự nhận source → language → framework → role). Không dùng `-next` / `-vue` / `-angular9`.

Tóm tắt output: mỗi source có lang/fw; `01a`, `01b_*`, `01c_Feature`, `01d_ListAPIs`, `02_Upsert_Feature`. Nhiều source: nội dung trong `z_docs/<ten>/`, gốc là mục lục.

Ghi đè docs → `/z-refresh-docs`. Không chắc skill tiếp → `/z-workflow`.
