import Foundation
import IngressoDomain

public final class MockMovieCacheRepository: MovieCacheRepositoryProtocol, @unchecked Sendable {
    public var cachedMovies: [IngressoMovie] = []
    public var shouldThrow = false
    public private(set) var saveCallCount = 0

    public init() {}

    public func saveMovies(_ movies: [IngressoMovie]) async throws {
        if shouldThrow { throw MockCacheError.forced }
        saveCallCount += 1
        cachedMovies = movies
    }

    public func loadCachedMovies() async throws -> [IngressoMovie] {
        if shouldThrow { throw MockCacheError.forced }
        return cachedMovies
    }

    public func clearCache() async throws {
        if shouldThrow { throw MockCacheError.forced }
        cachedMovies = []
    }

    private enum MockCacheError: Error {
        case forced
    }
}
