//
//  UserListViewModel.swift
//  SignupRxExample
//
//  Created by Mac-00014 on 04/05/21.
//

import Foundation
import RxSwift
import RxCocoa

struct UserListViewModel {
    
    var tblUserSignUpModelObs : Observable<[SignupCoreModel]> {
        return tblUpdateObserver.asObservable()
    }
    
    var errorViewObs : Observable<Bool> {
        return errorViewObserver.asObservable()
    }
    
    private let tblUpdateObserver = BehaviorRelay<[SignupCoreModel]>(value: [])
    private let errorViewObserver = BehaviorRelay<Bool>(value: false)
    private let disposebag = DisposeBag()
    
    func bindDataToObserver() {
        self.tblUpdateObserver.accept(CoreDataModel.fetchSignupCoreData())
        self.errorViewObserver.accept(CoreDataModel.fetchSignupCoreData().count > 0)
    }
    
    func removeUserRecord(_ viewUserModel: SignupCoreModel) {
        if CoreDataModel.deleteSignupCoreData(viewUserModel) {
            bindDataToObserver()
        }
    }
    
}
