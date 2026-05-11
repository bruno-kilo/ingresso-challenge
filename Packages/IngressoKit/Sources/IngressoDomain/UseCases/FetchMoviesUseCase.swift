public protocol FetchMoviesUseCaseProtocol: Sendable {
    func execute() async throws -> [IngressoMovie]
}
