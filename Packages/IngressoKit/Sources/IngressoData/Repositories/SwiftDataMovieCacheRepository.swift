import Foundation
import SwiftData
import IngressoDomain
import IngressoInfrastructure

public final class SwiftDataMovieCacheRepository: MovieCacheRepositoryProtocol, @unchecked Sendable {
    private let modelContainer: ModelContainer

    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    public func saveMovies(_ movies: [IngressoMovie]) async throws {
        let context = ModelContext(modelContainer)

        let existingDescriptor = FetchDescriptor<CachedMovieEntity>()
        let existing = try context.fetch(existingDescriptor)
        let existingIds = Set(existing.map(\.movieId))
        let newIds = Set(movies.map(\.id))

        for entity in existing where !newIds.contains(entity.movieId) {
            context.delete(entity)
        }

        for movie in movies where !existingIds.contains(movie.id) {
            context.insert(CachedMovieMapper.toEntity(movie))
        }

        for movie in movies where existingIds.contains(movie.id) {
            if let entity = existing.first(where: { $0.movieId == movie.id }) {
                MovieEntityMapper.updateEntity(entity, from: movie)
                entity.cachedAt = Date()
            }
        }

        try context.save()
    }

    public func loadCachedMovies() async throws -> [IngressoMovie] {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<CachedMovieEntity>(
            sortBy: [SortDescriptor(\.cachedAt)]
        )
        let entities = try context.fetch(descriptor)
        return entities.map(CachedMovieMapper.toDomain)
    }

    public func clearCache() async throws {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<CachedMovieEntity>()
        let entities = try context.fetch(descriptor)
        for entity in entities {
            context.delete(entity)
        }
        try context.save()
    }
}
