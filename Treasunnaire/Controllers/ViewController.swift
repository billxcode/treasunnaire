//
//  ViewController.swift
//  Treasunnaire
//
//  Created by Bill Tanthowi Jauhari on 19/09/19.
//  Copyright © 2019 Batavia Hack Town. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var link: UITextField!
    @IBOutlet weak var point: UITextField!
    
    var myname = ["bill", "tantowi", "jauhari"]
    @IBOutlet weak var user: UIImageView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var table = tableView.dequeueReusableCell(withIdentifier: "QuestionnaireCell") as? QuestionnaireCell
        
        return table!
    }
    
    @IBAction func gotoUser(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "user", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func showAlert(header: String, message: String)
    {
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func uploadQuestionnaire(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        newUser.setValue(link.text, forKey: "link")
        newUser.setValue(point.text, forKey: "point")
        
        do {
            try context.save()
        } catch {
            print("failed")
        }
        
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}

}

