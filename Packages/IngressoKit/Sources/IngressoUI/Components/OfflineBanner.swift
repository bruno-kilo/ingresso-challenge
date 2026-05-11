import SwiftUI
import IngressoInfrastructure
import IngressoMock

struct StatusBanner: View {
    @Environment(NetworkMonitor.self) private var networkMonitor
    var error: IngressoNetworkError?
    var isLoading: Bool = false
    var retryAction: (() -> Void)?

    private var shouldShow: Bool {
        !networkMonitor.isConnected || error != nil
    }

    var body: some View {
        if shouldShow {
            Button {
                retryAction?()
            } label: {
                HStack(spacing: 6) {
                    Group {
                        if isLoading {
                            ProgressView()
                                .controlSize(.small)
                        } else {
                            Image(systemName: icon)
                        }
                    }
                    .frame(width: 16)

                    Text(message)

                    if retryAction != nil && !isLoading && error?.isRetryable == true {
                        Image(systemName: "arrow.clockwise")
                            .fontWeight(.semibold)
                    }
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.bar)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
            }
            .buttonStyle(.plain)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .padding(.bottom, 8)
        }
    }

    private var icon: String {
        if !networkMonitor.isConnected {
            return "wifi.slash"
        }
        return error?.systemImage ?? "exclamationmark.triangle"
    }

    private var message: String {
        if !networkMonitor.isConnected {
            return "Sem conexão"
        }
        if let error {
            switch error {
            case .timeout: return "Tempo esgotado"
            case .serverError: return "Erro no servidor"
            case .rateLimited: return "Aguarde um momento"
            default: return "Algo deu errado"
            }
        }
        return ""
    }
}

#Preview {
    let infraFactory = IngressoInfrastructureFactory()
    StatusBanner(error: .timeout, retryAction: {})
        .environment(infraFactory.makeNetworkMonitor())
}
