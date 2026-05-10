import Testing
import Foundation
@testable import IngressoInfrastructure

@Suite("IngressoInfrastructure")
struct IngressoInfrastructureTests {

    // MARK: - IngressoNetworkError

    @Test("Erros retryable são identificados corretamente")
    func retryableErrors() {
        #expect(IngressoNetworkError.noConnection.isRetryable == true)
        #expect(IngressoNetworkError.timeout.isRetryable == true)
        #expect(IngressoNetworkError.serverError(statusCode: 500).isRetryable == true)
        #expect(IngressoNetworkError.rateLimited.isRetryable == true)
    }

    @Test("Erros não-retryable são identificados corretamente")
    func nonRetryableErrors() {
        #expect(IngressoNetworkError.badURL.isRetryable == false)
        #expect(IngressoNetworkError.clientError(statusCode: 404).isRetryable == false)
        #expect(IngressoNetworkError.decodingFailed.isRetryable == false)
        #expect(IngressoNetworkError.unknown(statusCode: 999).isRetryable == false)
    }

    @Test("NetworkError fornece systemImage apropriado")
    func networkErrorSystemImages() {
        #expect(IngressoNetworkError.noConnection.systemImage == "wifi.slash")
        #expect(IngressoNetworkError.timeout.systemImage == "clock.badge.exclamationmark")
        #expect(IngressoNetworkError.serverError(statusCode: 503).systemImage == "server.rack")
        #expect(IngressoNetworkError.rateLimited.systemImage == "hourglass")
        #expect(IngressoNetworkError.badURL.systemImage == "exclamationmark.triangle")
    }

    // MARK: - IngressoEndpoint

    @Test("Endpoint inicializa com valores padrão corretos")
    func endpointDefaultValues() {
        let endpoint = IngressoEndpoint(path: "/v0/movies")

        #expect(endpoint.path == "/v0/movies")
        #expect(endpoint.method == .get)
        #expect(endpoint.headers.isEmpty)
        #expect(endpoint.queryItems.isEmpty)
        #expect(endpoint.body == nil)
    }

    // MARK: - IngressoHTTPClient buildRequest

    @Test("HTTPClient constrói request com query items e headers")
    func httpClientBuildsRequestCorrectly() async throws {
        let client = IngressoHTTPClient(
            baseURL: URL(string: "https://api.example.com")!,
            maxRetries: 0
        )
        let endpoint = IngressoEndpoint(
            path: "/movies",
            method: .post,
            headers: ["Authorization": "Bearer token"],
            queryItems: [URLQueryItem(name: "page", value: "1")],
            body: Data("{\"key\":\"value\"}".utf8)
        )

        let request = try await client.buildRequest(for: endpoint)

        #expect(request.httpMethod == "POST")
        #expect(request.url?.query?.contains("page=1") == true)
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer token")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(request.httpBody != nil)
    }
}
