import Foundation
import Observation
import OSLog
import IngressoDomain

@Observable
@MainActor
public final class SettingsViewModel {
    public private(set) var cacheByteCount: Int64 = 0
    public private(set) var isClearing = false

    private let cacheRepository: MovieCacheRepositoryProtocol
    private let logger = Logger(subsystem: "com.brunosantos.Ingresso", category: "Settings")

    init(cacheRepository: MovieCacheRepositoryProtocol) {
        self.cacheRepository = cacheRepository
    }

    public func loadCacheSize() {
        Task { @MainActor in
            do {
                let movies = try await cacheRepository.loadCachedMovies()
                let data = try JSONEncoder().encode(movies.map(CodableMovie.init))
                cacheByteCount = Int64(data.count)
            } catch {
                cacheByteCount = 0
                logger.error("❌ erro ao calcular cache: \(error.localizedDescription)")
            }
            logger.info("⚙️ cache: \(self.formattedCacheSize)")
        }
    }

    public func clearCache() async {
        logger.info("⚙️ limpando cache...")
        isClearing = true
        do {
            try await cacheRepository.clearCache()
        } catch {
            logger.error("❌ erro ao limpar cache: \(error.localizedDescription)")
        }
        cacheByteCount = 0
        isClearing = false
        logger.info("⚙️ cache limpo")
    }

    public var formattedCacheSize: String {
        ByteCountFormatter.string(fromByteCount: cacheByteCount, countStyle: .file)
    }
}

private struct CodableMovie: Encodable {
    let id: String
    let title: String
    let synopsis: String
    let genres: [String]
    let cast: String
    let director: String

    init(_ movie: IngressoMovie) {
        self.id = movie.id
        self.title = movie.title
        self.synopsis = movie.synopsis
        self.genres = movie.genres
        self.cast = movie.cast
        self.director = movie.director
    }
}
