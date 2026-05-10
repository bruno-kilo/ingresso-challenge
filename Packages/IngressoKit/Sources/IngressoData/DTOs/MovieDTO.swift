public struct MovieDTO: Decodable, Sendable {
    public let id: String
    public let title: String
    public let originalTitle: String
    public let type: String
    public let synopsis: String
    public let cast: String
    public let director: String
    public let genres: [String]
    public let imageFeatured: String?
    public let images: [ImageDTO]
    public let premiereDate: PremiereDateDTO?
    public let contentRating: String
    public let ratingDetails: RatingDetailsDTO?
    public let duration: String
    public let inPreSale: Bool
    public let isPlaying: Bool
    public let isComingSoon: Bool
    public let trailers: [TrailerDTO]
    public let siteURL: String
    public let distributor: String
    public let countryOrigin: String
    public let ratingDescriptors: [String]
}
