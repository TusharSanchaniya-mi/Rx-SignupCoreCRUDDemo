//
//  Constants.swift
//  SignupRxExample
//
//  Created by Mac-00014 on 29/04/21.
//

import Foundation

struct SignupErrorMsg {
    static let usernameError : String = "Useranem shouls contains more then 3 & up to 20 characters."
    static let emailError : String = "This is not valid email, please enter valid email adress."
    static let phoneNumberError : String = "Contact number should be 7 to 12 digits."
    static let passwordError : String = "Password should contains 1 Uppercase, 1 Lowercase and 1 Numberic value."
    static let confirmPasswordError : String = "Confirm password should match with password"
    
    static let genderError : String = "Please choose your gender."
    static let userProfileError : String = "Please select different profile picture. either from Gallary or Camera."
    
    static let placeHolderimage = "placeHolder"
}
