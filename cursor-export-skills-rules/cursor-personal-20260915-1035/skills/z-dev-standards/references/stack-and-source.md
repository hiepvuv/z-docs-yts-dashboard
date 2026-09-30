# Nhận diện source + ngôn ngữ + framework + ngữ cảnh

**Bắt buộc** với mọi skill `z-*` trước khi sửa/ghi docs: chạy protocol dưới đây (hoặc tái dùng kết quả đã có trong phiên nếu cùng source).

Ghi **version từ file thật** — không đoán.

---

## 0. Protocol (thứ tự cố định)

```
1. Locate source(s)
2. Detect language(s)   ← primary + secondary nếu monorepo trong 1 folder
3. Detect framework / runtime role
4. Detect context       ← z_docs, convention, entrypoints
5. Chọn playbook + tên file 01b
6. Nêu ngắn trong reply: source | lang | framework | role | z_docs path
```

Nếu nhiều source: lặp từng source; **không** áp playbook của source A lên source B.

---

## 1. Source

**Source** = thư mục có ≥1 marker độc lập (hoặc git root chứa đúng 1 app).

### Marker nhận diện (có mặt = ứng viên source)

| Loại | Marker |
|---|---|
| Node/JS | `package.json` |
| Java | `pom.xml`, `build.gradle`, `build.gradle.kts`, `settings.gradle*` |
| .NET | `*.csproj`, `*.sln`, `global.json` |
| Go | `go.mod` |
| Rust | `Cargo.toml` |
| Python | `pyproject.toml`, `requirements.txt`, `Pipfile`, `setup.py` |
| PHP | `composer.json` |
| Ruby | `Gemfile` |
| Dart/Flutter | `pubspec.yaml` |
| Swift | `Package.swift`, `*.xcodeproj` |
| Kotlin MP | `settings.gradle.kts` + `*.kt` (không phải thuần Android Gradle đơn giản thì ghi rõ) |
| Frontend meta | `angular.json`, `next.config.*`, `nuxt.config.*`, `vite.config.*`, `svelte.config.*`, `astro.config.*` |
| Elixir | `mix.exs` |

**Không tính source:** `z_docs`, `node_modules`, `.git`, `dist`, `build`, `target`, `vendor`, `.cursor`, `.agents`, `.venv`, `__pycache__`, `coverage`.

`<ten_source>`: slug folder `[a-z0-9_-]`, không dấu.

| | `z_docs` |
|---|---|
| Một source | `01a`…`02` thẳng `z_docs/` |
| Nhiều source | Nội dung `z_docs/<ten_source>/`; gốc chỉ mục lục + link |

**Chọn source đang làm:** path file user/@ đang mở ⊃ source root; không rõ → liệt kê candidate, hỏi 1 câu.

---

## 2. Language (sau khi có source root)

Ưu tiên manifest; phụ: đuôi file chiếm đa số trong `src/` (bỏ `node_modules`/vendor).

| Tín hiệu | Language |
|---|---|
| `*.csproj` / `*.fsproj` | C# / F# |
| `pom.xml` / Gradle + `*.java` | Java |
| Gradle + chủ yếu `*.kt` | Kotlin |
| `go.mod` | Go |
| `Cargo.toml` | Rust |
| `pubspec.yaml` | Dart |
| `composer.json` | PHP |
| `Gemfile` | Ruby |
| `mix.exs` | Elixir |
| `pyproject.toml` / `requirements.txt` + `*.py` | Python |
| `Package.swift` / `*.swift` | Swift |
| `package.json` + `*.ts`/`*.tsx` chiếm ưu | TypeScript |
| `package.json` + chủ yếu `*.js`/`*.jsx` | JavaScript |
| Mixed (vd Java + Thymeleaf + JS) | **primary** = runtime chính; ghi secondary |

Luôn ghi version toolchain nếu có: `.java-version`, `.nvmrc`, `.node-version`, `.python-version`, `engines` trong `package.json`, `go` directive, `rust-version`, JDK trong CI/Docker.

---

## 3. Framework / role (lấy khớp trước trong nhóm language)

### TypeScript / JavaScript

