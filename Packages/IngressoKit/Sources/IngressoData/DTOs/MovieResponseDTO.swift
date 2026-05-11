struct MovieResponseDTO: Decodable, Sendable {
    let items: [MovieDTO]
}
