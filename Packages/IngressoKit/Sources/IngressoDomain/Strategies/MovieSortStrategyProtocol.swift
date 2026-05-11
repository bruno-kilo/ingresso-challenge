public protocol MovieSortStrategyProtocol: Sendable {
    func sort(_ movies: [IngressoMovie]) -> [IngressoMovie]
}
