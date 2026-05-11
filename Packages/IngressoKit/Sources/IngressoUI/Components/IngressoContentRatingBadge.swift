import SwiftUI
import IngressoDomain
import IngressoMock

struct IngressoContentRatingBadge: View {
    let rating: IngressoContentRating

    var body: some View {
        Text(rating.label)
            .font(.caption2.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, IngressoSpacing.xs)
            .padding(.vertical, IngressoSpacing.xxs)
            .background(Color(hex: rating.color), in: RoundedRectangle(cornerRadius: IngressoSpacing.xs))
    }
}

#Preview {
    let rating = IngressoFixtures.makeMovie().contentRating!
    IngressoContentRatingBadge(rating: rating)
        .padding()
}
