import SwiftUI
import IngressoDomain
import IngressoMock

struct PreSaleFeatureCard: View {
    let movie: IngressoMovie

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            IngressoBannerImage(movie: movie, height: 200)

            GradientOverlay(style: .bottomStrong)

            VStack(alignment: .leading, spacing: IngressoSpacing.xs) {
                HStack {
                    IngressoPreSaleBadge()
                    Spacer()
                    if let rating = movie.contentRating {
                        IngressoContentRatingBadge(rating: rating)
                    }
                }

                Spacer()

                Text(movie.title)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .lineLimit(2)

                HStack(spacing: IngressoSpacing.md) {
                    if let premiereDate = movie.premiereDate {
                        Label("Estreia \(premiereDate.dayAndMonth)", systemImage: "calendar")
                            .font(.caption.bold())
                            .foregroundStyle(.white.opacity(0.9))
                    }

                    if !movie.genres.isEmpty {
                        Text(movie.genres.prefix(2).joined(separator: " · "))
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
        .pressable(scale: 0.97)
    }
}

#Preview {
    PreSaleFeatureCard(movie: IngressoFixtures.makeMovie(title: "Thunderbolts", genres: ["Ação", "Aventura"], inPreSale: true))
        .padding()
}
