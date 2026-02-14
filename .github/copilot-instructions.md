# Project Guidelines — Controla Fácil

Sistema de controle financeiro pessoal em Rails 7.1 + Ruby 3.3, MySQL, Sidekiq, Hotwire (Turbo + Stimulus), Tailwind CSS + DaisyUI.

## Code Style

- Linguagem do código e UI: **português brasileiro** (flash messages, labels, descrições)
- Strings com aspas simples (`'texto'`), exceto quando há interpolação
- Ruby shorthand hash syntax: `user:`, `balance:` (não `user: user`)
- Sem Rubocop — seguir convenções existentes nos controllers e models
- Formatação de moeda: `R$`, separador decimal vírgula, delimitador de milhar ponto — ver `ApplicationHelper`

## Architecture

- **MVC clássico** com **Service Objects** em `app/services/` (padrão `.call` via `ApplicationService`)
- **Autenticação**: `revise_auth` (~0.7.1) + OAuth Google via `omniauth`. Helpers: `current_user`, `user_signed_in?`, `authenticate_user!`
- **Background Jobs**: Sidekiq direto (`include Sidekiq::Job`) em `app/sidekiq/` — **não** usa `app/jobs/` nem `ActiveJob` para jobs agendados
- **Agendamento**: `sidekiq-scheduler` configurado em `config/sidekiq.yml`
- **Frontend**: Importmap (sem bundler JS), Stimulus controllers em `app/javascript/controllers/`, Turbo Frames para modais e CRUD inline
- **DaisyUI**: carregado via CDN no layout, não via plugin Tailwind
- **PWA**: service worker + manifest em `app/views/pwa/`
- **Storage**: Active Storage com Cloudflare R2 (S3-compatible) em produção
- **Paginação**: `pagy` (usa `pagy_countless`) — incluso via `Pagy::Backend` no `ApplicationController`
- **Busca/filtro**: `ransack`

### Fluxo de dados importante

- `ApplicationController#before_action :create_monthly_balance_if_needed` gera balanço mensal automaticamente em toda request autenticada via `MonthlyBalanceService`
- `MonthlyBalanceService` copia despesas/receitas fixas (`fixed: true`) do mês anterior ao criar um novo balanço
- Concerns `SetBalance` e `UpdateBalanceValue` nos models `Expense`/`Income` gerenciam automaticamente a associação com `Balance` e recalculam o saldo

## Build and Test

```bash
# Setup
bin/setup                        # Instala dependências e prepara o banco
bin/rails db:prepare             # Cria/migra o banco

# Dev server (Rails + Tailwind watch + Sidekiq)
bin/dev                          # Usa foreman com Procfile.dev

# Assets
bin/rails tailwindcss:build      # Compila Tailwind CSS

# Console
bin/rails console                # IRB com Rails carregado

# Docker (produção)
docker build -t controla-facil .
```

Testes estão praticamente ausentes — `test/` está vazio. Não há RSpec.

## Project Conventions

- **Jobs Sidekiq** ficam em `app/sidekiq/`, usam `include Sidekiq::Job` com `sidekiq_options retry: 0`. Usar `find_each` (não `User.all.each`) e `joins(:association)` para evitar N+1
- **Services** herdam de `ApplicationService` e expõem `.call` como class method — ver `app/services/web_push_service.rb`
- **Controller concern** `BalanceHelper` (em `app/controllers/concerns/`) carrega `@balance` do mês/ano atual — incluído nos controllers que precisam
- **Flash messages** usam chave `:style` com valores `'success'` ou `'error'` para estilização via DaisyUI alerts
- **Categories** usam MySQL ENUM `cat_sub` (`'expenses'` | `'incomes'`), com scope `user_global` para carregar categorias do usuário + globais (`user_id: nil`)
- **Responsive**: tabelas separadas via partials `_desktop_table` e `_mobile_table`
- Emails em produção usam SMTP Gmail. Jobs de email devem usar `deliver_later` (não `deliver_now`)

## Integration Points

- **MySQL 8+** (charset `utf8mb4`) — env vars: `DB_PASSWORD`, `DATABASE_URL`
- **Redis** para Sidekiq e Action Cable — env vars: `REDIS_SERVER_URL/PASSWORD`, `REDIS_CLIENT_URL/PASSWORD`
- **Google OAuth** — env vars: `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`
- **Web Push (VAPID)** — env vars: `VAPID_PUBLIC_KEY`, `VAPID_PRIVATE_KEY`
- **Cloudflare R2** — env vars: `R2_BUCKET`, `R2_ENDPOINT`, `R2_ACCESS_KEY_ID`, `R2_SECRET_ACCESS_KEY`
- **SMTP** — env vars: `MAIL_USER`, `MAIL_PASSWORD`, `HOST`
- **Deploy**: CapRover via `captain-definition` → Dockerfile multi-stage → `foreman start` (web + worker)

## Security

- `config.force_ssl = true` em produção
- Credenciais sensíveis via `dotenv-rails` (dev) e env vars (produção)
- `Rails.application.credentials` para master key
- OAuth users recebem password_digest randômico (`BCrypt::Password.create(SecureRandom.hex(10))`) em `ProvidersController`
- `push_subscriptions` protegidas por `authenticate_user!`
