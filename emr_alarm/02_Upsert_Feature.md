# 02 — Upsert chức năng (`emr_alarm`)

Áp dụng Java 21 / Spring Boot 2.7 / JHipster. Comment `// ADD:` / `// UPDATE:`. Không commit trừ khi được yêu cầu.

Đọc trước: [01a_Structure.md](./01a_Structure.md), [01b_DBschema.md](./01b_DBschema.md), [01d_ListAPIs.md](./01d_ListAPIs.md). FE song song: [../emr_web/02_Upsert_Feature.md](../emr_web/02_Upsert_Feature.md).

> Refresh 2026-09-08. Path chart: clone = `POST /alarm/config-charts/clone/{id}`. Không giả định mọi Resource đều `/alarm`.

## 1. Thông tin trước khi code

| Hạng mục | Bắt buộc | Ghi chú |
|---|---|---|
| Tên API / resource | Có | Bám `*Resource` cùng domain |
| HTTP method + path | Có | Đọc `@RequestMapping` trên class (đa số `/alarm`; có `/api`, `/kham-lap`, …). Không bịa path |
| Bảng / entity | Có | Chỉ cột đã có trên `@Entity` trừ khi user yêu cầu schema mới |
| Datasource | Có | Cấu hình MCC `emr_alarm` vs số liệu `datawarehouse` |
| Auth | Có | Local anonymous; prod Keycloak + `RequestFilter` headers |

## 2. Checklist file đăng ký (Java)

1. `domain/mcc/` (hoặc `datawarehouse/`) — entity nếu bảng mới (user đã đồng ý schema).
2. `repository/mcc/` — Spring Data / custom query.
3. `service/mcc/` — nghiệp vụ, không nhét SQL vào Resource.
4. `web/rest/*Resource.java` — mapping thật trên class + method; `// ADD:`.
5. `dto/` nếu payload khác entity.
6. `config/Constants.java` — hằng loại màn/chart nếu cần.
7. YAML: **không** bịa property; chỉ thêm khi convention repo đã có chỗ tương ứng.
8. Liquibase: dev đang tắt; changelog mới chỉ khi user yêu cầu và bật Liquibase.

Không tạo menu/action Keycloak trên BE alarm — thuộc `emr_resource` / DB SYS_MENU.

## 3. Pattern Add vs Edit

| Đối tượng | Add | Edit |
|---|---|---|
| Chart | `POST /alarm/config-charts` | `POST /alarm/config-charts-update` (không phải PUT) |
| Screen | `POST /alarm/config-screens` | `PUT /alarm/config-screens` |
| Profile | `POST /alarm/config-profiles` | `PUT /alarm/config-profiles` |

Clone: `POST /alarm/config-charts/clone/{id}`, `POST /alarm/config-screens/copy/{id}`.

Preview data: `POST /alarm/config-charts/preview`. Runtime dashboard: `GET /alarm/get-chart-result/{id}`.

## 4. Việc không làm trên BE này

- Không tạo user/menu FE.
- Không giả định đã insert `config_chart` / seed datalake.
- Không bật Keycloak local nếu đang dùng `permit-alarm-anonymous` (trừ khi user yêu cầu).
- Không xóa endpoint cũ nếu FE/DB đang gọi.

## 5. Definition of done

- Path/method khớp Resource hiện có hoặc `// ADD` rõ.
- Entity/cột có nguồn `@Column` / SQL.
- Local: gọi được không treo JWT (`RequestFilter` skip khi flag on).
- Liệt kê file đã sửa + việc DBA/env (nếu có).
- FE: cập nhật [../emr_web/](../emr_web/) nếu có màn mới.
