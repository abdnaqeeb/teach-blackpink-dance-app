### Stack: Java (Spring Boot)
- Java 21, Spring Boot 3, Spring Web, Spring Data JPA, Flyway, Postgres, Bean Validation
- Quality: Spotless (google-java-format), Checkstyle, Error Prone + NullAway; compiler `-Werror`
- Tests: JUnit 5, Spring Boot Test + Testcontainers (integration), Playwright for Java in an `e2eTest` source set
- Auth: Spring Security as an OAuth2 resource server against a managed provider · Errors: Sentry · Logs: Logback JSON
- Dependency manifest: `build.gradle.kts`, `gradle/libs.versions.toml`, `gradle.lockfile` · Dependabot ecosystem: `gradle`

### Folder layout
```
src/main/java/<pkg>/
  api/              controllers (thin): @Valid DTO → auth → authz → service
  <feature>/        service, repository, entity, DTOs
  security/         SecurityConfig, CurrentUser, PermissionEvaluator (authz)
  config/           @ConfigurationProperties (the config module)
src/main/resources/db/migration/   Flyway SQL
src/test/java/      unit + integration
src/e2eTest/java/   Playwright e2e
```

### Generic rule → this stack
| Generic rule | Here |
|---|---|
| Config module | `@ConfigurationProperties` + `@Validated`; secrets from env / secret store only |
| Server boundary | controllers never return entities; map to response DTOs |
| Input validation | `@Valid` request DTOs with Bean Validation constraints |
| Auth helpers | `SecurityFilterChain` denies by default; `anyRequest().authenticated()` |
| Authorization | `@PreAuthorize("hasPermission(#id, 'Project', 'delete')")` via a custom `PermissionEvaluator` |
| Escape hatches to justify | `@SuppressWarnings`, native queries with string concat, `permitAll()` |
