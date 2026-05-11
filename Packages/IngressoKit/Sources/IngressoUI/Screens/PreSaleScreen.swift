import SwiftUI
import IngressoDomain
import IngressoInfrastructure
import IngressoPresentation
import IngressoMock

public struct PreSaleScreen: View {
    @Bindable var viewModel: MovieListViewModel
    @Environment(IngressoRouter.self) private var router

    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Group {
            switch viewModel.viewState {
            case .idle, .loading:
                loadingView
            case .loaded:
                if viewModel.preSaleMovies.isEmpty {
                    ContentUnavailableView(
                        "Sem pré-vendas",
                        systemImage: "ticket",
                        description: Text("Nenhum filme em pré-venda no momento.")
                    )
                } else {
                    preSaleContent
                }
            case .error:
                ContentUnavailableView(
                    "Não foi possível carregar",
                    systemImage: "ticket",
                    description: Text("Toque no banner abaixo para tentar novamente.")
                )
            case .empty:
                ContentUnavailableView(
                    "Sem pré-vendas",
                    systemImage: "ticket",
                    description: Text("Nenhum filme em pré-venda no momento.")
                )
            }
        }
        .overlay(alignment: .bottom) {
            StatusBanner(
                error: viewModel.viewState.networkError,
                retryAction: { Task { await viewModel.fetchMovies() } }
            )
            .animation(.snappy, value: viewModel.viewState.networkError)
        }
        .navigationTitle("Pré-venda")
        .task { await viewModel.fetchMoviesIfNeeded() }
    }

    private var loadingView: some View {
        ScrollView {
            VStack(spacing: IngressoSpacing.lg) {
                ForEach(0..<4, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.quaternary)
                        .frame(height: 200)
                        .shimmer()
                }
            }
            .padding()
        }
    }

    private var preSaleContent: some View {
        ScrollView {
            VStack(spacing: IngressoSpacing.lg) {

                LazyVStack(spacing: IngressoSpacing.lg) {
                    ForEach(Array(viewModel.preSaleMovies.enumerated()), id: \.element.id) { index, movie in
                        Button {
                            router.navigate(to: .movieDetail(movie))
                        } label: {
                            PreSaleFeatureCard(movie: movie)
                        }
                        .buttonStyle(.plain)
                        .appearAnimation(delay: Double(index) * 0.1, offsetY: 30)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    @Previewable @State var vm: MovieListViewModel = {
        let fetchUseCase = MockFetchMoviesUseCase()
        fetchUseCase.result = .success([
            IngressoFixtures.makeMovie(id: "1", title: "Mortal Kombat 2", inPreSale: true),
            IngressoFixtures.makeMovie(id: "2", title: "Thunderbolts", inPreSale: true),
        ])
        return IngressoPresentationFactory().makeMovieListViewModel(
            fetchMoviesUseCase: fetchUseCase,
            searchMoviesUseCase: MockSearchMoviesUseCase()
        )
    }()

    NavigationStack {
        PreSaleScreen(viewModel: vm)
    }
    .environment(IngressoPresentationFactory().makeRouter())
    .environment(IngressoInfrastructureFactory().makeNetworkMonitor())
    .environment(IngressoPresentationFactory().makeFavoritesViewModel(repository: MockFavoritesRepository()))
}
