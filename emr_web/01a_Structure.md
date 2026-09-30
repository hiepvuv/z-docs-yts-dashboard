# 01a — Cấu trúc `emr_web`

Source: `emr_web/`. Modules: [01b_Modules_Components.md](./01b_Modules_Components.md) · chức năng: [01c_Feature.md](./01c_Feature.md) · API client: [01d_ListAPIs.md](./01d_ListAPIs.md) · upsert: [02_Upsert_Feature.md](./02_Upsert_Feature.md).

Mục lục workspace: [../01a_Structure.md](../01a_Structure.md). BE alarm: [../emr_alarm/01a_Structure.md](../emr_alarm/01a_Structure.md).

> Refresh 2026-09-08 — đối chiếu `package.json`, `tsconfig.json`, `environments/*`, `token.interceptor.ts`, `authen.guard.ts`, `routes-routing.module.ts`, `menu-code.ts`, `config-chart.*`.

## 1. Stack

| Mục | Giá trị (file thật) |
|---|---|
| Vai trò | Frontend EMR + dashboard / cấu hình biểu đồ |
| npm name | `front-end` (`package.json`) |
| Angular | **9.1.9** (`@angular/core` ~9.1.9) — NgModule, **không** standalone |
| TypeScript | ~3.8.3 |
| RxJS | ~6.5.4 |
| CLI / build | `@angular/cli` ^9.1.7, `@angular-devkit/build-angular` ~0.901.7 |
| UI | Angular Material 9, ng-bootstrap, ng-zorro-antd 9, Bootstrap 4, ng-matero |
| Chart **Cấu hình biểu đồ** | **ECharts** (`echarts` ^5.4.3) + **ngx-echarts** 6.0.1 (directive `echarts`) — `config-chart.module.ts` import `NgxEchartsModule` |
| Chart khác (repo) | `chart.js` 2.9.4 + `ng2-charts`; `highcharts` 8.2.2 |
| Auth FE | `angular-oauth2-oidc` 9; login HTTP `emr_resource` `signin_v2` |
| Layout dashboard | `angular-gridster2` ^9.3.4 |
| i18n | `@ngx-translate` + `src/assets/i18n/vi-VN.json` |
| Default project | `front-end` (`angular.json`), prefix `app`, style `scss` |

**Serve local:** `npm start` và `start:local` → `ng serve -o --host localhost --port 4200 --configuration=local` (+ `--openssl-legacy-provider`, `max_old_space_size=8000`).  
`angular.json` → `build.configurations.local` / `serve.configurations.local` → `fileReplacements`: `environment.ts` → `environment.local.ts`.

Hash routing: `environment.useHash: true` → `/#/...`.

**Node:** không có `engines` trong `package.json`. Angular 9 + OpenSSL legacy → thường dùng Node có `--openssl-legacy-provider`.

## 2. Path alias (`tsconfig.json`, `baseUrl`: `src/`)

| Alias | Trỏ tới |
|---|---|
| `@app/*` | `app/*` |
| `@core`, `@core/*` | `app/core` / `app/core/*` |
| `@shared`, `@shared/*` | `app/shared` / `app/shared/*` |
| `@theme`, `@theme/*` | `app/theme` / `app/theme/*` |
| `@env`, `@env/*` | `environments` / `environments/*` |
| `@testing`, `@testing/*` | `testing` / `testing/*` |

Khi đã có alias: không dùng `../../../`.

## 3. Cây thư mục chính

```
emr_web/src/
├── main.ts
├── app/
│   ├── app.module.ts
│   ├── core/            # guard, bootstrap, const (menu/action), interceptors
│   ├── routes/          # lazy feature NgModule
│   │   ├── config-chart/
│   │   ├── dashboard-config/
│   │   ├── dashboard-alarm-config/
│   │   └── sessions/
│   ├── shared/          # services API, directives
│   └── theme/           # layout, sidemenu
├── assets/i18n/vi-VN.json
└── environments/environment.ts | environment.local.ts | …
```

## 4. Bootstrap / routing

1. `main.ts` → `AppModule`.
2. `APP_INITIALIZER`: Translate → `UserInfoService` → `StartupService.load()` (`app.module.ts`).
3. `HTTP_INTERCEPTORS`: `TokenInterceptor`.
4. `StartupService`: có token → `getLoginUserInfo` → menu/action — **không** bỏ login khi `bypassMode` (comment trong `startup.service.ts`).
5. Layout `AdminLayoutComponent`: `canActivate` / `canActivateChild`: `AuthenGuard`, `MaintenanceGuard`.
6. Default: `''` → `trang-chu`. Wildcard → `trang-chu`.
7. Lazy `loadChildren` trong `routes-routing.module.ts`.

