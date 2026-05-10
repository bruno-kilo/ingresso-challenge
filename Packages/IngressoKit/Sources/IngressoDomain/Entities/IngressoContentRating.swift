public struct IngressoContentRating: Hashable, Sendable {
    public let id: Int
    public let name: String
    public let label: String
    public let displayName: String
    public let description: String
    public let color: String

    public init(id: Int, name: String, label: String, displayName: String, description: String, color: String) {
        self.id = id
        self.name = name
        self.label = label
        self.displayName = displayName
        self.description = description
        self.color = color
    }
}
