import SwiftUI
import IngressoDomain
import IngressoInfrastructure
import IngressoPresentation
import IngressoMock

public struct SearchScreen: View {
    @Bindable var viewModel: MovieListViewModel

    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Group {
            if viewModel.searchQuery.isEmpty {
                browseCategories
            } else if viewModel.filteredMovies.isEmpty {
                ContentUnavailableView.search(text: viewModel.searchQuery)
            } else {
                searchResults
            }
        }
        .overlay(alignment: .bottom) {
            StatusBanner(
                error: viewModel.viewState.networkError,
                retryAction: { Task { await viewModel.fetchMovies() } }
            )
            .animation(.snappy, value: viewModel.viewState.networkError)
        }
        .navigationTitle("Buscar")
        .searchable(text: $viewModel.searchQuery, prompt: "Título, diretor, gênero...")
        .task { await viewModel.fetchMoviesIfNeeded() }
    }

    private var browseCategories: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: IngressoSpacing.md), GridItem(.flexible(), spacing: IngressoSpacing.md)], spacing: IngressoSpacing.md) {
                ForEach(SearchCategory.allCases) { category in
                    Button {
                        viewModel.searchQuery = category.query
                    } label: {
                        SearchCategoryCard(category: category)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }

    private var searchResults: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: IngressoSpacing.md)], spacing: IngressoSpacing.lg) {
                ForEach(viewModel.filteredMovies) { movie in
                    NavigationLink(value: IngressoRoute.movieDetail(movie)) {
                        MoviePosterCard(movie: movie)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            .animation(.easeInOut(duration: 0.3), value: viewModel.filteredMovies.map(\.id))
        }
    }
}

#Preview {
    @Previewable @State var vm: MovieListViewModel = {
        let fetchUseCase = MockFetchMoviesUseCase()
        fetchUseCase.result = .success(IngressoFixtures.sampleMovies)
        return IngressoPresentationFactory().makeMovieListViewModel(
            fetchMoviesUseCase: fetchUseCase,
            searchMoviesUseCase: MockSearchMoviesUseCase()
        )
    }()

    NavigationStack {
        SearchScreen(viewModel: vm)
    }
    .environment(IngressoPresentationFactory().makeRouter())
    .environment(IngressoInfrastructureFactory().makeNetworkMonitor())
    .environment(IngressoPresentationFactory().makeFavoritesViewModel(repository: MockFavoritesRepository()))
}
