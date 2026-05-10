import WidgetKit
import SwiftUI
import IngressoDomain
import IngressoData
import IngressoInfrastructure

struct WidgetMovie: Identifiable, Sendable {
    let id: String
    let title: String
    let genres: [String]
    let dayAndMonth: String?
    let inPreSale: Bool
    let posterImage: UIImage?
}

struct PremiereEntry: TimelineEntry {
    let date: Date
    let movies: [WidgetMovie]

    static let placeholder = PremiereEntry(
        date: .now,
        movies: [
            WidgetMovie(id: "0", title: "Carregando...", genres: ["—"], dayAndMonth: nil, inPreSale: false, posterImage: nil),
        ]
    )
}

struct PremiereTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> PremiereEntry {
        .placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping @Sendable (PremiereEntry) -> Void) {
        if context.isPreview {
            completion(.placeholder)
            return
        }
        Task { @Sendable in
            let entry = await Self.fetchEntry()
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<PremiereEntry>) -> Void) {
        Task { @Sendable in
            let entry = await Self.fetchEntry()
            let nextUpdate = Calendar.current.date(byAdding: .hour, value: 2, to: .now)!
            completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
        }
    }

    private static func fetchEntry() async -> PremiereEntry {
        do {
            let client = IngressoHTTPClient(
                baseURL: URL(string: "https://api-content.ingresso.com")!,
                maxRetries: 1
            )
            let repo = RemoteMovieRepository(client: client)
            let movies = try await repo.fetchComingSoonMovies()
            let sorted = PremiereDateSortStrategy().sort(movies)
            let top = Array(sorted.prefix(6))

            let widgetMovies = await withTaskGroup(of: WidgetMovie.self) { group in
                for movie in top {
                    group.addTask { Self.makeWidgetMovie(from: movie) }
                }
                var result: [WidgetMovie] = []
                for await movie in group { result.append(movie) }
                return top.compactMap { original in result.first(where: { $0.id == original.id }) }
            }

            return PremiereEntry(date: .now, movies: widgetMovies)
        } catch {
            return PremiereEntry(date: .now, movies: [])
        }
    }

    private static func makeWidgetMovie(from movie: IngressoMovie) -> WidgetMovie {
        WidgetMovie(
            id: movie.id,
            title: movie.title,
            genres: movie.genres,
            dayAndMonth: movie.premiereDate?.dayAndMonth,
            inPreSale: movie.inPreSale,
            posterImage: downloadImage(from: movie.posterURL)
        )
    }

    private static func downloadImage(from url: URL?) -> UIImage? {
        guard let url else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
}

struct IngressoPremiereWidget: Widget {
    let kind = "IngressoPremiereWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PremiereTimelineProvider()) { entry in
            PremiereWidgetView(entry: entry)
                .containerBackground(for: .widget) { Color.clear }
        }
        .configurationDisplayName("Próximas Estreias")
        .description("Veja os próximos filmes em cartaz.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}
