import SwiftUI
import SwiftData
import IngressoInfrastructure

@main
struct IngressoApp: App {
    let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(for: FavoriteMovieEntity.self, CachedMovieEntity.self)
        } catch {
            fatalError("Falha ao criar ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(modelContainer: modelContainer)
        }
        .modelContainer(modelContainer)
    }
}
