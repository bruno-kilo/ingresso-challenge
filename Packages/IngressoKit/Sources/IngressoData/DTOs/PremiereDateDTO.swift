struct PremiereDateDTO: Decodable, Sendable {
    let localDate: String?
    let isToday: Bool
    let dayOfWeek: String
    let dayAndMonth: String
    let hour: String
    let year: String
}
