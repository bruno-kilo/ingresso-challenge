import Foundation
import Network
import Observation

@Observable
public final class NetworkMonitor: @unchecked Sendable {
    public private(set) var isConnected: Bool = true

    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "com.brunosantos.Ingresso.NetworkMonitor")

    init() {
        self.monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
