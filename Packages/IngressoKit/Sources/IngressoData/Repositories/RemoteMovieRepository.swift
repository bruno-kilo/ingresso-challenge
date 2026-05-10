import IngressoDomain
import IngressoInfrastructure

public struct RemoteMovieRepository: MovieRepositoryProtocol {
    private let client: HTTPClientProtocol

    public init(client: HTTPClientProtocol) {
        self.client = client
    }

    public func fetchComingSoonMovies() async throws -> [IngressoMovie] {
        let response = try await client.request(
            MovieEndpoints.comingSoon,
            as: MovieResponseDTO.self
        )
        return MovieMapper.toDomain(response.items)
    }
}
