---
name: z-security
description: >-
  Rà soát bảo mật thay đổi/code: authz, injection, secret, XSS/CSRF,
  IDOR, upload, dependency rủi ro bề mặt. Đa stack. Dùng khi /z-security,
  security review, audit bảo mật, auth, lỗ hổng.
disable-model-invocation: true
---

# z-security — Security review

Tham chiếu: Cursor `/review-security`, OWASP ASVS (mức thực dụng trên diff).

**Mặc định chỉ báo cáo.** Vá khi user yêu cầu — ưu tiên `/z-fix-bug` cho từng lỗ hổng.

Không đưa PoC tấn công / hướng dẫn tấn công vượt mức cần để hiểu rủi ro. Đủ để dev sửa.

Áp dụng `/z-dev-standards`. **Detect** language/framework từng vùng trong phạm vi: [stack-and-source.md](../z-dev-standards/references/stack-and-source.md).

## Phạm vi

Ưu tiên diff / file user chỉ định. Full-repo audit chỉ khi được yêu cầu rõ (và vẫn ưu tiên entrypoint: auth, upload, payment, admin). Finding phải gắn đúng stack (vd XSS FE ≠ SQL BE).

## Checklist thực dụng

- [ ] **AuthN**: endpoint/màn có yêu cầu đăng nhập đúng chỗ?
- [ ] **AuthZ**: kiểm tra quyền trên **object** (IDOR), không chỉ “đã login”
- [ ] **Input**: SQL/NoSQL/command/path; validation server-side (không tin mỗi FE)
- [ ] **XSS**: HTML/Markdown/user content; `dangerouslySetInnerHTML` / `[innerHTML]`
- [ ] **CSRF / CORS / cookie**: SameSite, token state-changing nếu repo dùng cookie session
- [ ] **Secret**: `.env` commit, key trong client bundle, log token
- [ ] **File upload**: type/size/path; không phục vụ executable như static tin cậy
- [ ] **Deserialization / SSRF / redirect mở** nếu có pattern trong diff
- [ ] **Dependency** mới: quyền rộng, package lạ (cờ nhẹ — không thay SCA đầy đủ)

## Theo stack (gợi ý)

**Next/Vue/Angular:** token trong `localStorage` vs httpOnly; `NEXT_PUBLIC_*` lộ secret; bypass guard chỉ FE.

**Java/Spring:** method security vs filter order; mass assignment; path traversal trên resource.

## Format

```
### Risk summary: Low | Medium | High | Critical

### Findings
| Mức | Vị trí | Vấn đề | Hướng xử lý (mức cao) |
|---|---|---|---|
| High | file:line | … | … |

### Không thấy / ngoài phạm vi
- …
```

## Chuyển skill

Vá từng finding → `/z-fix-bug`. Review chất lượng chung → `/z-review`.
