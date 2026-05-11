struct MovieDTO: Decodable, Sendable {
    let id: String
    let title: String
    let originalTitle: String
    let type: String
    let synopsis: String
    let cast: String
    let director: String
    let genres: [String]
    let imageFeatured: String?
    let images: [ImageDTO]
    let premiereDate: PremiereDateDTO?
    let contentRating: String
    let ratingDetails: RatingDetailsDTO?
    let duration: String
    let inPreSale: Bool
    let isPlaying: Bool
    let isComingSoon: Bool
    let trailers: [TrailerDTO]
    let siteURL: String
    let distributor: String
    let countryOrigin: String
    let ratingDescriptors: [String]
}
