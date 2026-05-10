public protocol MovieFilterStrategyProtocol: Sendable {
    func filter(_ movies: [IngressoMovie]) -> [IngressoMovie]
}

public struct PreSaleFilterStrategy: MovieFilterStrategyProtocol {
    public init() {}

    public func filter(_ movies: [IngressoMovie]) -> [IngressoMovie] {
        movies.filter(\.inPreSale)
    }
}

public struct GenreFilterStrategy: MovieFilterStrategyProtocol {
    public let genre: String

    public init(genre: String) {
        self.genre = genre
    }

    public func filter(_ movies: [IngressoMovie]) -> [IngressoMovie] {
        movies.filter { $0.genres.contains(genre) }
    }
}
