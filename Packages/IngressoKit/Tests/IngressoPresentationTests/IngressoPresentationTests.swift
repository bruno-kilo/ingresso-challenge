import Testing
import Foundation
@testable import IngressoPresentation
import IngressoDomain
import IngressoInfrastructure
import IngressoMock

@Suite("IngressoPresentation")
struct IngressoPresentationTests {

    // MARK: - MovieListViewModel

    @Test("ViewModel inicia em estado idle")
    @MainActor
    func viewModelStartsIdle() {
        let viewModel = makeMovieListViewModel()

        guard case .idle = viewModel.viewState else {
            Issue.record("Expected idle state")
            return
        }
    }

    @Test("ViewModel carrega filmes com sucesso")
    @MainActor
    func viewModelFetchesMoviesSuccessfully() async {
        let fetchUseCase = MockFetchMoviesUseCase()
        fetchUseCase.result = .success(IngressoFixtures.sampleMovies)
        let viewModel = makeMovieListViewModel(fetchUseCase: fetchUseCase)

        await viewModel.fetchMovies()

        guard case .loaded(let movies) = viewModel.viewState else {
            Issue.record("Expected loaded state")
            return
        }
        #expect(movies.count == 3)
        #expect(viewModel.filteredMovies.count == 3)
    }

    @Test("ViewModel filtra filmes em pré-venda")
    @MainActor
    func viewModelFiltersPreSaleMovies() async {
        let fetchUseCase = MockFetchMoviesUseCase()
        fetchUseCase.result = .success(IngressoFixtures.sampleMovies)
        let viewModel = makeMovieListViewModel(fetchUseCase: fetchUseCase)

        await viewModel.fetchMovies()

        #expect(viewModel.preSaleMovies.count == 1)
        #expect(viewModel.preSaleMovies[0].title == "Mortal Kombat 2")
    }

    @Test("ViewModel entra em estado de erro quando fetch falha")
    @MainActor
    func viewModelSetsErrorStateOnFailure() async {
        let fetchUseCase = MockFetchMoviesUseCase()
        fetchUseCase.result = .failure(IngressoNetworkError.noConnection)
        let viewModel = makeMovieListViewModel(fetchUseCase: fetchUseCase)

        await viewModel.fetchMovies()

        guard case .error(let error) = viewModel.viewState else {
            Issue.record("Expected error state")
            return
        }
        #expect(error == .noConnection)
    }

    // MARK: - FavoritesViewModel

    @Test("FavoritesViewModel alterna favorito corretamente")
    @MainActor
    func favoritesViewModelToggles() async {
        let repo = MockFavoritesRepository()
        let viewModel = FavoritesViewModel(repository: repo)
        let movie = IngressoFixtures.makeMovie(id: "1")

        viewModel.toggle(movie)
        #expect(viewModel.isFavorite(movie) == true)

        viewModel.toggle(movie)
        #expect(viewModel.isFavorite(movie) == false)
    }

    // MARK: - Helpers

    @MainActor
    private func makeMovieListViewModel(
        fetchUseCase: MockFetchMoviesUseCase = MockFetchMoviesUseCase(),
        searchUseCase: MockSearchMoviesUseCase? = nil
    ) -> MovieListViewModel {
        let search = searchUseCase ?? {
            let mock = MockSearchMoviesUseCase()
            mock.result = []
            return mock
        }()
        return MovieListViewModel(fetchMoviesUseCase: fetchUseCase, searchMoviesUseCase: search)
    }
}
