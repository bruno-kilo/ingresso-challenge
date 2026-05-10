import Foundation
import IngressoDomain

public enum MovieMapper {
    public static func toDomain(_ dto: MovieDTO) -> IngressoMovie {
        let posterURL = findImageURL(in: dto.images, type: "PosterPortrait")
            ?? dto.imageFeatured.flatMap(URL.init(string:))

        let horizontalPosterURL = findImageURL(in: dto.images, type: "PosterHorizontal")
            ?? dto.imageFeatured.flatMap(URL.init(string:))

        return IngressoMovie(
            id: dto.id,
            title: dto.title,
            originalTitle: dto.originalTitle,
            synopsis: dto.synopsis,
            cast: dto.cast,
            director: dto.director,
            genres: dto.genres,
            posterURL: posterURL,
            horizontalPosterURL: horizontalPosterURL,
            premiereDate: dto.premiereDate.map(mapPremiereDate),
            contentRating: dto.ratingDetails.map(mapContentRating),
            duration: dto.duration,
            inPreSale: dto.inPreSale,
            isPlaying: dto.isPlaying,
            isComingSoon: dto.isComingSoon,
            trailers: dto.trailers.compactMap(mapTrailer),
            siteURL: URL(string: dto.siteURL),
            distributor: dto.distributor,
            countryOrigin: dto.countryOrigin,
            ratingDescriptors: dto.ratingDescriptors
        )
    }

    public static func toDomain(_ dtos: [MovieDTO]) -> [IngressoMovie] {
        dtos.map(toDomain)
    }

    private static func mapPremiereDate(_ dto: PremiereDateDTO) -> IngressoPremiereDate {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = dto.localDate.flatMap { formatter.date(from: $0) }

        return IngressoPremiereDate(
            localDate: date,
            dayAndMonth: dto.dayAndMonth,
            dayOfWeek: dto.dayOfWeek,
            year: dto.year
        )
    }

    private static func mapContentRating(_ dto: RatingDetailsDTO) -> IngressoContentRating {
        IngressoContentRating(
            id: dto.id,
            name: dto.name,
            label: dto.label,
            displayName: dto.displayName,
            description: dto.description,
            color: dto.color
        )
    }

    private static func mapTrailer(_ dto: TrailerDTO) -> IngressoTrailer? {
        guard let url = URL(string: dto.url) else { return nil }
        let embeddedURL = dto.embeddedUrl
            .flatMap { $0.hasPrefix("//") ? "https:\($0)" : $0 }
            .flatMap(URL.init(string:))

        return IngressoTrailer(type: dto.type, url: url, embeddedURL: embeddedURL)
    }

    private static func findImageURL(in images: [ImageDTO], type: String) -> URL? {
        images.first { $0.type == type }.flatMap { URL(string: $0.url) }
    }
}
