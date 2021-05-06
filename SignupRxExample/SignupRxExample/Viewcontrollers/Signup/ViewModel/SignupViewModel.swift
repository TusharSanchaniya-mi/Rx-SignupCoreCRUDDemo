//
//  SignupViewModel.swift
//  SignupRxExample
//
//  Created by Mac-00014 on 29/04/21.
//

import Foundation
import RxSwift
import RxCocoa


struct SignupViewModel {
    
    
    //private var profileImageObserver = BehaviorRelay<Bool>(value: false)
    //private var profileImageErrorObserver = BehaviorRelay<Bool>(value: false)
    
    var usernameErrorObs : Observable<Bool> {
        return usernameErrorObserver.asObservable()
    }
    
    var phoneNumberErrorObs : Observable<Bool> {
        return contactNumErrorObserver.asObservable()
    }
    
    var EmailErrorObs : Observable<Bool> {
        return emailErrorObserver.asObservable()
    }
    
    var passwordErrorObs : Observable<Bool> {
        return passwordErrorObserver.asObservable()
    }
    
    var cofirmPasswordErrorObs : Observable<Bool> {
        return confirmPasswordErrorObserver.asObservable()
    }
    
    var profileUploadErrorObs : Observable<UIImage> {
        return profileUploadObserver.asObservable()
    }
    
    var profilePicUploadErrorObs : Observable<Bool> {
        return profileUploadErrorObserver.asObservable()
    }
    
    var genderButtonSelectionObs: Observable<String> {
        return genderButtonObserver.asObservable()
    }
    
    var formValidation : Observable<Bool> {
        return formValidationObserver.asObservable()
    }
    
    
    private var usernameObserver = BehaviorRelay<String?>(value: nil)
    private var usernameErrorObserver = BehaviorRelay<Bool>(value: false)
    
    private var emailObserver = BehaviorRelay<String?>(value: nil)
    private var emailErrorObserver = BehaviorRelay<Bool>(value: false)
    
    private var contactNumObserver = BehaviorRelay<String?>(value: nil)
    private var contactNumErrorObserver = BehaviorRelay<Bool>(value: false)
    
    private var passwordObserver = BehaviorRelay<String?>(value: nil)
    private var passwordErrorObserver = BehaviorRelay<Bool>(value: false)
    
    private var confirmPasswordObserver = BehaviorRelay<String?>(value: nil)
    private var confirmPasswordErrorObserver = BehaviorRelay<Bool>(value: false)
    
    private var profileUploadObserver = BehaviorRelay<UIImage>(value: UIImage(named: SignupErrorMsg.placeHolderimage)!)
    private var profileUploadErrorObserver = BehaviorRelay<Bool>(value: false)
    
    private var genderButtonObserver = BehaviorRelay<String>(value: "male")
    
    private var formValidationObserver = BehaviorRelay<Bool>(value: false)
    
    private let disposebag = DisposeBag()
    
    init() {
        self.bindObserver()
    }
    
