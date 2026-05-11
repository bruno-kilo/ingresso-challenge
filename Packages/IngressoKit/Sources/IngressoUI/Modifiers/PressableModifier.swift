import SwiftUI

struct PressableModifier: ViewModifier {
    var scale: CGFloat = 0.95
    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? scale : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                isPressed = pressing
            }, perform: {})
    }
}

extension View {
    func pressable(scale: CGFloat = 0.95) -> some View {
        modifier(PressableModifier(scale: scale))
    }
}

#Preview {
    RoundedRectangle(cornerRadius: 12)
        .fill(.blue.gradient)
        .frame(width: 140, height: 210)
        .pressable()
        .padding()
}
