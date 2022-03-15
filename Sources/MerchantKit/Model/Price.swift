import Foundation

/// The `Price` encapsulates a numeric value and locale. Use a `PriceFormatter` to display the purchase price of a product in UI.
public struct Price : Codable, Hashable, CustomStringConvertible {
    public typealias Value = (number: Decimal, locale: Locale)

    enum CodingKeys: String, CodingKey {
        case number
        case locale
    }
    /// Underlying values that make up the `Price`
    public let value: Value
    
    /// Create a `Price` with the given `value`. Typically, you do not construct `Price` values manually. Instead, access the `price` on a `Purchase` instance.
    public init(value: Value) {
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let number : Decimal = try container.decode(Decimal.self, forKey: .number)
        let locale : Locale = try container.decode(Locale.self, forKey: .locale)
        
        self.value = (number, locale)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(value.number, forKey: .number)
        try container.encode(value.locale, forKey: .locale)
    }
    
    public var description: String {
        let formatter = Price._descriptionFormatter
        formatter.locale = self.value.locale
        
        return self.defaultDescription(withProperties: ("", formatter.string(from: self.value.0 as NSDecimalNumber)!))
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.value.0)
        hasher.combine(self.value.1)
    }

    public static func ==(lhs: Price, rhs: Price) -> Bool {
        return lhs.value == rhs.value
    }
    
    private static var _descriptionFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter
    }()
}
