import SwiftUI

struct GradientOverlay: View {
    var style: Style = .bottomFade

    enum Style {
        case bottomFade
        case bottomStrong
        case preSale
        case adaptive(ColorScheme)
    }

    var body: some View {
        LinearGradient(colors: colors, startPoint: startPoint, endPoint: .bottom)
    }

    private var colors: [Color] {
        switch style {
        case .bottomFade:
            [.clear, .clear, .black.opacity(0.7)]
        case .bottomStrong:
            [.clear, .black.opacity(0.8)]
        case .preSale:
            [.clear, .accentColor.opacity(0.8)]
        case .adaptive(let scheme):
            [.clear, .clear, scheme == .dark ? .black : .white]
        }
    }

    private var startPoint: UnitPoint {
        switch style {
        case .bottomStrong, .preSale:
            .center
        default:
            .top
        }
    }
}
