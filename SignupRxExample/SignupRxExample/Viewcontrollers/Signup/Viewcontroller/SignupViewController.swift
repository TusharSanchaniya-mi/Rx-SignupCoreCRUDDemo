//
//  ViewController.swift
//  SignupRxExample
//
//  Created by Mac-00014 on 29/04/21.
//

import UIKit
import RxSwift
import RxCocoa

class SignupViewController: UIViewController {

    @IBOutlet private weak var imgProfile: UIImageView!
    @IBOutlet private weak var lblProfileError: UILabel!
    
    @IBOutlet private weak var txtUsername: UITextField!
    @IBOutlet private weak var lblUsernameError: UILabel!
    
    @IBOutlet private weak var txtEmail: UITextField!
    @IBOutlet private weak var lblEmailError: UILabel!
    
    @IBOutlet private weak var txtContactNumber: UITextField!
    @IBOutlet private weak var lblContactNumberError: UILabel!
    
    @IBOutlet private weak var btnMale: UIButton!
    @IBOutlet private weak var btnFemale: UIButton!
    
    @IBOutlet private weak var txtPassword: UITextField!
    @IBOutlet private weak var lblPasswordError: UILabel!
    
    @IBOutlet private weak var txtConfirmPassword: UITextField!
    @IBOutlet private weak var lblConfirmPassword: UILabel!
    
    @IBOutlet private weak var btnSignUp: UIButton!
    
    private var viewModel: SignupViewModel!
    private let disposeBag = DisposeBag()
    
    var isForUpdate: Bool = false
    var signupModel: SignupCoreModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialis()
        
        self.bindViewModel()
        self.errorFieldBinding()
        
