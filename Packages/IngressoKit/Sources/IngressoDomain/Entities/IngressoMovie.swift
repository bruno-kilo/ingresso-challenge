import Foundation

public struct IngressoMovie: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let originalTitle: String
    public let synopsis: String
    public let cast: String
    public let director: String
    public let genres: [String]
    public let posterURL: URL?
    public let horizontalPosterURL: URL?
    public let premiereDate: IngressoPremiereDate?
    public let contentRating: IngressoContentRating?
    public let duration: String
    public let inPreSale: Bool
    public let isPlaying: Bool
    public let isComingSoon: Bool
    public let trailers: [IngressoTrailer]
    public let siteURL: URL?
    public let distributor: String
    public let countryOrigin: String
    public let ratingDescriptors: [String]

    public init(
        id: String,
        title: String,
        originalTitle: String,
        synopsis: String,
        cast: String,
        director: String,
        genres: [String],
        posterURL: URL?,
        horizontalPosterURL: URL?,
        premiereDate: IngressoPremiereDate?,
        contentRating: IngressoContentRating?,
        duration: String,
        inPreSale: Bool,
        isPlaying: Bool,
        isComingSoon: Bool,
        trailers: [IngressoTrailer],
        siteURL: URL?,
        distributor: String,
        countryOrigin: String,
        ratingDescriptors: [String]
    ) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.synopsis = synopsis
        self.cast = cast
        self.director = director
        self.genres = genres
        self.posterURL = posterURL
        self.horizontalPosterURL = horizontalPosterURL
        self.premiereDate = premiereDate
        self.contentRating = contentRating
        self.duration = duration
        self.inPreSale = inPreSale
        self.isPlaying = isPlaying
        self.isComingSoon = isComingSoon
        self.trailers = trailers
        self.siteURL = siteURL
        self.distributor = distributor
        self.countryOrigin = countryOrigin
        self.ratingDescriptors = ratingDescriptors
    }
}
