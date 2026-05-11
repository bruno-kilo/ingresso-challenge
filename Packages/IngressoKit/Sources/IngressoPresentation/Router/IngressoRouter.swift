import Foundation
import Observation

@Observable
@MainActor
public final class IngressoRouter {
    public var selectedTab: IngressoTab = .premieres
    public private(set) var paths: [IngressoTab: [IngressoRoute]] = [:]
    public var sheet: IngressoRoute?
    public var fullScreenCover: IngressoRoute?

    init() {}

    public var currentPath: [IngressoRoute] {
        get { paths[selectedTab, default: []] }
        set { paths[selectedTab] = newValue }
    }

    public func navigate(to route: IngressoRoute) {
        paths[selectedTab, default: []].append(route)
    }

    public func pop() {
        guard var tabPath = paths[selectedTab], !tabPath.isEmpty else { return }
        tabPath.removeLast()
        paths[selectedTab] = tabPath
    }

    public func popToRoot() {
        paths[selectedTab] = []
    }

    public func switchTab(_ tab: IngressoTab) {
        selectedTab = tab
    }

    public func switchTab(_ tab: IngressoTab, route: IngressoRoute) {
        selectedTab = tab
        paths[tab, default: []].append(route)
    }

    public func present(_ route: IngressoRoute) {
        sheet = route
    }

    public func presentFullScreen(_ route: IngressoRoute) {
        fullScreenCover = route
    }

    public func dismiss() {
        sheet = nil
        fullScreenCover = nil
    }
}
