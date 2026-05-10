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
        .task { await viewModel.loadCacheSize() }
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
                    Text("App iOS que consome a API pública da Ingresso.com para exibir filmes que entrarão em cartaz nos cinemas.")
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
            architectureRow(layer: "IngressoApp", desc: "Composition Root / DI", icon: "app.fill")
            architectureRow(layer: "IngressoUI", desc: "SwiftUI Views, Componentes, Tokens", icon: "paintbrush.fill")
            architectureRow(layer: "Presentation", desc: "ViewModels (MVVM), Router, States", icon: "rectangle.3.group.fill")
            architectureRow(layer: "Data", desc: "DTOs, Mappers, Repositories", icon: "externaldrive.fill")
            architectureRow(layer: "Domain", desc: "Entidades, Use Cases, Strategies", icon: "cube.fill")
            architectureRow(layer: "Infrastructure", desc: "HTTPClient, Persistence, Network", icon: "network")
        } header: {
            Label("Clean Architecture", systemImage: "building.columns.fill")
        } footer: {
            Text("6 camadas em SPM multi-target. Regra de dependência: camadas externas dependem das internas. Domain nunca depende de nada.")
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
                items: ["IngressoMovie", "FetchMoviesUseCase (cache offline)", "SearchMoviesUseCase",
                        "PremiereDateSortStrategy", "PreSaleFilterStrategy", "GenreFilterStrategy",
                        "FavoritesRepositoryProtocol", "MovieCacheRepositoryProtocol"]
            )
            layerDetail(
                name: "Infrastructure",
                items: ["IngressoHTTPClient (actor, retry com backoff)", "IngressoEndpoint",
                        "IngressoNetworkError (tipado, isRetryable)", "NetworkMonitor (NWPathMonitor)",
                        "UserDefaultsPersistence", "SwiftData Entities"]
            )
            layerDetail(
                name: "Data",
                items: ["MovieDTO", "MovieMapper", "MovieEntityMapper (genérico via protocol)",
                        "RemoteMovieRepository", "SwiftDataFavoritesRepository",
                        "SwiftDataMovieCacheRepository"]
            )
            layerDetail(
                name: "Presentation",
                items: ["MovieListViewModel", "MovieDetailViewModel", "FavoritesViewModel",
                        "SettingsViewModel", "IngressoRouter (per-tab paths)",
                        "IngressoViewState (erro tipado)", "GenreSection"]
            )
            layerDetail(
                name: "UI",
                items: ["MovieListScreen", "MovieDetailScreen", "PreSaleScreen",
                        "SearchScreen", "FavoritesScreen", "SettingsScreen",
                        "StatusBanner (Mail.app)", "FlowLayout", "ShimmerModifier"]
            )
            layerDetail(
                name: "Mock",
                items: ["MockFetchMoviesUseCase", "MockMovieRepository",
                        "MockHTTPClient", "MockFavoritesRepository", "IngressoFixtures"]
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
            patternRow(name: "Repository", where: "Domain → Data", detail: "Protocol + implementação concreta")
            patternRow(name: "Factory", where: "Presentation → App", detail: "ViewModelFactoryProtocol → DependencyContainer")
            patternRow(name: "Strategy", where: "Domain", detail: "Sort, filter, genre — extensível sem modificar VMs")
            patternRow(name: "Observer", where: "Presentation", detail: "@Observable nos ViewModels")
            patternRow(name: "Router", where: "Presentation", detail: "Per-tab paths, sheet, fullScreenCover")
            patternRow(name: "Adapter", where: "Data", detail: "MovieMapper transforma DTO → Domain entity")
            patternRow(name: "Builder", where: "Infrastructure", detail: "IngressoEndpoint constrói URLRequest")
            patternRow(name: "DI", where: "App target", detail: "IngressoDependencyContainer monta tudo")
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
            featureRow(icon: "film", title: "Estreias", desc: "Layout Apple TV, hero banner, seções por gênero, filtro, shimmer, pull-to-refresh")
            featureRow(icon: "ticket.fill", title: "Pré-venda", desc: "Cards com banner, gradient overlay, badge, animação de entrada escalonada")
            featureRow(icon: "magnifyingglass", title: "Busca", desc: "Searchable nativo, cards de categorias, busca por título/diretor/gênero")
            featureRow(icon: "heart.fill", title: "Favoritos", desc: "Grid de posters, SwiftData persistência, toggle instantâneo")
            featureRow(icon: "square.text.square", title: "Detalhe", desc: "List nativo, banner + badges, seções organizadas, FlowLayout, trailers")
            featureRow(icon: "widget.small", title: "Widget", desc: "3 tamanhos, imagens pré-carregadas, poster full-bleed no small")
            featureRow(icon: "wifi.slash", title: "Error Handling", desc: "Erros tipados, StatusBanner Mail.app, retry com backoff, NetworkMonitor")
            featureRow(icon: "internaldrive", title: "Cache Offline", desc: "SwiftData upsert — sem internet exibe últimos dados, reconexão atualiza")
            featureRow(icon: "globe", title: "Localização", desc: "String Catalogs (pt-BR + en) via Localizable.xcstrings")
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
                qualityCard(icon: "checkmark.circle.fill", title: "Testes", value: "130 em 21 suites")
                qualityCard(icon: "testtube.2", title: "Framework", value: "Swift Testing")
                qualityCard(icon: "text.badge.checkmark", title: "Lint", value: "SwiftLint")
                qualityCard(icon: "bolt.shield.fill", title: "Concurrency", value: "Swift 6 Strict")
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
                        .foregroundStyle(.red)
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
            Text("Limpar o cache remove filmes baixados da API. Favoritos são protegidos e não podem ser apagados por aqui.")
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
            stackRow(item: "Pacotes", value: "SPM")
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
            phaseRow(number: 1, title: "Fundação", desc: "Workspace, SPM multi-target, git flow")
            phaseRow(number: 2, title: "Infrastructure", desc: "HTTPClient (actor), Endpoint, Persistence")
            phaseRow(number: 3, title: "Domain", desc: "Entidades, protocolos, use cases, strategies")
            phaseRow(number: 4, title: "Data", desc: "DTOs, MovieMapper, RemoteMovieRepository")
            phaseRow(number: 5, title: "Presentation", desc: "ViewModels MVVM, ViewState, Router, Factory")
            phaseRow(number: 6, title: "UI", desc: "Telas, componentes, design tokens, TabView")
            phaseRow(number: 7, title: "Redesign UI", desc: "Layout Apple TV, hero banner, seções horizontais")
            phaseRow(number: 8, title: "Componentização", desc: "BannerImage, GradientOverlay, PressableModifier")
            phaseRow(number: 9, title: "Testes", desc: "130 testes em 21 suites, test plan, cobertura seletiva")
            phaseRow(number: 10, title: "SwiftData", desc: "Favoritos + cache offline com fallback")
            phaseRow(number: 11, title: "Redesign Detalhe", desc: "List nativo, banner, badges, FlowLayout")
            phaseRow(number: 12, title: "Router Pattern", desc: "Per-tab paths, sheet, IngressoNavigationModifier")
            phaseRow(number: 13, title: "Code Review", desc: "DRY mappers, MovieEntityProtocol, GenreSection")
            phaseRow(number: 14, title: "Error Handling", desc: "NetworkMonitor, StatusBanner, retry backoff")
            phaseRow(number: 15, title: "Widget", desc: "WidgetKit, 3 tamanhos, imagens pré-carregadas")
            phaseRow(number: 16, title: "Sobre", desc: "Tela de detalhes técnicos e gerenciamento de cache")
        } header: {
            Label("Fases de Desenvolvimento", systemImage: "calendar.badge.clock")
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
