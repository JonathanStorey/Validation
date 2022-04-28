//  Created by Jonathan Storey on 1/18/22.

@propertyWrapper
public struct Validated<Rule: ValidationRule> {
    
    public var wrappedValue: Rule.Value
    
    private var rule: Rule
    
    // usage: @Validated(Rule()) var value: String = "initial value"
    public init(wrappedValue: Rule.Value, _ rule: Rule) {
        self.rule = rule
        self.wrappedValue = wrappedValue
    }
}

extension Validated {
    public var projectedValue: Rule.ValidationResult { rule.validate(wrappedValue) }
}

extension Validated {
    
    // usage: @Validated<Rule> var value: String = "initial value"
    public init(wrappedValue: Rule.Value) {
        self.init(wrappedValue: wrappedValue, Rule.init())
    }
    
    // usage: @Validated<Rule> var value {
    public init() {
        let rule = Rule.init()
        self.init(wrappedValue: rule.fallbackValue, rule)
    }
}

extension Validated: Encodable where Rule.Value: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch projectedValue {
        case .success(let validated):
            try container.encode(validated)
        case .failure(_):
            try container.encode(Rule().fallbackValue)
        }
    }
}

extension Validated: Decodable where Rule.Value: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(Rule.Value.self)
        self.init(wrappedValue: value)
    }
}

extension Validated: Hashable where Rule.Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.wrappedValue)
    }
}

extension Validated: Equatable where Rule.Value: Equatable {
    public static func == (lhs: Validated<Rule>, rhs: Validated<Rule>) -> Bool {
        return lhs.wrappedValue == rhs.wrappedValue
    }
}

//NOTE:
//can extend KeyedEncodingContainer and/or KeyedDecodingContainer if desired:
//
//extension KeyedEncodingContainer {
//    public mutating func encode<Rule: ValidationRule>(_ value: Validated<Rule>, forKey key: Key) throws where Rule.Value: Encodable {
//        ...
//    }
//}
//
//extension KeyedDecodingContainer {
//    func decode<Rule>(_ type: Validated<Rule>.Type, forKey key: Key) throws -> Validated<Rule> where Rule.Value: Decodable {
//        ...
//    }
//}
