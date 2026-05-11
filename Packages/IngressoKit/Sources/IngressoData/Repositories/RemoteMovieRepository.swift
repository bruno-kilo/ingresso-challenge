import IngressoDomain
import IngressoInfrastructure

struct RemoteMovieRepository: MovieRepositoryProtocol {
    private let client: HTTPClientProtocol

    init(client: HTTPClientProtocol) {
        self.client = client
    }

    func fetchComingSoonMovies() async throws -> [IngressoMovie] {
        let response = try await client.request(
            MovieEndpoints.comingSoon,
            as: MovieResponseDTO.self
        )
        return MovieMapper.toDomain(response.items)
    }
}
