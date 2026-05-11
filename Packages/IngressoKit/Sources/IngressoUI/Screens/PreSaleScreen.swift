import SwiftUI
import IngressoDomain
import IngressoInfrastructure
import IngressoPresentation

public struct PreSaleScreen: View {
    @Bindable var viewModel: MovieListViewModel

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
                        NavigationLink(value: IngressoRoute.movieDetail(movie)) {
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
