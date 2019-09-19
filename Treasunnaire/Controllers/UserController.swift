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
    
    var users: [NSManagedObject] = []
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var result: NSFetchRequest<NSFetchRequestResult>!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let table = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        
        table?.email.text = users[indexPath.row].value(forKey: "email") as! String
        table?.name.text = users[indexPath.row].value(forKey: "fullname") as! String
        table?.uuid.text = users[indexPath.row].value(forKey: "password") as! String
        
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
        request.returnsObjectsAsFaults = false
        
        do {
            users = try context.fetch(request)
            
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
