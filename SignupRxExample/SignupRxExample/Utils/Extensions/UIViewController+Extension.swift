//
//  UIViewController+Extension.swift
//  SignupRxExample
//
//  Created by Mac-00014 on 29/04/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum AlertActionTitle : String {
    case gallary = "Gallary"
    case camera = "Camera"
    case yes = "Yes"
    case no = "No"
    case ok = "Ok"
}

extension UIViewController {

    func showAlert(_ strMsg : String) {
        let objAlertController = UIAlertController(title: "", message: strMsg, preferredStyle: .alert)
        let objCancelaction = UIAlertAction(title: AlertActionTitle.ok.rawValue, style: .cancel, handler: nil)
        objAlertController.addAction(objCancelaction)
        self.present(objAlertController, animated: true, completion: nil)
    }
    
    func showAlertObserver(_ titleMsg : String) -> Observable<UIAlertAction> {
        
        return Observable.create { observer in
            
            let alertController = UIAlertController(title: "", message: titleMsg, preferredStyle: .alert)
            
            let btnAction1 = UIAlertAction(title: AlertActionTitle.ok.rawValue, style: .default) { (btnAction1) in
                observer.onNext(btnAction1)
                observer.onCompleted()
            }
            
            alertController.addAction(btnAction1)
            
            self.present(alertController, animated: true, completion: nil)
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }
    }
    
    func showYesNoAlertWithObserver(with TitleMsg: String) -> Observable<UIAlertAction> {
        
        return Observable.create { observer in
            
            let alertController = UIAlertController(title: "", message: TitleMsg, preferredStyle: .alert)
            
            let btnAction1 = UIAlertAction(title: AlertActionTitle.yes.rawValue, style: .default) { (btnAction1) in
                observer.onNext(btnAction1)
                observer.onCompleted()
            }
            
            let btnAction2 = UIAlertAction(title: AlertActionTitle.no.rawValue, style: .default) { (btnAction2) in
                observer.onNext(btnAction2)
                observer.onCompleted()
            }
            
            alertController.addAction(btnAction1)
            alertController.addAction(btnAction2)
            
            self.present(alertController, animated: true, completion: nil)
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }
    }
    
    func openCameraPicker() -> Observable<UIAlertAction> {
        
        return Observable.create { observer in
            
            let alertController = UIAlertController(title: "", message: "Please choose image option", preferredStyle: .actionSheet)
            
            let gallaryAction = UIAlertAction(title: AlertActionTitle.gallary.rawValue, style: .default) { (btnGallary) in
                observer.onNext(btnGallary)
                observer.onCompleted()
            }
            
            let cameraAction = UIAlertAction(title: AlertActionTitle.camera.rawValue, style: .default) { (btnCamera) in
                observer.onNext(btnCamera)
                observer.onCompleted()
            }
            
            alertController.addAction(gallaryAction)
            alertController.addAction(cameraAction)
            
            self.present(alertController, animated: true, completion: nil)
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }
    }
    
}
