//  Created by Jonathan Storey on 1/19/22.

import Foundation
import SwiftUI

extension View {
    
    public func validate<Rule>(_ value: Binding<Rule.Value>, rule: Rule, validation: @escaping (Rule.ValidationResult) -> Void) -> some View where Rule: ValidationRule {
        
        self
            .onChange(of: value.wrappedValue) { value in
                let result = rule.validate(value)
                validation(result)
            }
            .onSubmit {
                let result = rule.validate(value.wrappedValue)
                if case .success(let validated) = result {
                    if value.wrappedValue != validated {
                        value.wrappedValue = validated // update value
                    }
                }
            }
    }
}
