import Foundation

public struct IngressoPremiereDate: Hashable, Sendable {
    public let localDate: Date?
    public let dayAndMonth: String
    public let dayOfWeek: String
    public let year: String

    public init(localDate: Date?, dayAndMonth: String, dayOfWeek: String, year: String) {
        self.localDate = localDate
        self.dayAndMonth = dayAndMonth
        self.dayOfWeek = dayOfWeek
        self.year = year
    }
}
