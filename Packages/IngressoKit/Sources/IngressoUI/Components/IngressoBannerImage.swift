import SwiftUI
import IngressoDomain
import IngressoMock

struct IngressoBannerImage: View {
    let movie: IngressoMovie
    var height: CGFloat = 220

    private var isHorizontal: Bool {
        movie.horizontalPosterURL != nil
    }

    var body: some View {
        Group {
            if isHorizontal {
                horizontalLayout
            } else {
                portraitLayout
            }
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }

    private var horizontalLayout: some View {
        GeometryReader { geo in
            AsyncImage(url: movie.horizontalPosterURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                default:
                    placeholder
                        .frame(width: geo.size.width, height: geo.size.height)
                }
            }
        }
    }

    private var portraitLayout: some View {
        GeometryReader { geo in
            ZStack {
                AsyncImage(url: movie.posterURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                            .blur(radius: 24)
                            .saturation(1.2)
                            .overlay(Color.black.opacity(0.3))
                    default:
                        Rectangle().fill(.quaternary)
                            .frame(width: geo.size.width, height: geo.size.height)
                    }
                }

                AsyncImage(url: movie.posterURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: geo.size.height - 32)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .black.opacity(0.4), radius: 12, y: 4)
                    default:
                        EmptyView()
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    private var placeholder: some View {
        ZStack {
            Rectangle().fill(.quaternary)
            Image(systemName: "film")
                .font(.system(size: 36))
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    IngressoBannerImage(movie: IngressoFixtures.makeMovie(title: "Filme Teste"))
        .padding()
}
