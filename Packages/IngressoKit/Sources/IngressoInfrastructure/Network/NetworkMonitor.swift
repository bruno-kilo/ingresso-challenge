import Foundation
import Network
import Observation
import OSLog

@Observable
public final class NetworkMonitor: @unchecked Sendable {
    public private(set) var isConnected: Bool = true

    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "com.brunosantos.Ingresso.NetworkMonitor")
    private let logger = Logger(subsystem: "com.brunosantos.Ingresso", category: "Network")

    init() {
        self.monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            let connected = path.status == .satisfied
            Task { @MainActor in
                guard let self, self.isConnected != connected else { return }
                self.isConnected = connected
                self.logger.info("🌐 conectividade: \(connected ? "online" : "offline")")
            }
        }
        monitor.start(queue: queue)
        logger.info("🌐 NetworkMonitor iniciado")
    }

    deinit {
        monitor.cancel()
    }
}
