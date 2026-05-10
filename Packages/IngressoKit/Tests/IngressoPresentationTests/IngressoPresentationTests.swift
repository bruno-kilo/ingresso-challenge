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
        let vm = makeMovieListViewModel()

        guard case .idle = vm.viewState else {
            Issue.record("Expected idle state")
            return
        }
    }

    @Test("ViewModel carrega filmes com sucesso")
    @MainActor
    func viewModelFetchesMoviesSuccessfully() async {
        let fetchUseCase = MockFetchMoviesUseCase()
        fetchUseCase.result = .success(IngressoFixtures.sampleMovies)
        let vm = makeMovieListViewModel(fetchUseCase: fetchUseCase)

        await vm.fetchMovies()

        guard case .loaded(let movies) = vm.viewState else {
            Issue.record("Expected loaded state")
            return
        }
        #expect(movies.count == 3)
        #expect(vm.filteredMovies.count == 3)
    }

    @Test("ViewModel filtra filmes em pré-venda")
    @MainActor
    func viewModelFiltersPreSaleMovies() async {
        let fetchUseCase = MockFetchMoviesUseCase()
        fetchUseCase.result = .success(IngressoFixtures.sampleMovies)
        let vm = makeMovieListViewModel(fetchUseCase: fetchUseCase)

        await vm.fetchMovies()

        #expect(vm.preSaleMovies.count == 1)
        #expect(vm.preSaleMovies[0].title == "Mortal Kombat 2")
    }

    @Test("ViewModel entra em estado de erro quando fetch falha")
    @MainActor
    func viewModelSetsErrorStateOnFailure() async {
        let fetchUseCase = MockFetchMoviesUseCase()
        fetchUseCase.result = .failure(IngressoNetworkError.noConnection)
        let vm = makeMovieListViewModel(fetchUseCase: fetchUseCase)

        await vm.fetchMovies()

        guard case .error(let error) = vm.viewState else {
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
        let vm = FavoritesViewModel(repository: repo)
        let movie = IngressoFixtures.makeMovie(id: "1")

        vm.toggle(movie)
        #expect(vm.isFavorite(movie) == true)

        vm.toggle(movie)
        #expect(vm.isFavorite(movie) == false)
    }

    // MARK: - Helpers

    @MainActor
    private func makeMovieListViewModel(
        fetchUseCase: MockFetchMoviesUseCase = MockFetchMoviesUseCase(),
        searchUseCase: MockSearchMoviesUseCase? = nil
    ) -> MovieListViewModel {
        let search = searchUseCase ?? {
            let s = MockSearchMoviesUseCase()
            s.result = []
            return s
        }()
        return MovieListViewModel(fetchMoviesUseCase: fetchUseCase, searchMoviesUseCase: search)
    }
}
