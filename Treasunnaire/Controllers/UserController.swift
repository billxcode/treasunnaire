//
//  UserController.swift
//  Treasunnaire
//
//  Created by Bill Tanthowi Jauhari on 19/09/19.
//  Copyright © 2019 Batavia Hack Town. All rights reserved.
//

import UIKit
import CoreData

class UserController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var email: UILabel!
    
    var users: [NSManagedObject] = []
    var questionnaire: [NSManagedObject] = []
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionnaire.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let table = tableView.dequeueReusableCell(withIdentifier: "UserQuestionnaireCell") as? UserQuestionnaireCell
//        let table = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        
        table?.fullname.text = questionnaire[indexPath.row].value(forKey: "fullname") as! String
        table?.point.text = questionnaire[indexPath.row].value(forKey: "point") as! String
        table?.link.text = questionnaire[indexPath.row].value(forKey: "link") as! String

//        table?.email.text = users[indexPath.row].value(forKey: "email") as! String
//        table?.name.text = users[indexPath.row].value(forKey: "fullname") as! String
//        table?.uuid.text = users[indexPath.row].value(forKey: "password") as! String
//
        return table!
        
    }
    
    @IBAction func logout(_ sender: UIButton) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Session")
        
        let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(batchDelete)
        } catch {
            print("failed logout")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "User")
        let session = NSFetchRequest<NSManagedObject>(entityName: "Session")
        let quest = NSFetchRequest<NSManagedObject>(entityName: "Questionnaire")
        let sorting = NSSortDescriptor(key: "time", ascending: false)
        quest.sortDescriptors = [sorting]
        
        quest.returnsObjectsAsFaults = false
        session.returnsObjectsAsFaults = false
        request.returnsObjectsAsFaults = false
    
        do {
            users = try context.fetch(request)
            let credential = try context.fetch(session)
            fullname.text = credential[0].value(forKey: "fullname") as! String
            email.text = credential[0].value(forKey: "email") as! String
            
            quest.predicate = NSPredicate(format: "email = %@", email.text ?? "admin")
            questionnaire = try context.fetch(quest)
            
        } catch {
            print("Failed")
        }
        // Do any additional setup after loading the view.
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
