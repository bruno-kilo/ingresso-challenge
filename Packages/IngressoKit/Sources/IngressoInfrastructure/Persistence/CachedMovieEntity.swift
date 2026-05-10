import Foundation
import SwiftData

@Model
public final class CachedMovieEntity: MovieEntityProtocol {
    @Attribute(.unique) public var movieId: String
    public var title: String
    public var originalTitle: String
    public var synopsis: String
    public var cast: String
    public var director: String
    public var genres: [String]
    public var posterURLString: String?
    public var horizontalPosterURLString: String?
    public var premiereDateLocal: Date?
    public var premiereDayAndMonth: String?
    public var premiereDayOfWeek: String?
    public var premiereYear: String?
    public var contentRatingId: Int?
    public var contentRatingName: String?
    public var contentRatingLabel: String?
    public var contentRatingDisplayName: String?
    public var contentRatingDescription: String?
    public var contentRatingColor: String?
    public var duration: String
    public var inPreSale: Bool
    public var isPlaying: Bool
    public var isComingSoon: Bool
    public var siteURLString: String?
    public var distributor: String
    public var countryOrigin: String
    public var ratingDescriptors: [String]
    public var cachedAt: Date

    public init(
        movieId: String,
        title: String,
        originalTitle: String,
        synopsis: String,
        cast: String,
        director: String,
        genres: [String],
        posterURLString: String?,
        horizontalPosterURLString: String?,
        premiereDateLocal: Date?,
        premiereDayAndMonth: String?,
        premiereDayOfWeek: String?,
        premiereYear: String?,
        contentRatingId: Int?,
        contentRatingName: String?,
        contentRatingLabel: String?,
        contentRatingDisplayName: String?,
        contentRatingDescription: String?,
        contentRatingColor: String?,
        duration: String,
        inPreSale: Bool,
        isPlaying: Bool,
        isComingSoon: Bool,
        siteURLString: String?,
        distributor: String,
        countryOrigin: String,
        ratingDescriptors: [String],
        cachedAt: Date = Date()
    ) {
        self.movieId = movieId
        self.title = title
        self.originalTitle = originalTitle
        self.synopsis = synopsis
        self.cast = cast
        self.director = director
        self.genres = genres
        self.posterURLString = posterURLString
        self.horizontalPosterURLString = horizontalPosterURLString
        self.premiereDateLocal = premiereDateLocal
        self.premiereDayAndMonth = premiereDayAndMonth
        self.premiereDayOfWeek = premiereDayOfWeek
        self.premiereYear = premiereYear
        self.contentRatingId = contentRatingId
        self.contentRatingName = contentRatingName
        self.contentRatingLabel = contentRatingLabel
        self.contentRatingDisplayName = contentRatingDisplayName
        self.contentRatingDescription = contentRatingDescription
        self.contentRatingColor = contentRatingColor
        self.duration = duration
        self.inPreSale = inPreSale
        self.isPlaying = isPlaying
        self.isComingSoon = isComingSoon
        self.siteURLString = siteURLString
        self.distributor = distributor
        self.countryOrigin = countryOrigin
        self.ratingDescriptors = ratingDescriptors
        self.cachedAt = cachedAt
    }
}
