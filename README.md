# Ingresso Challenge

App iOS que consome a API pública da Ingresso.com para exibir os próximos filmes em cartaz nos cinemas brasileiros.

---

## Como rodar o projeto

1. **Xcode 26** (beta ou superior)
2. Abra `Ingresso.xcworkspace` na raiz do projeto
3. Selecione o scheme `Ingresso` e o simulador desejado (iOS 26+)
4. `Cmd + R` para buildar e rodar
5. Para rodar os testes: `Cmd + U`

> Não há dependências externas. Tudo é resolvido via SPM local.

---

## Arquitetura

O projeto segue **Clean Architecture** com separação em módulos SPM multi-target dentro de `Packages/IngressoKit`:

```
IngressoApp (Composition Root)
│
├── IngressoUI          → Screens, Components, Design Tokens
├── IngressoPresentation → ViewModels, Router, States
├── IngressoData         → DTOs, Mappers, Repositories concretos
├── IngressoDomain       → Entidades, Use Cases, Protocols
├── IngressoInfrastructure → HTTP Client, Persistence, Network
└── IngressoMock         → Mocks e Fixtures para testes/previews
```

**Regra de dependência:** camadas externas dependem das internas. Domain e Infrastructure não possuem dependências internas.

---

## Decisões técnicas

### Por que Clean Architecture em módulos SPM?

- **Isolamento de responsabilidades** — cada módulo compila independentemente, forçando limites claros
- **Tempo de build** — alterações em UI não recompilam Domain/Infra
- **Testabilidade** — Domain define protocolos, Data/Infra implementam, testes usam mocks

### Por que zero dependências externas?

- O projeto usa apenas frameworks nativos da Apple (SwiftUI, SwiftData, WidgetKit, Network)
- Reduz superfície de ataque, simplifica manutenção e demonstra domínio dos frameworks

### Por que SwiftData ao invés de CoreData?

- API declarativa que combina com SwiftUI
- Menos boilerplate, integração nativa com `@Model`
- Usado para persistência de favoritos e cache offline

### Por que actor no HTTPClient?

- `IngressoHTTPClient` é um `actor` para garantir thread-safety sem locks manuais
- Retry com backoff exponencial configurável
- Erros tipados (`IngressoNetworkError`) com `isRetryable` para decisão automática de retry

---

## Design Patterns utilizados

| Pattern | Onde | Por quê |
|---------|------|---------|
| Repository | Domain → Data | Protocol no Domain, implementação concreta no Data |
| Use Case | Domain | Orquestra repositórios, cache e sorting |
| Strategy | Domain | `PremiereDateSortStrategy` para ordenação extensível |
| MVVM | Presentation | `@Observable` ViewModels com states tipados |
| Router | Presentation | Per-tab NavigationPath, sheet, fullScreenCover |
| Mapper/Adapter | Data | DTO → Domain, Entity ↔ Domain bidirecional |
| Factory | Presentation → App | `ViewModelFactoryProtocol` → `IngressoDependencyContainer` |
| Composition Root | App | `IngressoDependencyContainer` injeta todas dependências |

---

## Funcionalidades implementadas

### Requisitos do desafio
- [x] Tela de loading (shimmer skeleton)
- [x] Poster do filme (com fallback para filmes sem poster)
- [x] Nome do filme
- [x] Data de estreia
- [x] Ordenação por `premiereDate` (Strategy pattern)
- [x] Arquitetura organizada (Clean Architecture, SPM multi-target)

### Funcionalidades extras
- [x] **Busca** — filtro por título, diretor e gênero com cards de categorias
- [x] **Pull to refresh** — atualiza lista de filmes
- [x] **Tela de detalhes** — banner, classificação indicativa, gêneros (FlowLayout), trailers
- [x] **Favoritar filme** — persistência com SwiftData, toggle instantâneo
- [x] **Pré-venda** — tela dedicada com cards destacados e badge
- [x] **Widget** — WidgetKit com 3 tamanhos (small, medium, large)
- [x] **Cache offline** — SwiftData com fallback automático quando sem internet
- [x] **Error handling** — StatusBanner de conectividade, retry com backoff exponencial
- [x] **Tela Sobre** — roteiro técnico do desenvolvimento e gerenciamento de cache

---

## Testes

Framework: **Swift Testing**

| Suite | Testes | Cobertura |
|-------|--------|-----------|
| IngressoDataTests | 5 | MovieMapper, RemoteMovieRepository |
| IngressoInfrastructureTests | 5 | NetworkError, Endpoint, HTTPClient |
| IngressoPresentationTests | 5 | MovieListViewModel, FavoritesViewModel |

Rode com `Cmd + U` no scheme principal.

---

## Estrutura de pastas

```
ingresso-challenge/
├── Ingresso.xcworkspace
├── .swiftlint.yml
├── Projects/
│   └── Ingresso/
│       ├── Ingresso/          → App target (ContentView, DI Container)
│       └── IngressoWidget/    → Widget Extension
└── Packages/
    └── IngressoKit/
        ├── Package.swift
        ├── Sources/
        │   ├── IngressoDomain/
        │   ├── IngressoInfrastructure/
        │   ├── IngressoData/
        │   ├── IngressoPresentation/
        │   ├── IngressoUI/
        │   └── IngressoMock/
        └── Tests/
            ├── IngressoDataTests/
            ├── IngressoInfrastructureTests/
            └── IngressoPresentationTests/
```

---

## Stack

| Item | Tecnologia |
|------|-----------|
| Linguagem | Swift 6.3 |
| IDE | Xcode 26 |
| Plataforma | iOS 26+ |
| UI | SwiftUI |
| Persistência | SwiftData |
| Testes | Swift Testing |
| Pacotes | SPM multi-target |
| Widget | WidgetKit |
| Lint | SwiftLint |
| Concurrency | Swift 6 strict concurrency |

---

## Segurança

- Nenhuma credencial ou token armazenado no código — a API é pública
- Todas as URLs são construídas via `URLComponents` (prevenção de injection)
- `HTTPClient` é `actor` — sem race conditions
- Cache e favoritos são dados locais via SwiftData, sem exposição externa

---

## Git Flow

O desenvolvimento seguiu feature branches com merge para `develop`:

1. `feature/estrutura-projeto` — Workspace, SPM multi-target
2. `feature/infraestrutura` — HTTPClient (actor), Endpoint, Persistence
3. `feature/dominio` — Entidades, protocolos, use cases
4. `feature/camada-dados` — DTOs, Mappers, Repositories
5. `feature/apresentacao` — ViewModels, Router, States
6. `feature/ui` — Screens, components, mocks
7. `feature/widget` — WidgetKit extension

---

## API

**GET** [https://api-content.ingresso.com/v0/events/coming-soon/partnership/desafio](https://api-content.ingresso.com/v0/events/coming-soon/partnership/desafio)
