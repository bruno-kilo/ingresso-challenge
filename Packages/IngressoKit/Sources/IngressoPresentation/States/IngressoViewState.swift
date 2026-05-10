import IngressoInfrastructure

public enum IngressoViewState<T: Sendable>: Sendable {
    case idle
    case loading
    case loaded(T)
    case error(IngressoNetworkError)
    case empty
}

extension IngressoViewState {
    public var errorMessage: String? {
        if case .error(let error) = self { return error.localizedDescription }
        return nil
    }

    public var networkError: IngressoNetworkError? {
        if case .error(let error) = self { return error }
        return nil
    }
}
