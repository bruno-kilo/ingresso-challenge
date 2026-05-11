import SwiftUI

struct IngressoAsyncImage: View {
    let url: URL?
    var aspectRatio: CGFloat? = 2/3
    var contentMode: ContentMode = .fill
    var cornerRadius: CGFloat = 12

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(aspectRatio, contentMode: contentMode)
            case .failure:
                placeholder
            case .empty:
                loadingView
            @unknown default:
                placeholder
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    private var placeholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.quaternary)
            Image(systemName: "film")
                .font(.title2)
                .foregroundStyle(.secondary)
        }
        .aspectRatio(aspectRatio, contentMode: .fill)
    }

    private var loadingView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.quaternary)
            ProgressView()
        }
        .aspectRatio(aspectRatio, contentMode: .fill)
    }
}

#Preview {
    IngressoAsyncImage(url: nil)
        .frame(width: 140)
        .padding()
}
