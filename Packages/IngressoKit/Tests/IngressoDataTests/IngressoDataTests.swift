import Testing
import Foundation
@testable import IngressoData
import IngressoDomain
import IngressoInfrastructure
import IngressoMock

@Suite("IngressoData")
struct IngressoDataTests {

    // MARK: - MovieMapper

    @Test("MovieMapper converte DTO para domínio corretamente")
    func movieMapperConvertsDTOToDomain() {
        let dto = makeDTO(id: "123", title: "Filme Teste", director: "Diretor X")

        let movie = MovieMapper.toDomain(dto)

        #expect(movie.id == "123")
        #expect(movie.title == "Filme Teste")
        #expect(movie.director == "Diretor X")
        #expect(movie.genres == ["Ação"])
        #expect(movie.inPreSale == true)
    }

    @Test("MovieMapper mapeia URL do poster portrait a partir de images")
    func movieMapperSelectsPosterPortraitImage() {
        let dto = makeDTO(
            images: [
                ImageDTO(url: "https://example.com/horizontal.jpg", type: "PosterHorizontal"),
                ImageDTO(url: "https://example.com/portrait.jpg", type: "PosterPortrait")
            ]
        )

        let movie = MovieMapper.toDomain(dto)

        #expect(movie.posterURL?.absoluteString == "https://example.com/portrait.jpg")
        #expect(movie.horizontalPosterURL?.absoluteString == "https://example.com/horizontal.jpg")
    }

    @Test("MovieMapper mapeia premiereDate com ISO8601")
    func movieMapperParsesPremiereDate() {
        let premiereDateDTO = PremiereDateDTO(
            localDate: "2026-05-07T00:00:00.000Z",
            isToday: false,
            dayOfWeek: "quinta-feira",
            dayAndMonth: "07/05",
            hour: "00:00",
            year: "2026"
        )
        let dto = makeDTO(premiereDate: premiereDateDTO)

        let movie = MovieMapper.toDomain(dto)

        #expect(movie.premiereDate != nil)
        #expect(movie.premiereDate?.dayAndMonth == "07/05")
        #expect(movie.premiereDate?.year == "2026")
        #expect(movie.premiereDate?.localDate != nil)
    }

    @Test("MovieMapper mapeia trailer com URL válida e descarta inválida")
    func movieMapperMapsTrailersCorrectly() {
        let trailers = [
            TrailerDTO(type: "YouTube", url: "https://youtube.com/watch?v=abc", embeddedUrl: "//youtube.com/embed/abc"),
            TrailerDTO(type: "Invalid", url: "", embeddedUrl: nil)
        ]
        let dto = makeDTO(trailers: trailers)

        let movie = MovieMapper.toDomain(dto)

        #expect(movie.trailers.count == 1)
        #expect(movie.trailers[0].type == "YouTube")
        #expect(movie.trailers[0].url.absoluteString == "https://youtube.com/watch?v=abc")
        #expect(movie.trailers[0].embeddedURL?.absoluteString == "https://youtube.com/embed/abc")
    }

    // MARK: - RemoteMovieRepository

    @Test("RemoteMovieRepository decodifica resposta da API corretamente")
    func remoteMovieRepositoryDecodesResponse() async throws {
        let mockClient = MockHTTPClient()
        let responseJSON = """
        {
            "items": [{
                "id": "99",
                "title": "Test",
                "originalTitle": "Test Original",
                "type": "Movie",
                "synopsis": "Synopsis",
                "cast": "Actor",
                "director": "Director",
                "genres": ["Drama"],
                "imageFeatured": null,
                "images": [],
                "premiereDate": null,
                "contentRating": "14",
                "ratingDetails": null,
                "duration": "90",
                "inPreSale": false,
                "isPlaying": true,
                "isComingSoon": false,
                "trailers": [],
                "siteURL": "https://ingresso.com/filme/test",
                "distributor": "Dist",
                "countryOrigin": "US",
                "ratingDescriptors": []
            }]
        }
        """
        mockClient.data = Data(responseJSON.utf8)
        let repository = RemoteMovieRepository(client: mockClient)

        let movies = try await repository.fetchComingSoonMovies()

        #expect(movies.count == 1)
        #expect(movies[0].id == "99")
        #expect(movies[0].title == "Test")
        #expect(movies[0].isPlaying == true)
    }

    // MARK: - Helpers

    private func makeDTO(
        id: String = "1",
        title: String = "Filme",
        director: String = "Diretor",
        images: [ImageDTO] = [],
        premiereDate: PremiereDateDTO? = nil,
        trailers: [TrailerDTO] = []
    ) -> MovieDTO {
        MovieDTO(
            id: id,
            title: title,
            originalTitle: "Original Title",
            type: "Movie",
            synopsis: "Uma sinopse",
            cast: "Ator 1",
            director: director,
            genres: ["Ação"],
            imageFeatured: "https://example.com/featured.jpg",
            images: images,
            premiereDate: premiereDate,
            contentRating: "14",
            ratingDetails: nil,
            duration: "120",
            inPreSale: true,
            isPlaying: false,
            isComingSoon: true,
            trailers: trailers,
            siteURL: "https://ingresso.com/filme/teste",
            distributor: "Distributor",
            countryOrigin: "BR",
            ratingDescriptors: []
        )
    }
}
