//
//  SignupController.swift
//  Treasunnaire
//
//  Created by Bill Tanthowi Jauhari on 19/09/19.
//  Copyright © 2019 Batavia Hack Town. All rights reserved.
//

import UIKit
import CoreData

class SignupController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var retypePassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignUp(_ sender: UIButton) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        let fullname = self.fullname.text ?? ""
        let email = self.email.text ?? ""
        let password = self.password.text ?? ""
        let retype = self.retypePassword.text ?? ""
        
        let result = self.checkField(fullname: fullname, email: email, password: password, retype: retype)
        
        
        if result == "success" {
            
            newUser.setValue(self.fullname.text?.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "fullname")
            newUser.setValue(self.email.text?.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "email")
            newUser.setValue(self.password.text?.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "password")
            
            do {
                try context.save()
                self.showAlert(header: "Success", message: "Thankyou for joining us :) \n Please Login")
            } catch {
                self.showAlert(header: "Iam Sorry", message: "You are not joining us yet")
            }
            
        } else {
            self.showAlert(header: "Sorry", message: result)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        retypePassword.resignFirstResponder()
        return true
    }
    
    func checkField(fullname: String, email: String, password: String, retype: String) -> String
    {
        if fullname == "" {
            return "Anda belum mengisi nama";
        }else if email == "" {
            return "Anda belum mengisi email";
        }else if password == "" {
            return "anda belum mengisi password"
        }else if retype != password {
            return "password yang anda masukkan tidak sama"
        }
        
        return "success";
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func showAlert(header: String, message: String)
    {
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
            self.performSegue(withIdentifier: "unwindToSignin", sender: nil)
        }))
        
        self.present(alert, animated: true)
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
