import Foundation
import SwiftData
import IngressoDomain
import IngressoInfrastructure

public final class SwiftDataFavoritesRepository: FavoritesRepositoryProtocol, @unchecked Sendable {
    private let modelContainer: ModelContainer

    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    public func fetchAll() async throws -> [IngressoMovie] {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<FavoriteMovieEntity>(
            sortBy: [SortDescriptor(\.addedAt)]
        )
        let entities = try context.fetch(descriptor)
        return entities.map(FavoriteMovieMapper.toDomain)
    }

    public func add(_ movie: IngressoMovie) async throws {
        let context = ModelContext(modelContainer)
        let entity = FavoriteMovieMapper.toEntity(movie)
        context.insert(entity)
        try context.save()
    }

    public func remove(byId id: String) async throws {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<FavoriteMovieEntity>(
            predicate: #Predicate { $0.movieId == id }
        )
        if let entity = try context.fetch(descriptor).first {
            context.delete(entity)
            try context.save()
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
