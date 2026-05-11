import Foundation
import Observation
import OSLog
import IngressoDomain

@Observable
@MainActor
public final class FavoritesViewModel {
    public private(set) var favorites: [IngressoMovie] = []

    private let repository: FavoritesRepositoryProtocol
    private let logger = Logger(subsystem: "com.brunosantos.Ingresso", category: "Favorites")

    init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    private var hasLoaded = false

    public func loadFavorites() async {
        guard !hasLoaded else { return }
        hasLoaded = true
        do {
            favorites = try await repository.fetchAll()
            logger.info("❤️ \(self.favorites.count) favoritos carregados")
        } catch {
            favorites = []
            logger.error("❌ erro ao carregar favoritos: \(error.localizedDescription)")
        }
    }

    public func isFavorite(_ movie: IngressoMovie) -> Bool {
        favorites.contains { $0.id == movie.id }
    }

    public func toggle(_ movie: IngressoMovie) {
        if let index = favorites.firstIndex(where: { $0.id == movie.id }) {
            favorites.remove(at: index)
            logger.info("❤️ removido: \(movie.title)")
            Task { [repository] in try? await repository.remove(byId: movie.id) }
        } else {
            favorites.append(movie)
            logger.info("❤️ adicionado: \(movie.title)")
            Task { [repository] in try? await repository.add(movie) }
        }
    }
}
