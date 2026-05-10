import Foundation
import IngressoInfrastructure

public final class MockHTTPClient: HTTPClientProtocol, @unchecked Sendable {
    public var data: Data = Data()
    public var error: Error?

    public init() {}

    public func request<T: Decodable & Sendable>(
        _ endpoint: IngressoEndpoint,
        as type: T.Type
    ) async throws -> T {
        if let error { throw error }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
