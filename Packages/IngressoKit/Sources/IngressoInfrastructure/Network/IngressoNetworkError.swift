import Foundation

public enum IngressoNetworkError: Error, Sendable, Equatable {
    case badURL
    case noConnection
    case timeout
    case serverError(statusCode: Int)
    case clientError(statusCode: Int)
    case rateLimited
    case decodingFailed
    case unknown(statusCode: Int)
}

extension IngressoNetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badURL:
            "URL inválida."
        case .noConnection:
            "Sem conexão com a internet. Verifique sua rede e tente novamente."
        case .timeout:
            "A requisição expirou. Tente novamente."
        case .serverError(let code):
            "Erro no servidor (\(code)). Tente novamente mais tarde."
        case .clientError(let code):
            "Erro na requisição (\(code))."
        case .rateLimited:
            "Muitas requisições. Aguarde um momento e tente novamente."
        case .decodingFailed:
            "Erro ao processar os dados recebidos."
        case .unknown(let code):
            "Erro desconhecido (\(code))."
        }
    }
}

extension IngressoNetworkError {
    public var isRetryable: Bool {
        switch self {
        case .noConnection, .timeout, .serverError, .rateLimited:
            true
        case .badURL, .clientError, .decodingFailed, .unknown:
            false
        }
    }

    public var systemImage: String {
        switch self {
        case .noConnection:
            "wifi.slash"
        case .timeout:
            "clock.badge.exclamationmark"
        case .serverError:
            "server.rack"
        case .rateLimited:
            "hourglass"
        case .badURL, .clientError, .decodingFailed, .unknown:
            "exclamationmark.triangle"
        }
    }
}
