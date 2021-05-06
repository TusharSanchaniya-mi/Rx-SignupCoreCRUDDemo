//
//  UIView+Extension.swift
//  SignupRxExample
//
//  Created by Mac-00014 on 29/04/21.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable
    var border : CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    
    @IBInspectable
    var borderColor : UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor ?? UIColor.black.cgColor)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    
    @IBInspectable
    var cornerRadius : CGFloat {
        get {
            self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }

}
