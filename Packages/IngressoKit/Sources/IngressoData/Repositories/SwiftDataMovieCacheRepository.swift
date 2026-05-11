import Foundation
import OSLog
import SwiftData
import IngressoDomain
import IngressoInfrastructure

final class SwiftDataMovieCacheRepository: MovieCacheRepositoryProtocol, @unchecked Sendable {
    private let modelContainer: ModelContainer
    private let logger = Logger(subsystem: "com.brunosantos.Ingresso", category: "Cache")

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    func saveMovies(_ movies: [IngressoMovie]) async throws {
        let context = ModelContext(modelContainer)

        let existingDescriptor = FetchDescriptor<CachedMovieEntity>()
        let existing = try context.fetch(existingDescriptor)
        let entityMap = Dictionary(uniqueKeysWithValues: existing.map { ($0.movieId, $0) })
        let newIds = Set(movies.map(\.id))

        for entity in existing where !newIds.contains(entity.movieId) {
            context.delete(entity)
        }

        for movie in movies {
            if let entity = entityMap[movie.id] {
                MovieEntityMapper.updateEntity(entity, from: movie)
                entity.cachedAt = Date()
            } else {
                context.insert(CachedMovieMapper.toEntity(movie))
            }
        }

        try context.save()
        logger.info("🗄️ cache salvo: \(movies.count) filmes")
    }

    func loadCachedMovies() async throws -> [IngressoMovie] {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<CachedMovieEntity>(
            sortBy: [SortDescriptor(\.cachedAt)]
        )
        let entities = try context.fetch(descriptor)
        return entities.map(CachedMovieMapper.toDomain)
    }

    func clearCache() async throws {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<CachedMovieEntity>()
        let entities = try context.fetch(descriptor)
        for entity in entities {
            context.delete(entity)
        }
        try context.save()
        logger.info("🗄️ cache limpo: \(entities.count) filmes removidos")
    }
}
