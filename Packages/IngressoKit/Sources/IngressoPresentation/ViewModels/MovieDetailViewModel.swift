import Observation
import IngressoDomain

@Observable
@MainActor
public final class MovieDetailViewModel {
    public let movie: IngressoMovie

    init(movie: IngressoMovie) {
        self.movie = movie
    }
}
