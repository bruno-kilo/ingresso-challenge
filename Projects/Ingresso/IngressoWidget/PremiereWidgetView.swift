import SwiftUI
import WidgetKit

struct PremiereWidgetView: View {
    let entry: PremiereEntry

    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget
        case .systemMedium:
            mediumWidget
        case .systemLarge:
            largeWidget
        default:
            smallWidget
        }
    }

    // MARK: - Small

    private var smallWidget: some View {
        GeometryReader { geo in
            if let movie = entry.movies.first {
                ZStack(alignment: .bottomLeading) {
                    if let uiImage = movie.posterImage {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                    } else {
                        Color(.secondarySystemBackground)
                    }

                    LinearGradient(
                        colors: [.clear, .black.opacity(0.9)],
                        startPoint: .center,
                        endPoint: .bottom
                    )

                    VStack(alignment: .leading, spacing: 4) {
                        Text(movie.title)
                            .font(.subheadline.bold())
                            .lineLimit(2)

                        HStack(spacing: 4) {
                            if let date = movie.dayAndMonth {
                                Text(date)
                                    .font(.caption2)
                            }
                            if movie.inPreSale {
                                Image(systemName: "ticket.fill")
                                    .font(.caption2)
                                    .foregroundStyle(.orange)
                            }
                        }
                        .foregroundStyle(.white.opacity(0.8))
                    }
                    .foregroundStyle(.white)
                    .padding(16)
                }
            } else {
                emptyState
            }
        }
        .clipShape(ContainerRelativeShape())
    }

    // MARK: - Medium

    private var mediumWidget: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Próximas Estreias", systemImage: "film")
                .font(.caption.bold())
                .foregroundStyle(.secondary)

            if entry.movies.isEmpty {
                emptyState
            } else {
                HStack(spacing: 10) {
                    ForEach(entry.movies.prefix(3)) { movie in
                        movieCard(movie)
                    }
                }
            }
        }
        .padding(16)
    }

    // MARK: - Large

    private var largeWidget: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Próximas Estreias", systemImage: "film")
                .font(.caption.bold())
                .foregroundStyle(.secondary)

            if entry.movies.isEmpty {
                emptyState
            } else {
                VStack(spacing: 6) {
                    ForEach(entry.movies.prefix(5)) { movie in
                        movieRow(movie)
                        if movie.id != entry.movies.prefix(5).last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
        .padding(16)
    }

    // MARK: - Components

    private func movieCard(_ movie: WidgetMovie) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if let uiImage = movie.posterImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            } else {
                RoundedRectangle(cornerRadius: 6)
                    .fill(.quaternary)
                    .frame(height: 80)
            }

            Text(movie.title)
                .font(.caption2.bold())
                .lineLimit(2)

            if let date = movie.dayAndMonth {
                Text(date)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func movieRow(_ movie: WidgetMovie) -> some View {
        HStack(spacing: 10) {
            if let uiImage = movie.posterImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 52)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.quaternary)
                    .frame(width: 36, height: 52)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(movie.title)
                    .font(.caption.bold())
                    .lineLimit(1)

                if !movie.genres.isEmpty {
                    Text(movie.genres.prefix(2).joined(separator: " · "))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                if let date = movie.dayAndMonth {
                    Text(date)
                        .font(.caption2)
                        .foregroundStyle(.tint)
                }
            }

            Spacer(minLength: 0)

            if movie.inPreSale {
                Image(systemName: "ticket.fill")
                    .font(.caption2)
                    .foregroundStyle(.orange)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 4) {
            Spacer()
            Image(systemName: "film.stack")
                .font(.title3)
                .foregroundStyle(.secondary)
            Text("Sem estreias")
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
