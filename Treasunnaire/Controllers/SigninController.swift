//
//  SigninController.swift
//  Treasunnaire
//
//  Created by Bill Tanthowi Jauhari on 19/09/19.
//  Copyright © 2019 Batavia Hack Town. All rights reserved.
//

import UIKit
import CoreData

class SigninController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Session")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            if result.count > 0 {
                print("session existed")
                performSegue(withIdentifier: "home", sender: nil)
            }
        } catch {
            print("no sessions found")
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        let email = NSPredicate(format: "email = %@", self.email.text ?? "admin")
        let password = NSPredicate(format: "password = %@", self.password.text ?? "admin")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [email, password])
        request.predicate = compoundPredicate
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            DispatchQueue.main.async {
                if result.count > 0 {
                    let result_email = result[0].value(forKey: "email") as! String
                    let result_fullname = result[0].value(forKey: "fullname") as! String
                    let result_password = result[0].value(forKey: "password") as! String
                    
                    self.saveLoginSession(email: result_email, fullname: result_fullname, password: result_password)
                    
                    self.performSegue(withIdentifier: "home", sender: nil)
                } else {
                    self.showAlert(header: "Sorry :(", message: "email atau password salah")
                }
            }
            
        } catch {
            print("Failed")
        }
    }
    
    func showAlert(header: String, message: String)
    {
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    func saveLoginSession(email: String, fullname: String, password: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Session", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        newUser.setValue(email, forKey: "email")
        newUser.setValue(fullname, forKey: "fullname")
        newUser.setValue(password, forKey: "password")
        
        do {
            try context.save()
            print(email, fullname, password)
            print("session saved")
        } catch {
            print("failed")
        }
    }
    
    @IBAction func unwindToSignin(segue: UIStoryboardSegue) {}
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

}
