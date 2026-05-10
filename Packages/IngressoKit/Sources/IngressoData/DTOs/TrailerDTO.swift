public struct TrailerDTO: Decodable, Sendable {
    public let type: String
    public let url: String
    public let embeddedUrl: String?
}
