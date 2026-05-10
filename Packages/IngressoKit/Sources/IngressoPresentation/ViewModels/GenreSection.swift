public struct GenreSection: Sendable {
    public let title: String
    public let genres: [String]

    public static let featured: [GenreSection] = [
        GenreSection(title: "Ação", genres: ["Ação"]),
        GenreSection(title: "Animação", genres: ["Animação"]),
        GenreSection(title: "Drama", genres: ["Drama"]),
        GenreSection(title: "Comédia", genres: ["Comédia"]),
        GenreSection(title: "Terror & Suspense", genres: ["Terror", "Suspense"]),
    ]
}
