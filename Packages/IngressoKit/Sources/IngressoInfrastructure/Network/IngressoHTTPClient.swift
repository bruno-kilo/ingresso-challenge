import Foundation
import OSLog

public actor IngressoHTTPClient: HTTPClientProtocol {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let logger = Logger(subsystem: "com.escaleira.Ingresso", category: "HTTP")
    private let maxRetries: Int

    public init(
        baseURL: URL,
        configuration: URLSessionConfiguration = .default,
        maxRetries: Int = 2
    ) {
        self.baseURL = baseURL
        self.session = URLSession(configuration: configuration)
        self.decoder = JSONDecoder()
        self.maxRetries = maxRetries
    }

    public func request<T: Decodable & Sendable>(
        _ endpoint: IngressoEndpoint,
        as type: T.Type
    ) async throws -> T {
        let urlRequest: URLRequest
        do {
            urlRequest = try buildRequest(for: endpoint)
        } catch {
            throw IngressoNetworkError.badURL
        }

        var lastError: IngressoNetworkError = .unknown(statusCode: 0)

        for attempt in 0...maxRetries {
            if attempt > 0 {
                let delay = UInt64(pow(2.0, Double(attempt - 1))) * 1_000_000_000
                try await Task.sleep(nanoseconds: delay)
                logger.debug("↻ retry \(attempt)/\(self.maxRetries) \(endpoint.path)")
            }

            do {
                return try await performRequest(urlRequest, endpoint: endpoint, as: type)
            } catch let error as IngressoNetworkError {
                lastError = error
                if !error.isRetryable || attempt == maxRetries { throw error }
            }
        }

        throw lastError
    }

    private func performRequest<T: Decodable & Sendable>(
        _ urlRequest: URLRequest,
        endpoint: IngressoEndpoint,
        as type: T.Type
    ) async throws -> T {
        logger.debug("→ \(endpoint.method.rawValue) \(endpoint.path)")

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch let error as URLError {
            throw mapURLError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw IngressoNetworkError.unknown(statusCode: 0)
        }

        logger.debug("← \(httpResponse.statusCode) \(endpoint.path)")

        let statusCode = httpResponse.statusCode
        guard (200...299).contains(statusCode) else {
            throw mapStatusCode(statusCode)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw IngressoNetworkError.decodingFailed
        }
    }

    func buildRequest(for endpoint: IngressoEndpoint) throws -> URLRequest {
        var components = URLComponents(
            url: baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: true
        )

        if !endpoint.queryItems.isEmpty {
            components?.queryItems = endpoint.queryItems
        }

        guard let url = components?.url else {
            throw IngressoNetworkError.badURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        for (key, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let body = endpoint.body {
            request.httpBody = body
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }

        return request
    }

    private func mapStatusCode(_ code: Int) -> IngressoNetworkError {
        switch code {
        case 429:
            .rateLimited
        case 400...499:
            .clientError(statusCode: code)
        case 500...599:
            .serverError(statusCode: code)
        default:
            .unknown(statusCode: code)
        }
    }

    private func mapURLError(_ error: URLError) -> IngressoNetworkError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
            .noConnection
        case .timedOut:
            .timeout
        default:
            .unknown(statusCode: error.code.rawValue)
        }
    }
}
