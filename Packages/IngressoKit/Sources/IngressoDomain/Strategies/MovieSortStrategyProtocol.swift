public protocol MovieSortStrategyProtocol: Sendable {
    func sort(_ movies: [IngressoMovie]) -> [IngressoMovie]
}

public struct PremiereDateSortStrategy: MovieSortStrategyProtocol {
    public init() {}

    public func sort(_ movies: [IngressoMovie]) -> [IngressoMovie] {
        movies.sorted { lhs, rhs in
            guard let lhsDate = lhs.premiereDate?.localDate else { return false }
            guard let rhsDate = rhs.premiereDate?.localDate else { return true }
            return lhsDate < rhsDate
        }
    }
}
