import Foundation
import IngressoDomain
import IngressoInfrastructure

public enum MovieEntityMapper {
    public static func toDomain(_ entity: some MovieEntityProtocol) -> IngressoMovie {
        let premiereDate: IngressoPremiereDate? = if let day = entity.premiereDayAndMonth,
            let week = entity.premiereDayOfWeek,
            let year = entity.premiereYear {
            IngressoPremiereDate(
                localDate: entity.premiereDateLocal,
                dayAndMonth: day,
                dayOfWeek: week,
                year: year
            )
        } else {
            nil
        }

        let contentRating: IngressoContentRating? = if let id = entity.contentRatingId,
            let name = entity.contentRatingName,
            let label = entity.contentRatingLabel,
            let displayName = entity.contentRatingDisplayName,
            let description = entity.contentRatingDescription,
            let color = entity.contentRatingColor {
            IngressoContentRating(
                id: id,
                name: name,
                label: label,
                displayName: displayName,
                description: description,
                color: color
            )
        } else {
            nil
        }

        return IngressoMovie(
            id: entity.movieId,
            title: entity.title,
            originalTitle: entity.originalTitle,
            synopsis: entity.synopsis,
            cast: entity.cast,
            director: entity.director,
            genres: entity.genres,
            posterURL: entity.posterURLString.flatMap(URL.init(string:)),
            horizontalPosterURL: entity.horizontalPosterURLString.flatMap(URL.init(string:)),
            premiereDate: premiereDate,
            contentRating: contentRating,
            duration: entity.duration,
            inPreSale: entity.inPreSale,
            isPlaying: entity.isPlaying,
            isComingSoon: entity.isComingSoon,
            trailers: [],
            siteURL: entity.siteURLString.flatMap(URL.init(string:)),
            distributor: entity.distributor,
            countryOrigin: entity.countryOrigin,
            ratingDescriptors: entity.ratingDescriptors
        )
    }

    public static func updateEntity(_ entity: some MovieEntityProtocol, from movie: IngressoMovie) {
        entity.movieId = movie.id
        entity.title = movie.title
        entity.originalTitle = movie.originalTitle
        entity.synopsis = movie.synopsis
        entity.cast = movie.cast
        entity.director = movie.director
        entity.genres = movie.genres
        entity.posterURLString = movie.posterURL?.absoluteString
        entity.horizontalPosterURLString = movie.horizontalPosterURL?.absoluteString
        entity.premiereDateLocal = movie.premiereDate?.localDate
        entity.premiereDayAndMonth = movie.premiereDate?.dayAndMonth
        entity.premiereDayOfWeek = movie.premiereDate?.dayOfWeek
        entity.premiereYear = movie.premiereDate?.year
        entity.contentRatingId = movie.contentRating?.id
        entity.contentRatingName = movie.contentRating?.name
        entity.contentRatingLabel = movie.contentRating?.label
        entity.contentRatingDisplayName = movie.contentRating?.displayName
        entity.contentRatingDescription = movie.contentRating?.description
        entity.contentRatingColor = movie.contentRating?.color
        entity.duration = movie.duration
        entity.inPreSale = movie.inPreSale
        entity.isPlaying = movie.isPlaying
        entity.isComingSoon = movie.isComingSoon
        entity.siteURLString = movie.siteURL?.absoluteString
        entity.distributor = movie.distributor
        entity.countryOrigin = movie.countryOrigin
        entity.ratingDescriptors = movie.ratingDescriptors
    }
}
