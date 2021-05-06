//
//  UserListViewController.swift
//  SignupRxExample
//
//  Created by Mac-00014 on 04/05/21.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

class UserListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var errorView: UIView!
    
    private var userList: [SignupCoreModel] = []
    
    private var viewModel: UserListViewModel!
    private let disposebag = DisposeBag()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = UserListViewModel()
        self.navigationDesgin()
        
        self.initialise()
        self.designErrorView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bindView()
    }
    
    private func bindView() {
        
        self.viewModel.bindDataToObserver()
        
        self.viewModel
            .tblUserSignUpModelObs
            .asDriver(onErrorJustReturn: [])
            .drive { (arrUserData) in
                self.userList = arrUserData
                self.tableView.reloadData()
            }.disposed(by: self.disposebag)

        /*
        self.viewModel
            .tblUserSignUpModelObs
            .bind(to: self.tableView.rx.items(cellIdentifier: "UserListCell")) { (iRow : Int, itemDatga : SignupCoreModel, userSignupCell : UserListCell) in
                userSignupCell.bindView(itemDatga)
            }.disposed(by: self.disposebag)*/
            
        self.viewModel
            .errorViewObs
            .asObservable()
            .asDriver(onErrorJustReturn: false)
            .drive { (result) in
                self.errorView.isHidden = result
            }.disposed(by: self.disposebag)
        
    }
    
    private func initialise() {
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func designErrorView() {
        
        self.errorView.isHidden =  userList.count > 0
    }
    
    private func navigationDesgin() {
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openFormScreen))
        self.navigationItem.rightBarButtonItems = [rightButton]
    }
    
    @objc private  func openFormScreen() {
        
        if let signupVc = self.storyboard?.instantiateViewController(identifier: "SignupViewController") as? SignupViewController {
            self.navigationController?.pushViewController(signupVc, animated: true)
        }
    }
    
    @IBAction private func btnAddnewTapped(_ sender: UIButton) {
        self.openFormScreen()
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as! UserListCell
        
        cell.bindView(self.userList[indexPath.row])
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let signupVc = self.storyboard?.instantiateViewController(identifier: "SignupViewController") as? SignupViewController {
            signupVc.isForUpdate = true
            signupVc.signupModel = self.userList[indexPath.row]
            self.navigationController?.pushViewController(signupVc, animated: true)
        }
    }
    
    /*
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            print("deleteAction Clicked")
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            print("editAction Clicked")
        }
        editAction.backgroundColor = .green

        return [editAction, deleteAction]
    }*/
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if  editingStyle == .delete {
            self.showYesNoAlertWithObserver(with: "Are you sure wants to delete this record.")
                .asObservable()
                .asDriver(onErrorJustReturn: UIAlertAction())
                .drive { [weak self] (btnAction) in
                    if btnAction.title == AlertActionTitle.yes.rawValue {
                        self?.viewModel.removeUserRecord((self?.userList[indexPath.item])!)
                    }
                }.disposed(by: self.disposebag)

        }
        
    }
       
}
