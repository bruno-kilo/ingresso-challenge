import SwiftUI

struct IngressoPreSaleBadge: View {
    var body: some View {
        Text("Pré-venda".uppercased())
            .font(.caption2.bold())
            .foregroundStyle(IngressoColors.preSale)
            .padding(.horizontal, IngressoSpacing.sm)
            .padding(.vertical, IngressoSpacing.xxs)
            .glassEffect(.regular, in: .capsule)
    }
}
