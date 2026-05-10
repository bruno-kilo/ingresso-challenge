import SwiftUI
import IngressoDomain

struct MoviePosterCard: View {
    let movie: IngressoMovie

    var body: some View {
        VStack(alignment: .leading, spacing: IngressoSpacing.sm) {
            IngressoAsyncImage(url: movie.posterURL)
                .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
                .overlay(alignment: .topTrailing) {
                    if movie.inPreSale {
                        IngressoPreSaleBadge()
                            .padding(IngressoSpacing.sm)
                    }
                }
                .overlay(alignment: .bottomLeading) {
                    if let rating = movie.contentRating {
                        IngressoContentRatingBadge(rating: rating)
                            .padding(IngressoSpacing.sm)
                    }
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(movie.title)
                    .font(.footnote.bold())
                    .foregroundStyle(.primary)

                if let premiereDate = movie.premiereDate {
                    Text(premiereDate.dayAndMonth)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .lineLimit(1)
        }
        .pressable()
    }
}
