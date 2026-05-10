import SwiftUI
import IngressoPresentation

public struct SettingsScreen: View {
    let viewModel: SettingsViewModel

    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        List {
            aboutSection
            architectureSection
            layersSection
            patternsSection
            featuresSection
            qualitySection
            storageSection
            stackSection
            phasesSection
        }
        .navigationTitle("Sobre")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        .onAppear { viewModel.loadCacheSize() }
    }

    // MARK: - About

    private var aboutSection: some View {
        Section {
            VStack(spacing: IngressoSpacing.md) {
                Image(systemName: "movieclapper.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.tint)

                VStack(spacing: IngressoSpacing.xs) {
                    Text("Ingresso Challenge")
                        .font(.title2.bold())
                    Text("App iOS que consome a API pública da Ingresso.com para exibir os próximos filmes em cartaz nos cinemas brasileiros.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, IngressoSpacing.lg)
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        }
    }

    // MARK: - Architecture

    private var architectureSection: some View {
        Section {
            architectureRow(layer: "IngressoApp", desc: "Composition Root, DI Container", icon: "app.fill")
            architectureRow(layer: "IngressoUI", desc: "Screens, Components, Design Tokens", icon: "paintbrush.fill")
            architectureRow(layer: "Presentation", desc: "ViewModels, Router, States", icon: "rectangle.3.group.fill")
            architectureRow(layer: "Data", desc: "DTOs, Mappers, Repositories concretos", icon: "externaldrive.fill")
            architectureRow(layer: "Domain", desc: "Entidades, Use Cases, Protocols", icon: "cube.fill")
            architectureRow(layer: "Infrastructure", desc: "HTTP Client, Persistence, Network", icon: "network")
            architectureRow(layer: "Mock", desc: "Mocks e Fixtures para testes", icon: "testtube.2")
        } header: {
            Label("Clean Architecture", systemImage: "building.columns.fill")
        } footer: {
            Text("7 módulos SPM. Regra de dependência: camadas externas dependem das internas. Domain e Infrastructure não dependem de nada interno.")
        }
    }

    private func architectureRow(layer: String, desc: String, icon: String) -> some View {
        HStack(spacing: IngressoSpacing.md) {
            Image(systemName: icon)
                .foregroundStyle(.tint)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(layer)
                    .font(.subheadline.bold())
                Text(desc)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, IngressoSpacing.xxs)
    }

    // MARK: - Layers Detail

    private var layersSection: some View {
        Section {
            layerDetail(
                name: "Domain",
                items: ["IngressoMovie", "IngressoPremiereDate", "IngressoContentRating",
                        "IngressoTrailer", "FetchMoviesUseCase", "SearchMoviesUseCase",
                        "PremiereDateSortStrategy", "MovieRepositoryProtocol",
                        "MovieCacheRepositoryProtocol", "FavoritesRepositoryProtocol"]
            )
            layerDetail(
                name: "Infrastructure",
                items: ["IngressoHTTPClient (actor)", "HTTPClientProtocol",
                        "IngressoEndpoint", "IngressoNetworkError",
                        "NetworkMonitor (NWPathMonitor)",
                        "FavoriteMovieEntity", "CachedMovieEntity", "MovieEntityProtocol"]
            )
            layerDetail(
                name: "Data",
                items: ["MovieDTO", "MovieResponseDTO", "PremiereDateDTO",
                        "TrailerDTO", "ImageDTO", "RatingDetailsDTO",
                        "MovieMapper", "FavoriteMovieMapper", "CachedMovieMapper",
                        "RemoteMovieRepository", "SwiftDataFavoritesRepository",
                        "SwiftDataMovieCacheRepository"]
            )
            layerDetail(
                name: "Presentation",
                items: ["MovieListViewModel", "MovieDetailViewModel",
                        "FavoritesViewModel", "SettingsViewModel",
                        "IngressoRouter", "IngressoRoute", "IngressoTab",
                        "IngressoViewState", "GenreSection", "ViewModelFactoryProtocol"]
            )
            layerDetail(
                name: "UI",
                items: ["MovieListScreen", "MovieDetailScreen", "PreSaleScreen",
                        "SearchScreen", "FavoritesScreen", "SettingsScreen",
                        "HeroBanner", "MoviePosterCard", "MovieSection",
                        "StatusBanner", "FlowLayout", "IngressoAsyncImage",
                        "ShimmerModifier", "PressableModifier", "IngressoNavigationModifier",
                        "IngressoColors", "IngressoSpacing"]
            )
            layerDetail(
                name: "Mock",
                items: ["MockMovieRepository", "MockMovieCacheRepository",
                        "MockFavoritesRepository", "MockHTTPClient",
                        "MockFetchMoviesUseCase", "MockSearchMoviesUseCase",
                        "IngressoFixtures"]
            )
        } header: {
            Label("Camadas em Detalhe", systemImage: "square.stack.3d.up.fill")
        }
    }

    private func layerDetail(name: String, items: [String]) -> some View {
        DisclosureGroup {
            FlowLayout(spacing: IngressoSpacing.sm) {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.caption2)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.ultraThinMaterial, in: Capsule())
                }
            }
        } label: {
            Text(name)
                .font(.subheadline.bold())
        }
    }

    // MARK: - Design Patterns

    private var patternsSection: some View {
        Section {
            patternRow(name: "Repository", where: "Domain → Data", detail: "Protocol no Domain, implementação concreta no Data")
            patternRow(name: "Use Case", where: "Domain", detail: "Orquestra repositórios, cache e sorting")
            patternRow(name: "Strategy", where: "Domain", detail: "PremiereDateSortStrategy para ordenação extensível")
            patternRow(name: "MVVM", where: "Presentation", detail: "@Observable ViewModels com states tipados")
            patternRow(name: "Router", where: "Presentation", detail: "Per-tab NavigationPath, sheet, fullScreenCover")
            patternRow(name: "Mapper/Adapter", where: "Data", detail: "DTO → Domain, Entity ↔ Domain bidirecional")
            patternRow(name: "Factory", where: "Presentation → App", detail: "ViewModelFactoryProtocol → DependencyContainer")
            patternRow(name: "Composition Root", where: "App", detail: "IngressoDependencyContainer injeta tudo")
        } header: {
            Label("Design Patterns", systemImage: "puzzlepiece.fill")
        }
    }

    private func patternRow(name: String, where layer: String, detail: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: IngressoSpacing.xxs) {
                Text(name)
                    .font(.subheadline.bold())
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(layer)
                .font(.caption2.bold())
                .foregroundStyle(.tint)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(.tint.opacity(0.1), in: Capsule())
        }
        .padding(.vertical, IngressoSpacing.xxs)
    }

    // MARK: - Features

    private var featuresSection: some View {
        Section {
            featureRow(icon: "film", title: "Estreias", desc: "Hero banner, seções por gênero, shimmer loading, pull-to-refresh")
            featureRow(icon: "ticket.fill", title: "Pré-venda", desc: "Cards com banner, gradient overlay, badge de destaque")
            featureRow(icon: "magnifyingglass", title: "Busca", desc: "Cards de categorias, filtro por título, diretor e gênero")
            featureRow(icon: "heart.fill", title: "Favoritos", desc: "Grid de posters, persistência SwiftData, toggle instantâneo")
            featureRow(icon: "square.text.square", title: "Detalhe", desc: "Banner, badges de classificação, FlowLayout de gêneros, trailers")
            featureRow(icon: "widget.small", title: "Widget", desc: "3 tamanhos (small, medium, large), imagens pré-carregadas")
            featureRow(icon: "wifi.slash", title: "Offline", desc: "Cache SwiftData com fallback automático, StatusBanner de conectividade")
            featureRow(icon: "arrow.clockwise", title: "Retry", desc: "Backoff exponencial no HTTPClient, erros tipados com isRetryable")
        } header: {
            Label("Funcionalidades", systemImage: "star.fill")
        }
    }

    private func featureRow(icon: String, title: String, desc: String) -> some View {
        HStack(spacing: IngressoSpacing.md) {
            Image(systemName: icon)
                .foregroundStyle(.tint)
                .frame(width: 20, alignment: .center)

            VStack(alignment: .leading, spacing: IngressoSpacing.xxs) {
                Text(title)
                    .font(.subheadline.bold())
                Text(desc)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, IngressoSpacing.xxs)
    }

    // MARK: - Quality

    private var qualitySection: some View {
        Section {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: IngressoSpacing.sm) {
                qualityCard(icon: "checkmark.circle.fill", title: "Testes", value: "15 testes, 3 suites")
                qualityCard(icon: "testtube.2", title: "Framework", value: "Swift Testing")
                qualityCard(icon: "text.badge.checkmark", title: "Lint", value: "SwiftLint")
                qualityCard(icon: "bolt.shield.fill", title: "Concurrency", value: "Swift 6 strict")
                qualityCard(icon: "shippingbox.fill", title: "Dependências", value: "Zero externas")
            }
            .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
        } header: {
            Label("Qualidade", systemImage: "shield.checkered")
        }
    }

    // MARK: - Storage

    private var storageSection: some View {
        Section {
            HStack(spacing: IngressoSpacing.md) {
                Image(systemName: "internaldrive.fill")
                    .foregroundStyle(.tint)
                    .frame(width: 20)
                Text("Cache da API")
                Spacer()
                if viewModel.isClearing {
                    ProgressView()
                } else {
                    Text(viewModel.formattedCacheSize)
                        .font(.footnote.bold())
                        .foregroundStyle(.secondary)
                }
            }

            HStack(spacing: IngressoSpacing.md) {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.tint)
                    .frame(width: 20)
                Text("Favoritos")
                Spacer()
                Text("Protegido")
                    .font(.footnote.bold())
                    .foregroundStyle(.tint)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(.tint.opacity(0.1), in: Capsule())
            }

            Button(role: .destructive) {
                Task { await viewModel.clearCache() }
            } label: {
                HStack(spacing: IngressoSpacing.md) {
                    Image(systemName: "trash.fill")
                        .foregroundStyle(IngressoColors.destructive)
                        .frame(width: 20)
                    Text("Limpar Cache da API")
                    Spacer()
                    if viewModel.isClearing {
                        ProgressView()
                    }
                }
            }
            .disabled(viewModel.isClearing || viewModel.cacheByteCount == 0)
        } header: {
            Label("Armazenamento", systemImage: "externaldrive.fill")
        } footer: {
            Text("Limpar o cache remove filmes salvos da API. Favoritos são protegidos.")
        }
    }

    // MARK: - Stack

    private var stackSection: some View {
        Section {
            stackRow(item: "Swift", value: "6.3")
            stackRow(item: "Xcode", value: "26")
            stackRow(item: "iOS", value: "26+")
            stackRow(item: "UI", value: "SwiftUI")
            stackRow(item: "Testes", value: "Swift Testing")
            stackRow(item: "Persistência", value: "SwiftData")
            stackRow(item: "Pacotes", value: "SPM multi-target")
            stackRow(item: "Widget", value: "WidgetKit")
        } header: {
            Label("Stack", systemImage: "hammer.fill")
        }
    }

    private func stackRow(item: String, value: String) -> some View {
        HStack {
            Text(item)
                .font(.callout)
            Spacer()
            Text(value)
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
        }
    }

    private func qualityCard(icon: String, title: String, value: String) -> some View {
        VStack(spacing: IngressoSpacing.md) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.tint)
            VStack(spacing: IngressoSpacing.xxs) {
                Text(title)
                    .font(.caption.bold())
                Text(value)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, IngressoSpacing.md)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Phases

    private var phasesSection: some View {
        Section {
            phaseRow(number: 1, title: "Estrutura do Projeto", desc: "Workspace, SPM multi-target, git flow com feature branches")
            phaseRow(number: 2, title: "Camada de Infraestrutura", desc: "HTTPClient (actor), IngressoEndpoint, IngressoNetworkError, SwiftData entities")
            phaseRow(number: 3, title: "Camada de Domínio", desc: "Entidades, protocolos de repositório, use cases, strategy de ordenação")
            phaseRow(number: 4, title: "Camada de Dados", desc: "DTOs, MovieMapper, RemoteMovieRepository, repositórios SwiftData")
            phaseRow(number: 5, title: "Camada de Apresentação", desc: "ViewModels @Observable, IngressoViewState, Router, Factory")
            phaseRow(number: 6, title: "Camada de UI e Mocks", desc: "Todas as telas, componentes reutilizáveis, mocks para previews e testes")
            phaseRow(number: 7, title: "Widget Extension", desc: "WidgetKit com 3 tamanhos, timeline provider, imagens pré-carregadas")
        } header: {
            Label("Roteiro de Desenvolvimento", systemImage: "calendar.badge.clock")
        } footer: {
            Text("Desenvolvimento seguiu feature branches com merge para develop via git flow.")
        }
    }

    private func phaseRow(number: Int, title: String, desc: String) -> some View {
        HStack(spacing: IngressoSpacing.md) {
            Text("\(number).")
                .font(.callout.weight(.heavy))
                .fontDesign(.rounded)
                .foregroundStyle(.tint)

            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.callout.bold())
                Text(desc)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, IngressoSpacing.xxs)
    }
}
