---
name: z-test
description: >-
  Viết và chạy test theo convention repo: nhận framework thật, ưu tiên
  RED-GREEN khi TDD, không bịa API. Đa stack. Dùng khi /z-test, TDD, thêm
  unit/integration test, verify sau fix, thiếu coverage.
disable-model-invocation: true
---

# z-test — Test / TDD

Tham chiếu: community TDD skills (RED → GREEN → REFACTOR), Cursor verify-with-tests.

Áp dụng `/z-dev-standards`. **Detect** source trước: [stack-and-source.md](../z-dev-standards/references/stack-and-source.md). Runner/test layout **theo source đó**.

## Nhận diện runner (file thật trong source)

Tìm script/`devDependency`/task hiện có — không thêm framework test mới trừ khi user yêu cầu; không lấy runner của source khác trong monorepo.

| Tín hiệu | Hướng |
|---|---|
| `jest`, `vitest`, `mocha` | Unit JS/TS |
| `playwright`, `cypress` | E2E |
| `@testing-library/*` | Component |
| `junit` / Gradle/`mvn test` | Java/Kotlin |
| `go test` | Go |
| `cargo test` | Rust |
| `pytest` / `unittest` | Python |
| `dotnet test` / xUnit/NUnit | .NET |
| `phpunit` / Pest | PHP |
| `flutter test` | Flutter |
| `rspec` | Ruby |

Bám thư mục test và naming của repo (`*.spec.ts`, `__tests__`, `src/test/java`, …).

## Chế độ

### A — TDD (user nói TDD / “test trước”)

1. **RED**: viết **một** test thất bại mô tả hành vi.
2. Chạy test — xác nhận fail đúng lý do.
3. **GREEN**: implement tối thiểu để xanh.
4. **REFACTOR**: chỉ khi xanh; hoặc chuyển `/z-refactor`.
5. Lặp cho behaviour tiếp theo — không viết cả suite rồi mới code.

### B — Bổ sung test sau (mặc định)

1. Đọc code + case cần cover (happy + 1–2 edge).
2. Viết test khớp pattern file kế bên.
3. Chạy test liên quan (ưu tiên file/target hẹp, không full suite trừ khi cần).
4. Sửa đến xanh; báo cáo lệnh đã chạy.

### C — Verify sau fix/refactor

Chạy test liên quan đến vùng sửa; nếu không có: đề xuất test tối thiểu hoặc checklist thủ công.

## Nguyên tắc

- Không mock mọi thứ đến mức test vô nghĩa; domain thuần: hạn chế mock infra nếu repo đang làm vậy.
- Không commit.
- Comment `// ADD: test <behaviour>` khi thêm file/case đáng chú ý.

## Kết thúc

1. File test đã thêm/sửa.
2. Lệnh đã chạy + kết quả.
3. Case chưa cover (nếu còn).
