import Foundation
import IngressoDomain

public final class MockFavoritesRepository: FavoritesRepositoryProtocol, @unchecked Sendable {
    public var movies: [IngressoMovie] = []
    public var shouldThrow = false

    public init() {}

    public func fetchAll() async throws -> [IngressoMovie] {
        if shouldThrow { throw MockError.forced }
        return movies
    }

    public func add(_ movie: IngressoMovie) async throws {
        if shouldThrow { throw MockError.forced }
        movies.append(movie)
    }

    public func remove(byId id: String) async throws {
        if shouldThrow { throw MockError.forced }
        movies.removeAll { $0.id == id }
    }

    public func contains(id: String) async throws -> Bool {
        if shouldThrow { throw MockError.forced }
        return movies.contains { $0.id == id }
    }

    private enum MockError: Error {
        case forced
    }
}
