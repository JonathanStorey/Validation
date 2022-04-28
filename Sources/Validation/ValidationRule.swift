//
//  File.swift
//  
//
//  Created by Jonathan Storey on 1/23/22.
//

import Foundation

public protocol ValidationRule {
    
    associatedtype Value: Equatable
    associatedtype Failure: Error
    typealias ValidationResult = Result<Value, Failure>
    
    init()
    
    var fallbackValue: Value { get }
    
    func validate(_ value: Value) -> ValidationResult
}

public extension ValidationRule where Value == String {
    var fallbackValue: Value { .init() } // returns empty String
}

public extension ValidationRule where Value: ExpressibleByNilLiteral {
    var fallbackValue: Value { .init(nilLiteral: ()) } // returns nil
}


