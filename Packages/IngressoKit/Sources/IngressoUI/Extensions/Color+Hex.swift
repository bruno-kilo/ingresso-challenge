import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let red, green, blue: Double
        switch hex.count {
        case 3:
            red = Double((int >> 8) * 17) / 255
            green = Double((int >> 4 & 0xF) * 17) / 255
            blue = Double((int & 0xF) * 17) / 255
        case 6:
            red = Double(int >> 16) / 255
            green = Double(int >> 8 & 0xFF) / 255
            blue = Double(int & 0xFF) / 255
        default:
            red = 0; green = 0; blue = 0
        }

        self.init(red: red, green: green, blue: blue)
    }
}
