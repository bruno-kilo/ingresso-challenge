import Foundation

public protocol MovieEntityProtocol: AnyObject {
    var movieId: String { get set }
    var title: String { get set }
    var originalTitle: String { get set }
    var synopsis: String { get set }
    var cast: String { get set }
    var director: String { get set }
    var genres: [String] { get set }
    var posterURLString: String? { get set }
    var horizontalPosterURLString: String? { get set }
    var premiereDateLocal: Date? { get set }
    var premiereDayAndMonth: String? { get set }
    var premiereDayOfWeek: String? { get set }
    var premiereYear: String? { get set }
    var contentRatingId: Int? { get set }
    var contentRatingName: String? { get set }
    var contentRatingLabel: String? { get set }
    var contentRatingDisplayName: String? { get set }
    var contentRatingDescription: String? { get set }
    var contentRatingColor: String? { get set }
    var duration: String { get set }
    var inPreSale: Bool { get set }
    var isPlaying: Bool { get set }
    var isComingSoon: Bool { get set }
    var siteURLString: String? { get set }
    var distributor: String { get set }
    var countryOrigin: String { get set }
    var ratingDescriptors: [String] { get set }
}
