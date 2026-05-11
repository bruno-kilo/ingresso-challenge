struct RatingDetailsDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let label: String
    let displayName: String
    let description: String
    let color: String
}
