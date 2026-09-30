# 01a — Cấu trúc `emr_alarm`

Source: `emr_alarm/`. Chi tiết schema: [01b_DBschema.md](./01b_DBschema.md) · chức năng: [01c_Feature.md](./01c_Feature.md) · API: [01d_ListAPIs.md](./01d_ListAPIs.md) · upsert: [02_Upsert_Feature.md](./02_Upsert_Feature.md).

Mục lục workspace: [../01a_Structure.md](../01a_Structure.md).

> Refresh 2026-09-08 — quét lại `pom.xml`, `application-dev.yml`, `application.properties`, `web/rest` (78 `@RestController`), `LocalDevSecurityConfig` / `RequestFilter`.

## 1. Stack

| Mục | Giá trị (file thật) |
|---|---|
| Vai trò | Backend cấu hình + runtime chart/dashboard (prefix `/alarm`) |
| Artifact | `com.viettel.boc.alarm.app` / `boc-alarm` `1.0.0` (`pom.xml`) |
| Java | **21** |
| Spring Boot | **2.7.18** |
| JHipster | **7.8.1** (`jhipster-dependencies`) |
| Hibernate | 5.6.7.Final |
| Liquibase | 4.6.1 — **dev tắt** (`spring.jpa.liquibase.enabled: false`) |
| Keycloak adapter | 10.0.1 |
| Main class | `com.viettel.boc.alarm.app.BocAlarmApp` |
| Port (dev) | `${SERVER_PORT:8087}` (`application-dev.yml`); `bootstrap.yml` cũng `8087` |
| Context-path | Không khai báo → `/` |
| Prefix API | Hầu hết Resource `@RequestMapping("/alarm")` — **không** phải servlet context-path. Ngoại lệ: `/api` (một số CRUD JHipster), `/kham-lap`, `/alarm/datawarehouse`, `/alarm/catalog-kpi-alarm`, `/alarm/alarm_qualifier_detail` |
| Maven profile mặc định | `dev` (`activeByDefault`) |

## 2. Cây thư mục chính

Package gốc: `com.viettel.boc.alarm.app`

```
emr_alarm/
├── pom.xml
├── src/main/java/com/viettel/boc/alarm/app/
│   ├── BocAlarmApp.java
│   ├── config/          # Security, Persistence MCC/DW, RequestFilter, Constants
│   ├── domain/mcc/      # Entity MariaDB emr_alarm
│   ├── domain/datawarehouse/
│   ├── repository/mcc/ | datawarehouse/
│   ├── service/mcc/ | client/ (Feign)
│   ├── web/rest/        # ConfigChartResource, ConfigScreenResource, BuildChartResource…
│   └── dto/
└── src/main/resources/
    ├── application.properties
    └── config/application.yml | application-dev.yml | bootstrap.yml
```

## 3. Ngôn ngữ / môi trường

- JDK 21 (`pom.xml` `java.version`, compiler source/target).
- Maven 3.8.5 (property `maven.version`).
- Image Jib: `eclipse-temurin:21-jre`.

## 4. DB + Redis (dev)

Nguồn: `src/main/resources/config/application-dev.yml`.

| Datasource | JDBC | Schema | Entity package |
|---|---|---|---|
| MCC (`spring.mcc.datasource`) | `jdbc:mariadb://${URL_DB_MCC:10.60.158.45:8036}/emr_alarm?...` | **`emr_alarm`** | `domain.mcc` |
| Datalake (`spring.datawarehouse.datasource`) | cùng host, `${DB_DATALAKE_NAME:datawarehouse}` | **`datawarehouse`** | `domain.datawarehouse` |

- Driver: `org.mariadb.jdbc.Driver`; dialect: `MariaDB103Dialect`.
- User/pass mặc định: `hssk` / `hssk#123` (env `USERNAME_DB_MCC` / `PASSWORD_DB_MCC`).
- Cấu hình chart/dashboard nằm schema **`emr_alarm`**. Số liệu KPI runtime thường query **`datawarehouse`**.
- Redis: `use-redis: false` trên dev; host `localhost:6379` mặc định.

Prod (`application-prod.yml`) dùng `spring.datasource` khác (`boc_alarm` @ host khác) — không trộn với multi-DS dev.

## 5. Bootstrap

1. `BocAlarmApp.main` → `DefaultProfileUtil.addDefaultProfile(app)` (JHipster, thường `dev` nếu chưa set) → `app.run`.
2. `@SpringBootApplication`, `@EnableJpaAuditing`, `@EnableScheduling`, `@EnableDiscoveryClient`, `@EnableFeignClients(...service.client)`.
3. Eureka / discovery **tắt** trên dev: `spring.cloud.discovery.enabled: false`.
4. URL local chart: `http://localhost:8087/alarm/...`
5. Chạy dev: Maven profile `dev` mặc định; `BocAlarmApp` + `DefaultProfileUtil`. Port `8087`.

## 6. File cấu hình hay đụng

| File | Việc |
|---|---|
| `pom.xml` | Version, start-class, profile `dev` |
| `config/application-dev.yml` | Port, MCC + datalake, Redis, `permit-alarm-anonymous` |
| `application.properties` | Keycloak realm `hsskv2`, `keycloak.enabled`, `permit-alarm-anonymous` |
| `config/Constants.java` | `SCREEN_*`, `TYPE_CHART_CATITEM`, time type |
| `config/SecurityConfig.java` | Keycloak (khi tắt anonymous) |
| `config/LocalDevSecurityConfig.java` | Local: không Keycloak, permitAll |
| `config/RequestFilter.java` | Header user; local skip JWT |
| `config/PersistenceMccConfiguration.java` | EntityManager MCC |

## 7. Security (local vs prod)

| Cờ | File | Hành vi |
|---|---|---|
| `alarm.security.permit-alarm-anonymous=true` | `application.properties` + `application-dev.yml` | Load `LocalDevSecurityConfig` (`web.ignoring /**`, permitAll). **Không** load `SecurityConfig` / `KeycloakConfiguration`. |
| `keycloak.enabled=false` | cùng | Tắt adapter Spring Boot Keycloak |
| `RequestFilter` | luôn là `@Component` | Flag on: header giả `ROLE_TYPE=0`, `USER_ID=local-dev`, không `RSATokenVerifier`. Flag off: bắt Bearer + `sys_users` |

Login FE **không** đi service này — đi `emr_resource` (port 9005). Local chỉ bỏ JWT trên `/alarm/**` để chart không treo JWKS.

**Trước deploy prod:** `permit-alarm-anonymous=false`, `keycloak.enabled=true`.

## 8. Quy ước đặt tên

- Resource: `*Resource.java`; **đa số** class-level `/alarm` — luôn đọc annotation trước khi gọi (một số class `/api` hoặc path riêng).
- Entity MCC: `@Table` snake_case (`config_chart`), class PascalCase.
- Comment đăng ký: `// ADD:` / `// UPDATE:`.
- Không xóa API/bảng cũ nếu DB đang dùng.

## 9. Tài liệu liên quan

- [01b_DBschema.md](./01b_DBschema.md) — bảng chart/dashboard.
- [01d_ListAPIs.md](./01d_ListAPIs.md) — REST `/alarm`.
- FE gọi API này: [../emr_web/01d_ListAPIs.md](../emr_web/01d_ListAPIs.md).
