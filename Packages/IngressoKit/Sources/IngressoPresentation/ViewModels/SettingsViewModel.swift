import Foundation
import Observation
import IngressoDomain

@Observable
@MainActor
public final class SettingsViewModel {
    public private(set) var cacheByteCount: Int64 = 0
    public private(set) var isClearing = false

    private let cacheRepository: MovieCacheRepositoryProtocol

    public init(cacheRepository: MovieCacheRepositoryProtocol) {
        self.cacheRepository = cacheRepository
    }

    public func loadCacheSize() {
        Task {
            let movies = (try? await cacheRepository.loadCachedMovies()) ?? []
            let data = try? JSONEncoder().encode(movies.map(CodableMovie.init))
            cacheByteCount = Int64(data?.count ?? 0)
        }
    }

    public func clearCache() async {
        isClearing = true
        try? await cacheRepository.clearCache()
        cacheByteCount = 0
        isClearing = false
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
