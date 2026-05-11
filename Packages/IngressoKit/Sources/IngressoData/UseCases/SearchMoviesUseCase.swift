import OSLog
import IngressoDomain

struct SearchMoviesUseCase: SearchMoviesUseCaseProtocol {
    private let logger = Logger(subsystem: "com.brunosantos.Ingresso", category: "Search")

    func execute(query: String, in movies: [IngressoMovie]) -> [IngressoMovie] {
        let lowercasedQuery = query.lowercased()
        let results = movies.filter { movie in
            movie.title.lowercased().contains(lowercasedQuery)
            || movie.originalTitle.lowercased().contains(lowercasedQuery)
            || movie.director.lowercased().contains(lowercasedQuery)
            || movie.genres.contains { $0.lowercased().contains(lowercasedQuery) }
        }
        logger.debug("🔍 busca \"\(query)\" → \(results.count)/\(movies.count) resultados")
        return results
    }
}
