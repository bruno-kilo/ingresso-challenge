import IngressoDomain

public enum IngressoRoute: Hashable, Sendable, Identifiable {
    case movieDetail(IngressoMovie)

    public var id: String {
        switch self {
        case .movieDetail(let movie): "movieDetail-\(movie.id)"
        }
    }
}
