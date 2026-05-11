import SwiftUI
import IngressoDomain
import IngressoPresentation
import IngressoMock

public struct MovieDetailScreen: View {
    let viewModel: MovieDetailViewModel
    @Environment(FavoritesViewModel.self) private var favoritesViewModel

    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
    }

    private var movie: IngressoMovie { viewModel.movie }

    public var body: some View {
        List {
            headerSection
            genresSection
            metadataSection
            synopsisSection
            castSection
            directorSection
            contentRatingSection
            distributorSection
            trailersSection
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        .toolbarVisibility(.hidden, for: .tabBar)
        #endif
        .navigationTitle(movie.title)
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        favoritesViewModel.toggle(movie)
                    }
                } label: {
                    Image(systemName: favoritesViewModel.isFavorite(movie) ? "heart.fill" : "heart")
                        .foregroundStyle(favoritesViewModel.isFavorite(movie) ? IngressoColors.destructive : .secondary)
                        .symbolEffect(.bounce, value: favoritesViewModel.isFavorite(movie))
                }
            }
            #endif
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        Section {
            ZStack(alignment: .bottomLeading) {
                IngressoBannerImage(movie: movie, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                HStack(spacing: IngressoSpacing.sm) {
                    if movie.inPreSale {
                        IngressoPreSaleBadge()
                    }
                    if let rating = movie.contentRating {
                        IngressoContentRatingBadge(rating: rating)
                    }
                }
                .padding(.leading, 22)
                .padding(.bottom, 16)
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
    }

    // MARK: - Genres

    @ViewBuilder
    private var genresSection: some View {
        if !movie.genres.isEmpty {
            Section {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: IngressoSpacing.sm) {
                        ForEach(movie.genres, id: \.self) { genre in
                            Text(genre)
                                .font(.caption.bold())
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(.ultraThinMaterial, in: Capsule())
                        }
                    }
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            } header: {
                Label("Gêneros", systemImage: "theatermasks.fill")
            }
        }
    }

    // MARK: - Metadata

    @ViewBuilder
    private var metadataSection: some View {
        let hasMetadata = movie.premiereDate != nil || !movie.duration.isEmpty || !movie.countryOrigin.isEmpty
        if hasMetadata {
            Section {
                if let premiereDate = movie.premiereDate {
                    HStack {
                        Label("Estreia", systemImage: "calendar")
                        Spacer()
                        Text("\(premiereDate.dayAndMonth)/\(premiereDate.year)")
                            .foregroundStyle(.secondary)
                    }
                }
                if !movie.duration.isEmpty {
                    HStack {
                        Label("Duração", systemImage: "clock")
                        Spacer()
                        Text("\(movie.duration) min")
                            .foregroundStyle(.secondary)
                    }
                }
                if !movie.countryOrigin.isEmpty {
                    HStack {
                        Label("País", systemImage: "globe")
                        Spacer()
                        Text(movie.countryOrigin)
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Label("Informações", systemImage: "info.circle.fill")
            }
        }
    }

    // MARK: - Synopsis

    @ViewBuilder
    private var synopsisSection: some View {
        if !movie.synopsis.isEmpty {
            Section {
                Text(movie.synopsis)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineSpacing(4)
            } header: {
                Label("Sinopse", systemImage: "text.alignleft")
            }
        }
    }

    // MARK: - Cast

    @ViewBuilder
    private var castSection: some View {
        if !movie.cast.isEmpty {
            Section {
                Text(movie.cast)
                    .font(.body)
                    .foregroundStyle(.secondary)
            } header: {
                Label("Elenco", systemImage: "person.3.fill")
            }
        }
    }

    // MARK: - Director

    @ViewBuilder
    private var directorSection: some View {
        if !movie.director.isEmpty {
            Section {
                Text(movie.director)
                    .font(.body)
                    .foregroundStyle(.secondary)
            } header: {
                Label("Direção", systemImage: "megaphone.fill")
            }
        }
    }

    // MARK: - Content Rating

    @ViewBuilder
    private var contentRatingSection: some View {
        if !movie.ratingDescriptors.isEmpty {
            Section {
                FlowLayout(spacing: IngressoSpacing.sm) {
                    ForEach(movie.ratingDescriptors, id: \.self) { descriptor in
                        Text(descriptor)
                            .font(.caption)
                            .bold()
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .foregroundStyle(Color.accentColor)
                            .background(Color.accentColor.opacity(0.1), in: Capsule())
                    }
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            } header: {
                Label("Conteúdo", systemImage: "exclamationmark.triangle.fill")
            }
        }
    }

    // MARK: - Distributor

    @ViewBuilder
    private var distributorSection: some View {
        if !movie.distributor.isEmpty {
            Section {
                Text(movie.distributor)
                    .font(.body)
                    .foregroundStyle(.secondary)
            } header: {
                Label("Distribuição", systemImage: "building.2.fill")
            }
        }
    }

    // MARK: - Trailers

    @ViewBuilder
    private var trailersSection: some View {
        if !movie.trailers.isEmpty {
            Section {
                ForEach(Array(movie.trailers.enumerated()), id: \.offset) { index, trailer in
                    Link(destination: trailer.url) {
                        HStack {
                            Image(systemName: "play.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.primary)

                            VStack(alignment: .leading) {
                                Text("Trailer \(index + 1)")
                                    .font(.subheadline.bold())
                                Text(trailer.type)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            } header: {
                Label("Trailers", systemImage: "play.rectangle.fill")
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailScreen(
            viewModel: IngressoPresentationFactory().makeMovieDetailViewModel(
                movie: IngressoFixtures.makeMovie(
                    title: "Mortal Kombat 2",
                    synopsis: "Os heróis do Reino da Terra lutam para salvar o universo.",
                    cast: "Lewis Tan, Jessica McNamee",
                    director: "Simon McQuoid",
                    genres: ["Ação", "Fantasia", "Aventura"],
                    inPreSale: true,
                    trailers: [
                        IngressoTrailer(
                            type: "Trailer Oficial",
                            url: URL(string: "https://youtube.com/watch?v=test")!,
                            embeddedURL: nil
                        )
                    ],
                    ratingDescriptors: ["Violência", "Linguagem imprópria"]
                )
            )
        )
    }
    .environment(IngressoPresentationFactory().makeFavoritesViewModel(repository: MockFavoritesRepository()))
}
