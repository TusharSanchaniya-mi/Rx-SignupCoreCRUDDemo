//
//  UIImageView+Extension.swift
//  SignupRxExample
//
//  Created by Mac-00014 on 29/04/21.
//

import Foundation
import UIKit

extension UIImageView {
    
    func roundedView() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true
    }
    
}


