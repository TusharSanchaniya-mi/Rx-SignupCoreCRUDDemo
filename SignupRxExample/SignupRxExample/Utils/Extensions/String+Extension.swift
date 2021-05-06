//
//  String+Extension.swift
//  SignupRxExample
//
//  Created by Mac-00014 on 29/04/21.
//

import Foundation

enum ValidationType {
    case username
    case email
    case phoneNumber
    case password
    case confirmPassword
    case userProfile
    case gender
}

extension ValidationType {
    func getValidation() -> String {
        switch self {
        case .username:
            return "^[A-Z0-9a-z._%+-].{2,19}$"
        case .phoneNumber:
            return "^([0-9]).{7,11}$"
        case .email:
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,63}"
        case .password, .confirmPassword:
            return "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,15}$"
        case .userProfile, .gender:
            return ""
        }
    }
}


extension String {
    
    func validateField(_ fieldType : ValidationType) -> Bool {
        
        let validateResult: NSPredicate = NSPredicate(format:"SELF MATCHES %@", fieldType.getValidation())
        return validateResult.evaluate(with: self)
    }
    
}


