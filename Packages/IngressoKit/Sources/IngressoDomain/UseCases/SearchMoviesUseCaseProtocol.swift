public protocol SearchMoviesUseCaseProtocol: Sendable {
    func execute(query: String, in movies: [IngressoMovie]) -> [IngressoMovie]
}
