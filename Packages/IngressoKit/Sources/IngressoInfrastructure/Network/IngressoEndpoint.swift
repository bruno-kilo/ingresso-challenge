import Foundation

public struct IngressoEndpoint: Sendable {
    public enum Method: String, Sendable {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }

    public let path: String
    public let method: Method
    public let headers: [String: String]
    public let queryItems: [URLQueryItem]
    public let body: Data?

    public init(
        path: String,
        method: Method = .get,
        headers: [String: String] = [:],
        queryItems: [URLQueryItem] = [],
        body: Data? = nil
    ) {
        self.path = path
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
    }
}
