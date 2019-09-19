//
//  SignupController.swift
//  Treasunnaire
//
//  Created by Bill Tanthowi Jauhari on 19/09/19.
//  Copyright © 2019 Batavia Hack Town. All rights reserved.
//

import UIKit
import CoreData

class SignupController: UIViewController {
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
        
        newUser.setValue(self.fullname.text, forKey: "fullname")
        newUser.setValue(self.email.text, forKey: "email")
        newUser.setValue(self.password.text, forKey: "password")
        
        do {
            try context.save()
        } catch {
            print("failed saving")
        }
        
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
