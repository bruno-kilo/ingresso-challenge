import SwiftUI
import IngressoDomain
import IngressoPresentation

struct MovieSection: View {
    let title: String
    let movies: [IngressoMovie]
    var showsRank: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: IngressoSpacing.sm) {
            Text(title)
                .font(.title3.bold())
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: IngressoSpacing.md) {
                    ForEach(Array(movies.enumerated()), id: \.element.id) { index, movie in
                        NavigationLink(value: IngressoRoute.movieDetail(movie)) {
                            if showsRank {
                                rankedCard(movie: movie, rank: index + 1)
                            } else {
                                MoviePosterCard(movie: movie)
                                    .frame(width: 140)
                            }
                        }
                        .buttonStyle(.plain)
                        .appearFromRight(delay: Double(index) * 0.05)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private func rankedCard(movie: IngressoMovie, rank: Int) -> some View {
        ZStack(alignment: .bottomTrailing) {
            MoviePosterCard(movie: movie)
                .frame(width: 120)
            
            Text("\(rank)")
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .blendMode(.difference)
                .padding(.bottom, 36)
                .padding(.trailing, 6)
        }
        .frame(width: 120)
    }
}
