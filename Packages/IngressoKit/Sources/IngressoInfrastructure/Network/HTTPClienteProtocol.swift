import Foundation

public protocol HTTPClientProtocol: Sendable {
    func request<T: Decodable & Sendable>(
        _ endpoint: IngressoEndpoint,
        as type: T.Type
    ) async throws -> T
}
