import Foundation
import OSLog
import SwiftData
import IngressoDomain
import IngressoInfrastructure

public final class SwiftDataFavoritesRepository: FavoritesRepositoryProtocol, @unchecked Sendable {
    private let modelContainer: ModelContainer
    private let logger = Logger(subsystem: "com.brunosantos.Ingresso", category: "Favorites")

    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    public func fetchAll() async throws -> [IngressoMovie] {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<FavoriteMovieEntity>(
            sortBy: [SortDescriptor(\.addedAt)]
        )
        let entities = try context.fetch(descriptor)
        logger.debug("Favoritos carregados: \(entities.count)")
        return entities.map(FavoriteMovieMapper.toDomain)
    }

    public func add(_ movie: IngressoMovie) async throws {
        let context = ModelContext(modelContainer)
        let entity = FavoriteMovieMapper.toEntity(movie)
        context.insert(entity)
        try context.save()
        logger.info("★ Favoritado: \(movie.title)")
    }

    public func remove(byId id: String) async throws {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<FavoriteMovieEntity>(
            predicate: #Predicate { $0.movieId == id }
        )
        if let entity = try context.fetch(descriptor).first {
            context.delete(entity)
            try context.save()
            logger.info("☆ Desfavoritado: \(id)")
        }
    }

    public func contains(id: String) async throws -> Bool {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<FavoriteMovieEntity>(
            predicate: #Predicate { $0.movieId == id }
        )
        return try !context.fetch(descriptor).isEmpty
    }
}
