public struct RatingDetailsDTO: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let label: String
    public let displayName: String
    public let description: String
    public let color: String
}
