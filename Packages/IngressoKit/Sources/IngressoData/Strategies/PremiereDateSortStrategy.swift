import IngressoDomain

struct PremiereDateSortStrategy: MovieSortStrategyProtocol {
    func sort(_ movies: [IngressoMovie]) -> [IngressoMovie] {
        movies.sorted { lhs, rhs in
            guard let lhsDate = lhs.premiereDate?.localDate else { return false }
            guard let rhsDate = rhs.premiereDate?.localDate else { return true }
            return lhsDate < rhsDate
        }
    }
}