        if self.isForUpdate {
            self.preFilledValue()
        }
    }

    private func preFilledValue() {
        
        self.txtUsername.text = signupModel.username ?? ""
        self.viewModel.validateFieldsObs(.username, signupModel.username ?? "")
        
        self.txtEmail.text = signupModel.email ?? ""
        self.txtEmail.isUserInteractionEnabled = false
        self.viewModel.validateFieldsObs(.email, signupModel.email ?? "")
        
        self.txtContactNumber.text = signupModel.phoneNumber ?? ""
        self.viewModel.validateFieldsObs(.phoneNumber, signupModel.phoneNumber ?? "")
        
        DispatchQueue.main.async {
            self.txtPassword.text = self.signupModel.password ?? ""
            self.txtConfirmPassword.text = self.signupModel.password ?? ""
            
            self.viewModel.validateFieldsObs(.password, self.txtPassword.text ?? "")
            self.viewModel.validateFieldsObs(.confirmPassword, self.txtConfirmPassword.text ?? "")            
        }
        
        self.btnFemale.setImage(#imageLiteral(resourceName: "ic_radio_unselected"), for: .normal)
        self.btnFemale.setImage(#imageLiteral(resourceName: "ic_radio_unselected"), for: .selected)
        
        self.btnMale.setImage(#imageLiteral(resourceName: "ic_radio_unselected"), for: .normal)
        self.btnMale.setImage(#imageLiteral(resourceName: "ic_radio_unselected"), for: .selected)
        
        if (signupModel.gender ?? "").caseInsensitiveCompare(self.btnMale.titleLabel?.text ?? "") == .orderedSame {
            self.btnMale.setImage(#imageLiteral(resourceName: "ic_radio_selected"), for: .normal)
            self.btnMale.setImage(#imageLiteral(resourceName: "ic_radio_selected"), for: .selected)
        }
        else if (signupModel.gender ?? "").caseInsensitiveCompare(self.btnFemale.titleLabel?.text ?? "") == .orderedSame {
            self.btnFemale.setImage(#imageLiteral(resourceName: "ic_radio_selected"), for: .normal)
            self.btnFemale.setImage(#imageLiteral(resourceName: "ic_radio_selected"), for: .selected)
        }
        
        if let profileData = signupModel.profilePhoto {
            DispatchQueue.main.async {
                self.imgProfile.image = UIImage(data: profileData)
                self.viewModel.validateFieldsObs(.userProfile, "", self.imgProfile.image)
            }
        }
        
        self.btnSignUp.setTitle("Update User", for: .normal)
        self.btnSignUp.setTitle("Update User", for: .selected)
    }
    
    private func initialis() {
        viewModel = SignupViewModel()
        
        self.imgProfile.roundedView()
        
        self.lblUsernameError.text = SignupErrorMsg.usernameError
        self.lblContactNumberError.text = SignupErrorMsg.phoneNumberError
        self.lblEmailError.text = SignupErrorMsg.emailError
        self.lblPasswordError.text = SignupErrorMsg.passwordError
        self.lblConfirmPassword.text = SignupErrorMsg.confirmPasswordError
        self.lblProfileError.text = SignupErrorMsg.userProfileError
        
    }
    
    private func bindViewModel() {
        
        txtUsername.rx.text
            .takeUntil(rx.deallocated)
            .subscribe { (usernameEvent) in
                switch usernameEvent {
                    case .next(let userName):
                        self.viewModel.validateFieldsObs(.username, userName ?? "")
                case .error(let errorMsg):
                    print(errorMsg)
                case .completed:
                    print("Done")
                }
            }.disposed(by: disposeBag)
        
        txtEmail.rx.text
            .takeUntil(rx.deallocated)
            .subscribe { (usernameEvent) in
                switch usernameEvent {
                    case .next(let email):
                        self.viewModel.validateFieldsObs(.email, email ?? "")
                case .error(let errorMsg):
                    print(errorMsg)
                case .completed:
                    print("Done")
                }
            }.disposed(by: disposeBag)
        
        txtContactNumber.rx.text
            .takeUntil(rx.deallocated)
            .subscribe { (usernameEvent) in
                switch usernameEvent {
                    case .next(let phNumber):
                        self.viewModel.validateFieldsObs(.phoneNumber, phNumber ?? "")
                case .error(let errorMsg):
                    print(errorMsg)
                case .completed:
                    print("Done")
                }
            }.disposed(by: disposeBag)
        
        txtPassword.rx.text
            .takeUntil(rx.deallocated)
            .subscribe { (usernameEvent) in
                switch usernameEvent {
                    case .next(let password):
                        self.viewModel.validateFieldsObs(.password, password ?? "")
                case .error(let errorMsg):
                    print(errorMsg)
                case .completed:
                    print("Done")
                }
            }.disposed(by: disposeBag)
        
        txtConfirmPassword.rx.text.orEmpty
            .takeUntil(rx.deallocated)
            .subscribe { (usernameEvent) in
                switch usernameEvent {
                    case .next(let cPassword):
                        self.viewModel.validateFieldsObs(.confirmPassword, cPassword )
                case .error(let errorMsg):
                    print(errorMsg)
                case .completed:
                    print("Done")
                }
            }.disposed(by: disposeBag)
    
        
        btnMale.rx.controlEvent(UIControl.Event.touchUpInside)
            .asObservable()
            .takeUntil(rx.deallocated).subscribe { (_) in
                /*self.btnFemale.setImage(#imageLiteral(resourceName: "ic_radio_unselected"), for: .normal)
                self.btnFemale.setImage(#imageLiteral(resourceName: "ic_radio_unselected"), for: .selected)
                self.btnMale.setImage(#imageLiteral(resourceName: "ic_radio_selected"), for: .normal)
                self.btnMale.setImage(#imageLiteral(resourceName: "ic_radio_selected"), for: .selected)*/
                self.viewModel.validateFieldsObs(.gender, self.btnMale.titleLabel?.text ?? "")
            }.disposed(by: disposeBag)
        
        btnFemale.rx.controlEvent(UIControl.Event.touchUpInside)
            .asObservable()
            .takeUntil(rx.deallocated).subscribe { (_) in
                /*self.btnMale.setImage(#imageLiteral(resourceName: "ic_radio_unselected"), for: .normal)
                self.btnMale.setImage(#imageLiteral(resourceName: "ic_radio_unselected"), for: .selected)
                self.btnFemale.setImage(#imageLiteral(resourceName: "ic_radio_selected"), for: .normal)
                self.btnFemale.setImage(#imageLiteral(resourceName: "ic_radio_selected"), for: .selected)*/
                self.viewModel.validateFieldsObs(.gender, self.btnFemale.titleLabel?.text ?? "")
            }.disposed(by: disposeBag)
        
    }
    
    private func errorFieldBinding() {
        
        viewModel.usernameErrorObs
            .asDriver(onErrorJustReturn: false)
            .drive { (bresult) in
                self.lblUsernameError.isHidden = bresult
            }.disposed(by: disposeBag)
        
        
        viewModel.EmailErrorObs
            .asDriver(onErrorJustReturn: false)
            .drive { (bresult) in
                self.lblEmailError.isHidden = bresult
            }.disposed(by: disposeBag)
        
        viewModel.phoneNumberErrorObs
            .asDriver(onErrorJustReturn: false)
            .drive { (bresult) in
                self.lblContactNumberError.isHidden = bresult
            }.disposed(by: disposeBag)
        
        viewModel.passwordErrorObs
            .asDriver(onErrorJustReturn: false)
            .drive { (bresult) in
                self.lblPasswordError.isHidden = bresult
            }.disposed(by: disposeBag)
        
        viewModel.cofirmPasswordErrorObs
            .asDriver(onErrorJustReturn: false)
            .drive { (bresult) in
                self.lblConfirmPassword.isHidden = bresult
            }.disposed(by: disposeBag)

        viewModel.profileUploadErrorObs
            .asDriver(onErrorJustReturn: UIImage(named: SignupErrorMsg.placeHolderimage)!)
            .drive { (userSelectedImage) in
                DispatchQueue.main.async {
                    self.imgProfile.image = userSelectedImage
                }
            }.disposed(by: disposeBag)

        
//        viewModel.profilePicUploadErrorObs
//            .asDriver(onErrorJustReturn: false)
//            .drive { (bProfError) in
//                self.lblProfileError.isHidden = bProfError
//            }.disposed(by: disposeBag)

        viewModel.genderButtonSelectionObs
            .asDriver(onErrorJustReturn: "male")
            .drive { [weak self] (btnTitle) in
                self?.btnFemale.setImage(#imageLiteral(resourceName: "ic_radio_unselected"), for: .normal)
                self?.btnFemale.setImage(#imageLiteral(resourceName: "ic_radio_unselected"), for: .selected)
                
                self?.btnMale.setImage(#imageLiteral(resourceName: "ic_radio_unselected"), for: .normal)
                self?.btnMale.setImage(#imageLiteral(resourceName: "ic_radio_unselected"), for: .selected)
                
                if btnTitle.caseInsensitiveCompare(self?.btnMale.titleLabel?.text ?? "") == .orderedSame {
                    self?.btnMale.setImage(#imageLiteral(resourceName: "ic_radio_selected"), for: .normal)
                    self?.btnMale.setImage(#imageLiteral(resourceName: "ic_radio_selected"), for: .selected)
                }
                else if btnTitle.caseInsensitiveCompare(self?.btnFemale.titleLabel?.text ?? "") == .orderedSame {
                    self?.btnFemale.setImage(#imageLiteral(resourceName: "ic_radio_selected"), for: .normal)
                    self?.btnFemale.setImage(#imageLiteral(resourceName: "ic_radio_selected"), for: .selected)
                }
            } onCompleted: {
                
            } onDisposed: {
                
            }.disposed(by: self.disposeBag)
           

        
        viewModel.formValidation
            .asDriver(onErrorJustReturn: false)
            .drive { (bResult) in
                self.btnSignUp.isEnabled = bResult
                self.btnSignUp.alpha = !bResult ? 0.2 : 1.0
            }.disposed(by: disposeBag)
        
    }
    
    @IBAction private func btnProfileSelect(_ sender: UIButton) {
        self.openImagePicker()
    }
    
    @IBAction func btnSignUpClick(_ sender: UIButton) {
        //self.showAlert("validation Done")
        if self.isForUpdate {
            if viewModel.updateData(self.signupModel.id ?? 0) {
                self.showAlertObserver("Record updated successfully.")
                    .asDriver(onErrorJustReturn: UIAlertAction())
                    .drive { (btnAction) in
                        self.navigationController?.popViewController(animated: true)
                    }.disposed(by: disposeBag)

            }
        }
        else {
            if viewModel.saveToDetails() {
            
            self.showYesNoAlertWithObserver(with: "Data saved Successfully would you like to add new record.?")
                .asDriver(onErrorJustReturn: UIAlertAction())
                .drive { [unowned self] (btnAction) in
                    
                    if btnAction.title == AlertActionTitle.yes.rawValue {
                        self.txtUsername.text = ""
                        self.txtEmail.text = ""
                        self.txtContactNumber.text = ""
                        self.txtPassword.text = ""
                        self.txtConfirmPassword.text = ""
                        
                        self.btnMale.setImage(#imageLiteral(resourceName: "ic_radio_selected"), for: .normal)
                        self.btnMale.setImage(#imageLiteral(resourceName: "ic_radio_selected"), for: .selected)
                        
                        self.btnFemale.setImage(#imageLiteral(resourceName: "ic_radio_unselected"), for: .normal)
                        self.btnFemale.setImage(#imageLiteral(resourceName: "ic_radio_unselected"), for: .selected)
                        self.imgProfile.image = UIImage(named: SignupErrorMsg.placeHolderimage)
                        
                    }
                    else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }.disposed(by: self.disposeBag)
            }
            else {
                self.showAlert("Please try again something went wrong.!!")
            }
            
        }
    }
    
    func openImagePicker() {
        
        self.openCameraPicker()
            .asDriver(onErrorJustReturn: UIAlertAction())
            .drive { (selectedAction) in
                if selectedAction.title == AlertActionTitle.gallary.rawValue {
                    self.openGallary()
                }
                else if selectedAction.title == AlertActionTitle.camera.rawValue {
                    self.openCamera()
                }
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func openGallary() {
                
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc private func openCamera() {
                
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            if (TARGET_OS_SIMULATOR != 0) {
                self.showAlert("Target is simulator, please check this functionality on device.")
            }
            else {
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        else {
            self.showAlert("Target is simulator, please check this functionality on device.")
        }
    }
}

extension SignupViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selecterdImage = info[.originalImage] as? UIImage {
            self.viewModel.validateFieldsObs(.userProfile, "", selecterdImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
