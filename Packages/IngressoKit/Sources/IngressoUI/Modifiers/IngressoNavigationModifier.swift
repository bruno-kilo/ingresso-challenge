import SwiftUI
import IngressoDomain
import IngressoPresentation

struct IngressoNavigationModifier: ViewModifier {
    @Environment(IngressoRouter.self) private var router
    @Environment(FavoritesViewModel.self) private var favoritesViewModel

    private let presentationFactory = IngressoPresentationFactory()
    private let uiFactory = IngressoUIFactory()

    func body(content: Content) -> some View {
        content
            .navigationDestination(for: IngressoRoute.self) { route in
                destination(for: route)
            }
            .sheet(item: Bindable(router).sheet) { route in
                NavigationStack {
                    destination(for: route)
                }
                .environment(router)
                .environment(favoritesViewModel)
            }
    }

    @MainActor
    @ViewBuilder
    private func destination(for route: IngressoRoute) -> some View {
        switch route {
        case .movieDetail(let movie):
            uiFactory.makeMovieDetailScreen(
                viewModel: presentationFactory.makeMovieDetailViewModel(movie: movie)
            )
        }
    }
}

public extension View {
    func ingressoNavigation() -> some View {
        modifier(IngressoNavigationModifier())
    }
}