    private func bindObserver() {
        
        usernameObserver
            .asObservable()
            .distinctUntilChanged()
            .compactMap({ $0 })
            .map({ (username) in
                username.isEmpty || username.validateField(.username)
            })
            .bind(to: usernameErrorObserver)
            .disposed(by: disposebag)
        
        emailObserver
            .asObservable()
            .distinctUntilChanged()
            .compactMap({ $0 })
            .map({ (email) in
                email.isEmpty || email.validateField(.email)
            })
            .bind(to: emailErrorObserver)
            .disposed(by: disposebag)
        
        contactNumObserver
            .asObservable()
            .distinctUntilChanged()
            .compactMap({ $0 })
            .map({ (phNumber) in
                phNumber.isEmpty || phNumber.validateField(.phoneNumber)
            })
            .bind(to: contactNumErrorObserver)
            .disposed(by: disposebag)
        
        passwordObserver
            .asObservable()
            .distinctUntilChanged()
            .compactMap({ $0 })
            .map({ (password) in
                password.isEmpty || password.validateField(.password)
            })
            .bind(to: passwordErrorObserver)
            .disposed(by: disposebag)
        
        Observable.combineLatest(passwordObserver.asObservable(),
                                 confirmPasswordObserver.asObservable())
            .map { (password, confirmPassword) in
                password == confirmPassword
            }.bind(to: confirmPasswordErrorObserver)
            .disposed(by: disposebag)
        
//        Observable.combineLatest(usernameErrorObserver, emailErrorObserver,
//                                 contactNumErrorObserver, passwordErrorObserver,
//                                 confirmPasswordErrorObserver, profileUploadObserver)
//            .map { (bUser, bEmail, bNumber, bPassword, bCPassword, imgProfile) in
//                self.profileUploadErrorObserver.accept((imgProfile != UIImage(named: SignupErrorMsg.placeHolderimage)!))
//
//                return bUser && bEmail && bNumber && bPassword && bCPassword && (imgProfile != UIImage(named: SignupErrorMsg.placeHolderimage)!)
//            }
//            .bind(to: formValidationObserver)
//            .disposed(by: disposebag)
        
        Observable.combineLatest(usernameObserver, emailObserver,
                                 contactNumObserver, passwordObserver,
                                 confirmPasswordObserver)
            .map { (v1, v2, v3, v4, v5) -> Bool in
                
                guard (v4 ?? "").count > 0, (v5 ?? "").count > 0,(v4 ?? "").caseInsensitiveCompare(v5 ?? "") == .orderedSame else {
                    return false
                }
                
                //self.profileUploadErrorObserver.accept((v6 != UIImage(named: SignupErrorMsg.placeHolderimage)!))
                
                return (v1 ?? "").count > 0 && usernameErrorObserver.value &&
                    (v2 ?? "").count > 0 && emailErrorObserver.value &&
                    (v3 ?? "").count > 0 && contactNumErrorObserver.value &&
                    (v4 ?? "").count > 0 && passwordErrorObserver.value &&
                    (v5 ?? "").count > 0 && confirmPasswordErrorObserver.value 
                    //(v6 != UIImage(named: SignupErrorMsg.placeHolderimage)!) && profileUploadErrorObserver.value
            }
            .bind(to: formValidationObserver)
            .disposed(by: disposebag)
        
    }
    
    private func getSignupModel(_ recordId : Int64 = CoreDataModel.getNextRecordID()) -> SignupCoreModel {
        return SignupCoreModel(id: recordId,
                               username: usernameObserver.value,
                               email: emailObserver.value,
                               phoneNumber: contactNumObserver.value,
                               password: passwordObserver.value,
                               gender: genderButtonObserver.value,
                               profilePhoto: profileUploadObserver.value.jpegData(compressionQuality: 1.0))
    }
    
    @discardableResult
    func saveToDetails() -> Bool {
        CoreDataModel.saveDetailsToCoreData(getSignupModel())
    }
    
    @discardableResult
    func updateData(_ recordId: Int64) -> Bool {
        CoreDataModel.updateDetailsToCoreData(getSignupModel(recordId))
    }
    
    func validateFieldsObs(_ type : ValidationType,_ value: String = "", _ profileImg: UIImage? = nil) {
        
        switch type {
        
        case .username:
            usernameObserver.accept(value)
        
        case .email:
            emailObserver.accept(value)
        
        case .phoneNumber:
            contactNumObserver.accept(value)
        
        case .password:
            passwordObserver.accept(value)
        
        case .confirmPassword:
            confirmPasswordObserver.accept(value)
            
        case .userProfile:
            profileUploadObserver.accept(profileImg!)
            profileUploadErrorObserver.accept(true)
            
        case .gender:
            genderButtonObserver.accept(value)
            
        }
        
    }
    
}
