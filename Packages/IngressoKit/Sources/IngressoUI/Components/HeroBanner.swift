import SwiftUI
import IngressoDomain
import IngressoPresentation

struct HeroBanner: View {
    let movie: IngressoMovie

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            IngressoBannerImage(movie: movie)

            GradientOverlay(style: .bottomFade)

            VStack(alignment: .leading, spacing: IngressoSpacing.xs) {
                if movie.inPreSale {
                    IngressoPreSaleBadge()
                }

                Text(movie.title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .lineLimit(2)

                HStack(spacing: IngressoSpacing.sm) {
                    if let premiereDate = movie.premiereDate {
                        Label(premiereDate.dayAndMonth, systemImage: "calendar")
                            .font(.caption)
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
        .shadow(color: .black.opacity(0.3), radius: 12, y: 6)
        .appearAnimation()
    }
}
