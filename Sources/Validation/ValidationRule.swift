//  Created by Jonathan Storey on 1/23/22.

public protocol ValidationRule {
    
    associatedtype Value: Equatable
    associatedtype Failure: Error
    typealias ValidationResult = Result<Value, Failure>
    
    init()
    
    var fallbackValue: Value { get }
    
    func validate(_ value: Value) -> Result<Value, Failure>
}

public extension ValidationRule where Value == String {
    var fallbackValue: Value { .init() } // returns empty String
}

public extension ValidationRule where Value: ExpressibleByNilLiteral {
    var fallbackValue: Value { .init(nilLiteral: ()) } // returns nil
}


