import Foundation
import IngressoDomain

public enum IngressoFixtures {
    public static func makeMovie(
        id: String = "1",
        title: String = "Filme Teste",
        originalTitle: String = "Test Movie",
        synopsis: String = "Sinopse do filme teste.",
        cast: String = "Ator 1, Ator 2",
        director: String = "Diretor Teste",
        genres: [String] = ["Ação"],
        posterURL: URL? = URL(string: "https://example.com/poster.jpg"),
        horizontalPosterURL: URL? = nil,
        premiereDate: IngressoPremiereDate? = IngressoPremiereDate(
            localDate: Date(timeIntervalSince1970: 1_800_000_000),
            dayAndMonth: "07/05",
            dayOfWeek: "quinta-feira",
            year: "2026"
        ),
        contentRating: IngressoContentRating? = IngressoContentRating(
            id: 5,
            name: "18 anos",
            label: "18",
            displayName: "18 anos",
            description: "Violência",
            color: "#000000"
        ),
        duration: String = "120",
        inPreSale: Bool = false,
        isPlaying: Bool = false,
        isComingSoon: Bool = true,
        trailers: [IngressoTrailer] = [],
        siteURL: URL? = URL(string: "https://www.ingresso.com/filme/teste"),
        distributor: String = "Distribuidora Teste",
        countryOrigin: String = "Brasil",
        ratingDescriptors: [String] = []
    ) -> IngressoMovie {
        IngressoMovie(
            id: id,
            title: title,
            originalTitle: originalTitle,
            synopsis: synopsis,
            cast: cast,
            director: director,
            genres: genres,
            posterURL: posterURL,
            horizontalPosterURL: horizontalPosterURL,
            premiereDate: premiereDate,
            contentRating: contentRating,
            duration: duration,
            inPreSale: inPreSale,
            isPlaying: isPlaying,
            isComingSoon: isComingSoon,
            trailers: trailers,
            siteURL: siteURL,
            distributor: distributor,
            countryOrigin: countryOrigin,
            ratingDescriptors: ratingDescriptors
        )
    }

    public static let sampleMovies: [IngressoMovie] = [
        makeMovie(id: "1", title: "Mortal Kombat 2", genres: ["Ação"], inPreSale: true),
        makeMovie(id: "2", title: "Filme Romântico", genres: ["Comédia Romântica"], inPreSale: false),
        makeMovie(id: "3", title: "Animação Kids", genres: ["Animação", "Família"], premiereDate: IngressoPremiereDate(
            localDate: Date(timeIntervalSince1970: 1_800_100_000),
            dayAndMonth: "15/05",
            dayOfWeek: "segunda-feira",
            year: "2026"
        ))
    ]
}
