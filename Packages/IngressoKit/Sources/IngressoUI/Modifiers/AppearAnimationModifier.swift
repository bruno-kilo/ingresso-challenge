import SwiftUI

struct AppearAnimationModifier: ViewModifier {
    var delay: Double = 0
    var offsetY: CGFloat = 20
    var offsetX: CGFloat = 0
    var duration: Double = 0.4

    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(x: appeared ? 0 : offsetX, y: appeared ? 0 : offsetY)
            .animation(.easeOut(duration: duration).delay(delay), value: appeared)
            .onAppear { appeared = true }
    }
}

extension View {
    func appearAnimation(delay: Double = 0, offsetY: CGFloat = 20) -> some View {
        modifier(AppearAnimationModifier(delay: delay, offsetY: offsetY))
    }

    func appearFromRight(delay: Double = 0) -> some View {
        modifier(AppearAnimationModifier(delay: delay, offsetY: 0, offsetX: 30))
    }
}
