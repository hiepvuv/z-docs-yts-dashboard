# Playbook theo stack (đọc on-demand)

Dùng sau khi [stack-and-source.md](stack-and-source.md) đã chọn framework. Chỉ đọc mục khớp + mục Generic.

---

## Generic (mọi ngôn ngữ)

**Quét 01a:** toolchain version, tree chính, bootstrap/entry, config, đặt tên, cách chạy dev/test/build (script thật).

**01c:** module/tính năng có thể trace. **01d:** route/handler/API client thật — method + path + chỗ định nghĩa/gọi.

**02 upsert:** liệt kê lớp đăng ký của repo (router, DI, manifest permission, i18n, migration…) bằng cách **copy checklist từ màn/module mẫu**, không bịa layer.

**Fix gợi ý chung:** off-by-one config env; sai base URL; race; null/empty; nhầm môi trường; test không chạy cùng điều kiện prod.

**Chuẩn code:** không đổi style Options↔Composition, sync↔async architectural, hay framework major trừ khi user yêu cầu.

---

## Angular

**Quét:** `angular.json`, `@angular/core`, alias `tsconfig`, `app.module` / `bootstrapApplication`, lazy `loadChildren`, `environment*.ts`, `menu-code`/`action-code`, `prefix-api`, i18n.

**01b:** NgModule/route/list/form/service/pipe.

**02:** menu+action (`[0]=VIEW`), prefix-api+service, feature module+routing, lazy, i18n. Add/Edit: `queryParams.id` hoặc dialog. Không tạo menu DB trên FE; không xoá mã DB đang dùng.

**Fix:** thiếu import module; guard/menuCode; subscribe leak; `ExpressionChanged…`; sai environment host; `*ngIf` vs reactive form.

**Standards:** A9: không standalone/`inject()`/`@if`. Form theo repo.

---

## Next.js

**Quét:** `next`, `next.config.*`, App vs Pages, middleware, auth, data lib.

**01b:** route/layout/component/hook/middleware. Không schema BE trừ Prisma/Drizzle trong source.

**02:** `app/.../page.tsx` hoặc `pages/...`; list+form `?id=`/`[id]`; server fetch/action/`route.ts`; `'use client'` chỉ khi cần.

**Fix:** hydration; RSC hooks; `params`/`searchParams` async; cache/revalidate; middleware matcher.

**Standards:** không trộn App/Pages; `NEXT_PUBLIC_*` chỉ biến client thật.

---

## Vue / Nuxt

**Quét:** vue 2|3, Nuxt/Vite/CLI, router, pinia/vuex, axios wrapper, i18n.

**01b:** SFC, store, composable.

**02:** view + route meta + api module; store chỉ khi mẫu dùng; Add/Edit theo `query.id`/props/dialog.

**Fix:** reactivity/destructure; mutate props; key `v-for`; guard vs data; Vue2 `$set`; `v-model` custom.

**Standards:** không tự nâng Composition nếu repo Options.

---

## React (không Next) / Remix / Vite-React

**Quét:** bundler, router (`react-router`), data (RQ/SWR), entry `main.tsx`.

**01b:** `01b_Pages_Components.md`.

**02:** route + page/component + API module theo mẫu; form controlled theo repo.

**Fix:** stale closure; key list; loader/action Remix; StrictMode double-fetch.

---

## Svelte / SvelteKit / Astro

**Quét:** `svelte.config` / `astro.config`, file routes.

**01b:** `01b_Pages_Components.md`.

**02:** route file + component; load function theo mẫu Kit/Astro.

**Fix:** store reactivity; `onMount` vs SSR; island hydration (Astro).

---

## NestJS / Express / Fastify / Hono

**Quét:** `main.ts`, module/controller hoặc router files, ORM (Prisma/TypeORM).

**01b:** DB → `01b_DBschema.md`; không DB → `01b_Packages_Modules.md`.

**02:** module/controller/route + DTO/validation + provider; đăng ký module root.

**Fix:** pipe/guard order; DTO whitelist; async error filter.

---

## Java / Spring (Boot, CAS overlay)

**Quét:** Gradle/Maven, `application*.yml`, overlay, JDK, context-path, Redis/DB.

**01b:** `@Entity`/`@Table`, SQL, migration.

**02:** module + AutoConfiguration nếu có; YAML pattern có sẵn; REST/webflow/Thymeleaf theo mẫu.

**Fix:** context-path; profile; bean overlay; filter order; transaction/session.

**Standards:** không bịa property; entity chỉ cột đã có trừ khi user xin schema mới.

---

## Python (FastAPI / Django / Flask)

**Quét:** `pyproject`/`requirements`, settings, urls/router, ORM (SQLAlchemy/Django ORM).

**01b:** models/migrations → `01b_DBschema.md`.

**02:** router/view + serializer/schema + service; đăng ký url/router.

**Fix:** settings env; migrations lệch; N+1; sync trong async; CSRF Django.

---

## ASP.NET Core

**Quét:** `*.csproj`, `Program.cs`/`Startup`, `appsettings*.json`, DI.

**01b:** EF DbContext → `01b_DBschema.md`.

**02:** controller/minimal API + DTO + DI registration; auth policy theo mẫu.

**Fix:** DI lifetime; middleware order; binding; migration.

---

## Go

**Quét:** `go.mod`, `cmd/`, router, migrate tool.

**01b:** struct/SQL → DBschema hoặc Packages_Modules.

**02:** handler + route register + wiring `main`/fx/wire.

**Fix:** context cancel; nil pointer; migrate; race `go test -race` nếu đang dùng.

---

## Rust

**Quét:** `Cargo.toml`, bin/lib, framework web nếu có.

**01b:** Packages_Modules hoặc DBschema (sqlx/diesel).

**02:** route + handler + module `mod`; feature flags theo crate.

**Fix:** lifetime/ownership lệch refactor; error propagation; blocking in async.

---

## PHP (Laravel / Symfony)

**Quét:** `composer.json`, routes, `.env.example`, Eloquent/Doctrine.

**01b:** DBschema từ migrations/models.

**02:** route + controller + form request + service; policy/permission nếu mẫu có.

**Fix:** env cache; mass assignment; route cache; N+1 Eloquent.

---

## Flutter / Dart

**Quét:** `pubspec.yaml`, `lib/main.dart`, routing.

**01b:** `01b_Screens_Widgets.md`.

**02:** screen/widget + route + state (Bloc/Riverpod/Provider **đúng cái repo**).

**Fix:** rebuild/setState; wrong BuildContext async; platform channel.

---

## Android (Kotlin/Java) / iOS (Swift)

**Quét:** Gradle/Xcode, manifest/plist, navigation graph.

**01b:** Screens_Widgets hoặc Packages_Modules.

**02:** screen + navigation + ViewModel/UseCase theo mẫu; permission manifest nếu cần.

**Fix:** lifecycle; main-thread; Proguard; capability/permission thiếu.