1. `angular.json` → **Angular** (`@angular/core`). `<14`/NgModule → convention A9; `≥14`+standalone → ghi rõ.
2. `next.config.*` / dep `next` → **Next.js** (App / Pages / cả hai).
3. `nuxt.config.*` / dep `nuxt` → **Nuxt** (Vue).
4. dep `vue` (không Nuxt) → **Vue** 2|3.
5. `svelte.config.*` / dep `svelte` → **Svelte** (/Kit nếu `@sveltejs/kit`).
6. `astro.config.*` / dep `astro` → **Astro**.
7. dep `react` + không Next → **React** (CRA/Vite/Remix: đọc script + `remix.config` / `@remix-run`).
8. dep `@nestjs/core` → **NestJS**.
9. dep `express` / `fastify` / `hono` / `koa` → **Node HTTP** (tên framework thật).
10. Còn lại → **Node generic**.

### Java / Kotlin

1. dep/`import` Spring Boot / `spring-boot` plugin → **Spring Boot**.
2. CAS overlay / `apereo` → **CAS/Spring** overlay.
3. `quarkus` / `micronaut` → framework tương ứng.
4. Android `com.android.application` → **Android**.
5. Còn lại → **Java/Kotlin JVM generic**.

### Python

1. `fastapi` → FastAPI. 2. `django` → Django. 3. `flask` → Flask. 4. `pytorch`/`tensorflow` (app ML) ghi rõ. 5. Còn lại → Python generic.

### .NET

`Microsoft.AspNetCore.*` → ASP.NET Core; WPF/MAUI/Worker → ghi loại project.

### Go / Rust / PHP / Ruby / Dart / Elixir

Go: `gin`/`echo`/`fiber`/`chi` hoặc std `net/http`.  
Rust: `actix`/`axum`/`rocket`.  
PHP: `laravel/framework` / `symfony` / WordPress.  
Ruby: Rails / Sinatra.  
Dart: `flutter` trong pubspec → Flutter; không thì Dart.  
Elixir: Phoenix nếu có.

### Role

`fe` | `be` | `fullstack` | `mobile` | `lib` | `cli` — suy từ entry + dependency (UI router vs HTTP server vs SDK).

---

## 4. Context (ngữ cảnh theo source)

Đọc lần lượt (có gì dùng nấy):

1. `z_docs/<ten>/01a_Structure.md` + `02_Upsert_Feature.md` (hoặc gốc nếu 1 source)
2. File config hay đụng: `application*.yml`, `.env.example`, `environment*.ts`, `settings.py`, `appsettings.json`
3. Entrypoint: `main.ts`, `main.py`, `Program.cs`, `*Application.java`, `cmd/*/main.go`, `app/layout.tsx`
4. Màn/module **tương tự** gần nhất (pattern đặt tên, folder)
5. Test runner & lint scripts trong manifest

**Ngữ cảnh =** stack + role + convention đã thấy + path docs. Mọi thay đổi phải bám ngữ cảnh đó.

---

## 5. Chọn file 01b

| Điều kiện | File 01b |
|---|---|
| BE/lib có schema/entity/migration/ORM | `01b_DBschema.md` |
| Next / React / Astro / Svelte (UI routes) | `01b_Pages_Components.md` |
| Vue / Nuxt | `01b_Views_Stores.md` |
| Angular | `01b_Modules_Components.md` |
| Flutter / mobile screens | `01b_Screens_Widgets.md` |
| Go/Rust/Python/Java package-heavy không UI | `01b_Packages_Modules.md` (nếu không có DB); có DB → `01b_DBschema.md` ưu tiên |
| Không khớp | `01b_Packages_Modules.md` + ghi rõ lý do trong 01a |

Một source **một** 01b chính; có cả UI + DB trong cùng source fullstack → chọn theo **phần chiếm docs quan trọng hơn**, ghi link chéo phần còn lại trong 01a (không bịa schema nếu chỉ là FE gọi API ngoài).

---

## 6. Output nhận diện (bắt buộc, ngắn)

```
Source: <path> (<ten_source>)
Language: <lang> <version?>
Framework: <fw> <version?>
Role: <fe|be|...>
Docs: z_docs/... 
Playbook: <tên trong stack-playbooks.md>
```

Không khớp playbook chi tiết → dùng **Generic** trong playbooks + bám file mẫu trong repo.
