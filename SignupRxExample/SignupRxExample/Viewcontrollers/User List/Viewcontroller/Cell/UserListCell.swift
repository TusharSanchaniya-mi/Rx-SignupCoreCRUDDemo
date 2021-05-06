//
//  UserListself.swift
//  SignupRxExample
//
//  Created by Mac-00014 on 04/05/21.
//

import UIKit

class UserListCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userProfileImage.roundedView()
    }
    
    func bindView(_ userSignupModel: SignupCoreModel) {
        
        self.userNameLabel.text = userSignupModel.username?.capitalized
        self.genderLabel.text = userSignupModel.gender?.capitalized
        self.emailLabel.text = userSignupModel.email
        
        if let profilePicData = userSignupModel.profilePhoto {
            self.userProfileImage.image = UIImage(data: profilePicData)
        }
        
    }
    
}
