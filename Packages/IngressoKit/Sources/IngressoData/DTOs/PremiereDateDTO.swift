public struct PremiereDateDTO: Decodable, Sendable {
    public let localDate: String?
    public let isToday: Bool
    public let dayOfWeek: String
    public let dayAndMonth: String
    public let hour: String
    public let year: String
}
