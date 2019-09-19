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
    
    @IBAction func signIn(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let email = NSPredicate(format: "email = %@", self.email.text ?? "admin")
        let password = NSPredicate(format: "password = %@", self.password.text ?? "admin")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [email, password])
        request.predicate = compoundPredicate
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                self.showAlert(header: "Thankyou", message: "Success Login")
            } else {
                self.showAlert(header: "Sorry :(", message: "email atau password salah")
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
    
    @IBAction func unwindToSignin(segue: UIStoryboardSegue) {}
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
