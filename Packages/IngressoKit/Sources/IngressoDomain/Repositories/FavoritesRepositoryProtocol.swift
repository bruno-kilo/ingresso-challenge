import Foundation

public protocol FavoritesRepositoryProtocol: Sendable {
    func fetchAll() async throws -> [IngressoMovie]
    func add(_ movie: IngressoMovie) async throws
    func remove(byId id: String) async throws
    func contains(id: String) async throws -> Bool
}
