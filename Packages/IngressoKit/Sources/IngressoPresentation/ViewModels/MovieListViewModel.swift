import Foundation
import Observation
import OSLog
import IngressoDomain
import IngressoInfrastructure

@Observable
@MainActor
public final class MovieListViewModel {
    public private(set) var viewState: IngressoViewState<[IngressoMovie]> = .idle
    public var searchQuery: String = "" {
        didSet { applySearch() }
    }
    public private(set) var filteredMovies: [IngressoMovie] = []
    public private(set) var preSaleMovies: [IngressoMovie] = []
    public private(set) var availableGenres: [String] = []

    private let logger = Logger(subsystem: "com.brunosantos.Ingresso", category: "MovieList")

    public func movies(forGenre genre: String) -> [IngressoMovie] {
        filteredMovies.filter { $0.genres.contains(genre) }
    }

    public func movies(forGenres genres: [String]) -> [IngressoMovie] {
        let genreSet = Set(genres)
        return filteredMovies.filter { movie in
            movie.genres.contains(where: { genreSet.contains($0) })
        }
    }

    private let fetchMoviesUseCase: FetchMoviesUseCaseProtocol
    private let searchMoviesUseCase: SearchMoviesUseCaseProtocol
    private var allMovies: [IngressoMovie] = []
    private var hasFetched = false

    init(
        fetchMoviesUseCase: FetchMoviesUseCaseProtocol,
        searchMoviesUseCase: SearchMoviesUseCaseProtocol
    ) {
        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.searchMoviesUseCase = searchMoviesUseCase
    }

    public func fetchMoviesIfNeeded() async {
        guard !hasFetched else { return }
        logger.info("🎬 carregamento inicial")
        await fetchMovies()
    }

    public func fetchMovies() async {
        if allMovies.isEmpty {
            viewState = .loading
        }
        do {
            let movies = try await fetchMoviesUseCase.execute()
            allMovies = movies
            preSaleMovies = movies.filter(\.inPreSale)
            hasFetched = true
            applySearch()
            viewState = allMovies.isEmpty ? .empty : .loaded(filteredMovies)
            logger.info("🎬 \(movies.count) filmes carregados, \(self.preSaleMovies.count) em pré-venda")
        } catch {
            if allMovies.isEmpty {
                let networkError = (error as? IngressoNetworkError) ?? .unknown(statusCode: 0)
                viewState = .error(networkError)
                logger.error("❌ erro ao carregar filmes: \(error.localizedDescription)")
            }
        }
    }

    public func refresh() async {
        logger.info("🎬 pull-to-refresh")
        await fetchMovies()
    }

    private func applySearch() {
        if searchQuery.isEmpty {
            filteredMovies = allMovies
        } else {
            filteredMovies = searchMoviesUseCase.execute(query: searchQuery, in: allMovies)
        }
        availableGenres = Array(Set(filteredMovies.flatMap(\.genres))).sorted()
        if case .loaded = viewState {
            viewState = .loaded(filteredMovies)
        }
    }
}
