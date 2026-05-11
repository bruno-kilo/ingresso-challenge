import SwiftUI
import IngressoDomain
import IngressoInfrastructure
import IngressoPresentation
import IngressoMock

public struct MovieListScreen: View {
    @Bindable var viewModel: MovieListViewModel
    @Environment(IngressoRouter.self) private var router

    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
    }

    @State private var selectedGenreFilter: String?

    public var body: some View {
        Group {
            switch viewModel.viewState {
            case .idle, .loading:
                loadingView
            case .loaded:
                movieContent
            case .error:
                ContentUnavailableView(
                    "Não foi possível carregar",
                    systemImage: "film.stack",
                    description: Text("Toque no banner abaixo para tentar novamente.")
                )
            case .empty:
                ContentUnavailableView(
                    "Nenhum filme encontrado",
                    systemImage: "film.stack",
                    description: Text("Não há filmes em breve no momento.")
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
        .navigationTitle("Estreias")
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        selectedGenreFilter = nil
                    } label: {
                        HStack {
                            Text("Todos")
                            if selectedGenreFilter == nil {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    Divider()
                    ForEach(viewModel.availableGenres, id: \.self) { genre in
                        Button {
                            selectedGenreFilter = genre
                        } label: {
                            HStack {
                                Text(genre)
                                if selectedGenreFilter == genre {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "list.and.film")
                }
            }
            #endif
        }
        .refreshable { await viewModel.refresh() }
        .task { await viewModel.fetchMoviesIfNeeded() }
    }

    private var loadingView: some View {
        ScrollView {
            VStack(spacing: IngressoSpacing.lg) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.quaternary)
                    .frame(height: 220)
                    .padding(.horizontal)
                    .shimmer()

                ForEach(0..<3, id: \.self) { _ in
                    VStack(alignment: .leading, spacing: IngressoSpacing.sm) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(.quaternary)
                            .frame(width: 120, height: 20)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: IngressoSpacing.md) {
                                ForEach(0..<5, id: \.self) { _ in
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.quaternary)
                                        .frame(width: 140, height: 210)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }

    private var movieContent: some View {
        browseView
    }

    private var displayedMovies: [IngressoMovie] {
        guard let genre = selectedGenreFilter else { return viewModel.filteredMovies }
        return viewModel.movies(forGenre: genre)
    }

    private var browseView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: IngressoSpacing.xl) {
                if selectedGenreFilter != nil {
                    filteredGrid
                } else {
                    fullBrowseContent
                }
            }
            .padding(.vertical)
            .animation(.easeInOut(duration: 0.3), value: selectedGenreFilter)
        }
    }

    private var fullBrowseContent: some View {
        Group {
            if let featured = viewModel.filteredMovies.first(where: { $0.inPreSale }) ?? viewModel.filteredMovies.first {
                Button {
                    router.navigate(to: .movieDetail(featured))
                } label: {
                    HeroBanner(movie: featured)
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
            }

            if !viewModel.preSaleMovies.isEmpty {
                MovieSection(
                    title: "Pré-venda",
                    movies: viewModel.preSaleMovies
                )
            }

            MovieSection(
                title: "Próximas Estreias",
                movies: Array(viewModel.filteredMovies.prefix(10)),
                showsRank: true
            )

            ForEach(GenreSection.featured, id: \.title) { section in
                let movies = viewModel.movies(forGenres: section.genres)
                if !movies.isEmpty {
                    MovieSection(title: section.title, movies: movies)
                }
            }

            allMoviesGrid
        }
    }

    private var filteredGrid: some View {
        VStack(alignment: .leading, spacing: IngressoSpacing.sm) {
            HStack {
                Text(selectedGenreFilter ?? "")
                    .font(.title3.bold())

                Spacer()

                Button("Limpar") {
                    selectedGenreFilter = nil
                }
                .font(.subheadline)
            }
            .padding(.horizontal)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: IngressoSpacing.md)], spacing: IngressoSpacing.lg) {
                ForEach(displayedMovies) { movie in
                    Button {
                        router.navigate(to: .movieDetail(movie))
                    } label: {
                        MoviePosterCard(movie: movie)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }

    private var allMoviesGrid: some View {
        VStack(alignment: .leading, spacing: IngressoSpacing.sm) {
            Text("Todos os Filmes")
                .font(.title3.bold())
                .padding(.horizontal)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: IngressoSpacing.md)], spacing: IngressoSpacing.lg) {
                ForEach(viewModel.filteredMovies) { movie in
                    Button {
                        router.navigate(to: .movieDetail(movie))
                    } label: {
                        MoviePosterCard(movie: movie)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
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
        MovieListScreen(viewModel: vm)
    }
    .environment(IngressoPresentationFactory().makeRouter())
    .environment(IngressoInfrastructureFactory().makeNetworkMonitor())
    .environment(IngressoPresentationFactory().makeFavoritesViewModel(repository: MockFavoritesRepository()))
}
