import SwiftUI

struct IngressoPreSaleBadge: View {
    var body: some View {
        Text("Pré-venda".uppercased())
            .font(.caption2.weight(.heavy))
            .padding(.horizontal, IngressoSpacing.sm)
            .padding(.vertical, IngressoSpacing.xxs)
            .glassEffect(.regular, in: .capsule)
    }
}

#Preview {
    IngressoPreSaleBadge()
        .padding()
        .background(.black)
}
