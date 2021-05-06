//
//  CoreDataModel.swift
//  SignupRxExample
//
//  Created by Mac-00014 on 04/05/21.
//

import Foundation
import UIKit
import CoreData

struct CoreDataModel {
    
    private static let TblSignup = "TblSignup"
    
    @discardableResult
    static func saveDetailsToCoreData(_ signupModel: SignupCoreModel) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let signupEntity = NSEntityDescription.entity(forEntityName: TblSignup, in: managedContext)
        let signupManageModel = NSManagedObject(entity: signupEntity!, insertInto: managedContext)
        
        signupManageModel.setValue(signupModel.id, forKey: "id")
        signupManageModel.setValue(signupModel.username, forKey: "username")
        signupManageModel.setValue(signupModel.email, forKey: "email")
        signupManageModel.setValue(signupModel.password, forKey: "password")
        signupManageModel.setValue(signupModel.phoneNumber, forKey: "phoneNumber")
        signupManageModel.setValue(signupModel.gender, forKey: "gender")
        signupManageModel.setValue(signupModel.profilePhoto, forKey: "profilePhoto")
        
        do {
            try managedContext.save()
            return true
        } catch let coreException {
            print("coreException: \(coreException)")
        }
        
        return false
    }
    
    @discardableResult
    static func updateDetailsToCoreData(_ signupModel: SignupCoreModel) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TblSignup)
        fetchRequest.predicate = NSPredicate(format: "id == %d AND email == %@", (signupModel.id ?? 0), (signupModel.email ?? ""))
        
        do {
            let userListArray = try managedContext.fetch(fetchRequest)
            
            if userListArray.count > 0 {
                let oldUserModel = userListArray[0]
                oldUserModel.setValue(signupModel.id, forKey: "id")
                oldUserModel.setValue(signupModel.username, forKey: "username")
                oldUserModel.setValue(signupModel.email, forKey: "email")
                oldUserModel.setValue(signupModel.password, forKey: "password")
                oldUserModel.setValue(signupModel.phoneNumber, forKey: "phoneNumber")
                oldUserModel.setValue(signupModel.gender, forKey: "gender")
                oldUserModel.setValue(signupModel.profilePhoto, forKey: "profilePhoto")
                
                try managedContext.save()
                
                return true
            }
            
        } catch let fetchException {
            print("fetchException: \(fetchException)")
        }
        
        return false
    }
    
    static func fetchSignupCoreData() -> [SignupCoreModel] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TblSignup)
        
        do {
            let userListArray = try managedContext.fetch(fetchRequest).reversed()
            
            let signupModelArr = userListArray.map { (objectManaged) -> SignupCoreModel in
                
                var signupModel = SignupCoreModel()
                signupModel.id = objectManaged.value(forKey: "id") as? Int64 ?? 0
                signupModel.username = objectManaged.value(forKey: "username") as? String ?? ""
                signupModel.email = objectManaged.value(forKey: "email") as? String ?? ""
                signupModel.phoneNumber = objectManaged.value(forKey: "phoneNumber") as? String ?? ""
                signupModel.gender = objectManaged.value(forKey: "gender") as? String ?? ""
                signupModel.profilePhoto = objectManaged.value(forKey: "profilePhoto") as? Data ?? Data()
                
                return signupModel
            }
            return signupModelArr
            
        } catch let fetchException {
            print("fetchException: \(fetchException)")
        }
        
        return []
    }
    
    static func deleteSignupCoreData(_ signupModel: SignupCoreModel) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TblSignup)
        fetchRequest.predicate = NSPredicate(format: "id == %d AND email == %@", (signupModel.id ?? 0), (signupModel.email ?? ""))
        
        do {
            let userListArray = try managedContext.fetch(fetchRequest)
            
            if userListArray.count > 0 {
                let oldUserModel = userListArray[0]
                managedContext.delete(oldUserModel)
                return true
            }
            
        } catch let fetchException {
            print("fetchException: \(fetchException)")
        }
        
        return false
    }
    
    static func getNextRecordID() -> Int64 {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0 }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TblSignup)
        
        do {
            let userListArray = try managedContext.fetch(fetchRequest).last
            
            if userListArray != nil {
                return (userListArray?.value(forKey: "id") as! Int64)+1
            }
            
        } catch let fetchException {
            print("fetchException: \(fetchException)")
        }
        
        return 0
    }
    
}
