public struct MovieResponseDTO: Decodable, Sendable {
    public let items: [MovieDTO]
}
