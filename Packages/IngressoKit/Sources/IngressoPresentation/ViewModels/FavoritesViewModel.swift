import Foundation
import Observation
import IngressoDomain

@Observable
@MainActor
public final class FavoritesViewModel {
    public private(set) var favorites: [IngressoMovie] = []

    private let repository: FavoritesRepositoryProtocol

    public init(repository: FavoritesRepositoryProtocol) {
        self.repository = repository
    }

    private var hasLoaded = false

    public func loadFavorites() async {
        guard !hasLoaded else { return }
        hasLoaded = true
        do {
            favorites = try await repository.fetchAll()
        } catch {
            favorites = []
        }
    }

    public func isFavorite(_ movie: IngressoMovie) -> Bool {
        favorites.contains { $0.id == movie.id }
    }

    public func toggle(_ movie: IngressoMovie) {
        if let index = favorites.firstIndex(where: { $0.id == movie.id }) {
            favorites.remove(at: index)
            Task { [repository] in try? await repository.remove(byId: movie.id) }
        } else {
            favorites.append(movie)
            Task { [repository] in try? await repository.add(movie) }
        }
    }
}
