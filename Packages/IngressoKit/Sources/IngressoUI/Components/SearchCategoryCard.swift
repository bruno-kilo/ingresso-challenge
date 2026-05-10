import SwiftUI

enum SearchCategory: String, CaseIterable, Identifiable {
    case action = "Ação"
    case comedy = "Comédia"
    case drama = "Drama"
    case horror = "Terror"
    case animation = "Animação"
    case adventure = "Aventura"
    case thriller = "Suspense"
    case romance = "Romance"
    case scifi = "Ficção Científica"
    case documentary = "Documentário"

    var id: String { rawValue }
    var query: String { rawValue }

    var icon: String {
        switch self {
        case .action: "flame.fill"
        case .comedy: "face.smiling.fill"
        case .drama: "theatermasks.fill"
        case .horror: "moon.fill"
        case .animation: "sparkles"
        case .adventure: "map.fill"
        case .thriller: "eye.fill"
        case .romance: "heart.fill"
        case .scifi: "atom"
        case .documentary: "video.fill"
        }
    }

    var color: Color {
        switch self {
        case .action: .red
        case .comedy: .yellow
        case .drama: .blue
        case .horror: .purple
        case .animation: .orange
        case .adventure: .green
        case .thriller: .indigo
        case .romance: .pink
        case .scifi: .cyan
        case .documentary: .teal
        }
    }
}

struct SearchCategoryCard: View {
    let category: SearchCategory

    var body: some View {
        HStack {
            Image(systemName: category.icon)
                .font(.title2)
                .foregroundStyle(.white)

            Text(category.rawValue)
                .font(.subheadline.bold())
                .foregroundStyle(.white)

            Spacer()
        }
        .padding()
        .frame(height: 70)
        .background(category.color.gradient, in: RoundedRectangle(cornerRadius: 12))
        .pressable()
    }
}
