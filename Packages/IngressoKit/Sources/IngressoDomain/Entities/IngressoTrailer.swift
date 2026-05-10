import Foundation

public struct IngressoTrailer: Hashable, Sendable {
    public let type: String
    public let url: URL
    public let embeddedURL: URL?

    public init(type: String, url: URL, embeddedURL: URL?) {
        self.type = type
        self.url = url
        self.embeddedURL = embeddedURL
    }
}
