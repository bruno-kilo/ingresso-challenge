import Foundation
import Observation
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

    public var availableGenres: [String] {
        Array(Set(filteredMovies.flatMap(\.genres))).sorted()
    }

    public func movies(forGenre genre: String) -> [IngressoMovie] {
        filteredMovies.filter { $0.genres.contains(genre) }
    }

    public func movies(forGenres genres: [String]) -> [IngressoMovie] {
        filteredMovies.filter { movie in
            genres.contains(where: { movie.genres.contains($0) })
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
        } catch {
            if allMovies.isEmpty {
                let networkError = (error as? IngressoNetworkError) ?? .unknown(statusCode: 0)
                viewState = .error(networkError)
            }
        }
    }

    public func refresh() async {
        await fetchMovies()
    }

    private func applySearch() {
        if searchQuery.isEmpty {
            filteredMovies = allMovies
        } else {
            filteredMovies = searchMoviesUseCase.execute(query: searchQuery, in: allMovies)
        }
        if case .loaded = viewState {
            viewState = .loaded(filteredMovies)
        }
    }
}
