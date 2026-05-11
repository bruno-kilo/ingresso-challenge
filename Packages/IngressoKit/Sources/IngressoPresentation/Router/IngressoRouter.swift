import Foundation
import Observation
import OSLog

@Observable
@MainActor
public final class IngressoRouter {
    public var selectedTab: IngressoTab = .premieres
    public private(set) var paths: [IngressoTab: [IngressoRoute]] = [:]
    public var sheet: IngressoRoute?
    public var fullScreenCover: IngressoRoute?

    private let logger = Logger(subsystem: "com.brunosantos.Ingresso", category: "Navigation")

    init() {}

    public var currentPath: [IngressoRoute] {
        get { paths[selectedTab, default: []] }
        set {
            let oldPath = paths[selectedTab, default: []]
            paths[selectedTab] = newValue
            if newValue.count > oldPath.count, let route = newValue.last {
                logger.info("📍 push \(route.id) na tab \(self.selectedTab.rawValue)")
            } else if newValue.count < oldPath.count {
                let removed = oldPath.last?.id ?? "?"
                logger.info("📍 pop \(removed) da tab \(self.selectedTab.rawValue) (depth: \(newValue.count))")
            }
        }
    }

    public func navigate(to route: IngressoRoute) {
        var path = currentPath
        path.append(route)
        currentPath = path
    }

    public func pop() {
        var path = currentPath
        guard !path.isEmpty else { return }
        path.removeLast()
        currentPath = path
    }

    public func popToRoot() {
        currentPath = []
    }

    public func switchTab(_ tab: IngressoTab) {
        logger.info("📍 switchTab \(self.selectedTab.rawValue) → \(tab.rawValue)")
        selectedTab = tab
    }

    public func switchTab(_ tab: IngressoTab, route: IngressoRoute) {
        logger.info("📍 switchTab \(self.selectedTab.rawValue) → \(tab.rawValue) + push \(route.id)")
        selectedTab = tab
        var path = paths[tab, default: []]
        path.append(route)
        paths[tab] = path
    }

    public func present(_ route: IngressoRoute) {
        sheet = route
        logger.info("📍 sheet \(route.id)")
    }

    public func presentFullScreen(_ route: IngressoRoute) {
        fullScreenCover = route
        logger.info("📍 fullScreenCover \(route.id)")
    }

    public func dismiss() {
        let was = sheet?.id ?? fullScreenCover?.id ?? "nenhum"
        sheet = nil
        fullScreenCover = nil
        logger.info("📍 dismiss \(was)")
    }
}
