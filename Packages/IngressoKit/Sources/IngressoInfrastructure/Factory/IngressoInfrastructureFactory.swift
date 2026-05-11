import Foundation

public struct IngressoInfrastructureFactory {
    public init() {}

    public func makeClient(
        baseURL: URL?,
        configuration: URLSessionConfiguration = .default,
        maxRetries: Int = 2
    ) -> HTTPClientProtocol {
        IngressoHTTPClient(baseURL: baseURL, configuration: configuration)
    }

    public func makeNetworkMonitor() -> NetworkMonitor {
        NetworkMonitor()
    }
}
