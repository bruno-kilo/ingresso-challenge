struct TrailerDTO: Decodable, Sendable {
    let type: String
    let url: String
    let embeddedUrl: String?
}
