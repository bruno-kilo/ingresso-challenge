public protocol SearchMoviesUseCaseProtocol: Sendable {
    func execute(query: String, in movies: [IngressoMovie]) -> [IngressoMovie]
}

public struct SearchMoviesUseCase: SearchMoviesUseCaseProtocol {
    public init() {}

    public func execute(query: String, in movies: [IngressoMovie]) -> [IngressoMovie] {
        let lowercasedQuery = query.lowercased()
        return movies.filter { movie in
            movie.title.lowercased().contains(lowercasedQuery)
            || movie.originalTitle.lowercased().contains(lowercasedQuery)
            || movie.director.lowercased().contains(lowercasedQuery)
            || movie.genres.contains { $0.lowercased().contains(lowercasedQuery) }
        }
    }
}
