import Foundation
import IngressoDomain
import IngressoInfrastructure

enum CachedMovieMapper {
    static func toEntity(_ movie: IngressoMovie) -> CachedMovieEntity {
        CachedMovieEntity(
            movieId: movie.id,
            title: movie.title,
            originalTitle: movie.originalTitle,
            synopsis: movie.synopsis,
            cast: movie.cast,
            director: movie.director,
            genres: movie.genres,
            posterURLString: movie.posterURL?.absoluteString,
            horizontalPosterURLString: movie.horizontalPosterURL?.absoluteString,
            premiereDateLocal: movie.premiereDate?.localDate,
            premiereDayAndMonth: movie.premiereDate?.dayAndMonth,
            premiereDayOfWeek: movie.premiereDate?.dayOfWeek,
            premiereYear: movie.premiereDate?.year,
            contentRatingId: movie.contentRating?.id,
            contentRatingName: movie.contentRating?.name,
            contentRatingLabel: movie.contentRating?.label,
            contentRatingDisplayName: movie.contentRating?.displayName,
            contentRatingDescription: movie.contentRating?.description,
            contentRatingColor: movie.contentRating?.color,
            duration: movie.duration,
            inPreSale: movie.inPreSale,
            isPlaying: movie.isPlaying,
            isComingSoon: movie.isComingSoon,
            siteURLString: movie.siteURL?.absoluteString,
            distributor: movie.distributor,
            countryOrigin: movie.countryOrigin,
            ratingDescriptors: movie.ratingDescriptors
        )
    }

    static func toDomain(_ entity: CachedMovieEntity) -> IngressoMovie {
        MovieEntityMapper.toDomain(entity)
    }
}