| Path | Module | data.menuCode (constant → giá trị) |
|---|---|---|
| `/#/trang-chu` | `DashboardAlarmConfigModule` | (không set menuCode trên route này) |
| `/#/thiet-lap/cau-hinh-bieu-do` | `ConfigChartModule` | `configurationChartMenuCode.configurationChart` → **CN98.1**; `actionsView` = `configChartAction[0]` |
| `/#/thiet-lap/cau-hinh-dashboard` | `DashboardModule` | `configurationMenuCode.configurationDashboard` → **CN9.15**; `actionsView` = `configDashboardAction[0]` |
| `/#/sessions/login` | `SessionsModule` | public |

**Lệch mã menu dashboard:**

| Chỗ | Constant | Giá trị |
|---|---|---|
| `routes-routing.module.ts` | `configurationMenuCode.configurationDashboard` | **CN9.15** |
| `menu-tree.ts` | `configurationDashboardMenuCode.configurationDashboard` | **CN99.1** |

Trong cùng `configurationMenuCode`: `complaintManagement` và `configurationDashboard` cùng **CN9.15**; `elasticsearchQuery` và `configurationChart` cùng **CN9.14** — nhưng route chart **không** dùng `configurationMenuCode.configurationChart`, mà dùng `configurationChartMenuCode` (**CN98.1**). Giữ tương thích DB, không xóa.

## 5. Environment (local)

| Key | `environment.ts` | `environment.local.ts` (serve `--configuration=local`) |
|---|---|---|
| `serverUrl.api_alarm` | `http://localhost:8087` (hardcode) | `window['env']['API_ALARM'] \|\| 'http://localhost:8087'` |
| `serverUrl.api_resource` | `http://localhost:9005/` | `window['env']['API'] \|\| 'http://localhost:9005/'` |
| `serverUrl.api` | `http://localhost:9005/` | `window['env']['API'] \|\| 'http://localhost:9005/'` |
| `API_URL_SERVICE.api_alarm` | `/alarm` | `/alarm` |
| `envName` | `local` | `local` |
| `bypassMode` / `bypassAction` | **true** | **true** |

Ý nghĩa bypass: bỏ check menu/action UI (`MenuGuard` / `ActionGuard` / `ActionService`); **không** bỏ login / `AuthenGuard`.

`TokenInterceptor` (`token.interceptor.ts`): `skipBearerForAlarm = bypassMode && url.startsWith(api_alarm)` → **chỉ** bỏ header Bearer cho request tới `api_alarm` khi `bypassMode`; resource/Keycloak vẫn gắn Bearer nếu có token.

## 6. Guard

| Guard | File | Hành vi |
|---|---|---|
| `AuthenGuard` | `core/guards/authen.guard.ts` | Kiểm tra pwd updated + token hết hạn → `/sessions/login`. **Không** đọc `bypassMode`. Exception path: `survey` / `sskdt` |
| `MenuGuard` | `menu.guard.ts` | `bypassMode` → true; else `menuCode` + `isActive` |
| `ActionGuard` | `action.guard.ts` | `bypassMode` → true; else `actionsView` |
| `ActionService.hasPermission` | `action.service.ts` | `environment.bypassAction` hoặc `this.bypass` (admin) → luôn true — **không** đọc `bypassMode` trong `hasPermission` |

## 7. File cấu hình hay đụng

| File | Việc |
|---|---|
| `routes/routes-routing.module.ts` | path, menuCode, actionsView |
| `core/const/menu-code.ts` | `configurationChartMenuCode` CN98.1; `configurationDashboardMenuCode` CN99.1; `configurationMenuCode.configurationDashboard` CN9.15 |
| `core/const/action-code.ts` | `configChartAction` / `configDashboardAction` |
| `core/const/menu-tree.ts` | cây menu FE |
| `environments/environment.ts` / `environment.local.ts` | `api_alarm`, bypass |
| `assets/i18n/vi-VN.json` | `configChart.label.title` |
| `shared/services/config-chart.service.ts` | HTTP chart |
| `shared/services/dashboard.service.ts` | HTTP screen |

## 8. Quy ước đặt tên

- Folder: kebab-case (`config-chart`, `cau-hinh-bieu-do`).
- Module: `*Module`; routing `*-routing.module.ts` hoặc `*.routing.module.ts`.
- Selector: `app-` + kebab. Class: PascalCase + `Component`.
- Menu: `CN<số>.<số>`. Action: `ACT_*_VIEW|ADD|EDIT|DELETE`; **`[0]` = VIEW**.
- Add/Edit: cùng component, `new` vs `:id/edit`.
- Comment: `// ADD:` / `// UPDATE:`.
- Angular 9: `*ngIf` / `*ngFor`, ReactiveForms; không standalone / `@if`.
