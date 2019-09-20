//
//  ViewController.swift
//  Treasunnaire
//
//  Created by Bill Tanthowi Jauhari on 19/09/19.
//  Copyright © 2019 Batavia Hack Town. All rights reserved.
//

import UIKit
import CoreData
import PusherSwift
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var link: UITextField!
    @IBOutlet weak var point: UITextField!
    @IBOutlet weak var listQuestionnaire: UITableView!
    
    var questionnaire: [NSManagedObject] = []
    let locationManager = CLLocationManager()
    var selectedData: String!
    
    @IBOutlet weak var user: UIImageView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionnaire.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var table = tableView.dequeueReusableCell(withIdentifier: "QuestionnaireCell") as? QuestionnaireCell
        table?.fullname.text = questionnaire[indexPath.row].value(forKey: "fullname") as! String
        table?.point.text = questionnaire[indexPath.row].value(forKey: "point") as! String
        table?.link.text = questionnaire[indexPath.row].value(forKey: "link") as! String
        
        return table!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedData = questionnaire[indexPath.row].value(forKey: "link") as! String
        if selectedData != nil {
            performSegue(withIdentifier: "WebView", sender: nil)
        }
    }
    
    @IBAction func gotoUser(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "user", sender: nil)
    }
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataQuestionnaire()
        
        
        let options = PusherClientOptions(
            host: .cluster("mt1")
        )
        
        let pusher = Pusher(
            key: "c221cf0e1dbaa860aa80",
            options: options
        )
        
        // subscribe to channel and bind to event
        let channel = pusher.subscribe("billchannel")
        
        let _ = channel.bind(eventName: "billevent", callback: { (data: Any?) -> Void in
            if let data = data as? [String : AnyObject] {
                if let message = data["message"] as? String {
                    print(message)
                }
            }
        })
        
        pusher.connect()
        // Do any additional setup after loading the view.
        
        
        
        // indoor localization
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            setUpGeofenceForIosda()
        }
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
        
        if validateFormValue() {
            
            let credential = NSFetchRequest<NSManagedObject>(entityName: "Session")
            
            credential.returnsObjectsAsFaults = false
            
            let entity = NSEntityDescription.entity(forEntityName: "Questionnaire", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            
            do {
                let result = try context.fetch(credential)
                
                newUser.setValue(link.text, forKey: "link")
                newUser.setValue(point.text, forKey: "point")
                newUser.setValue(result[0].value(forKey: "email"), forKey: "email")
                newUser.setValue(result[0].value(forKey: "fullname"), forKey: "fullname")
                newUser.setValue(String(Int64(NSDate().timeIntervalSince1970 * 1000)), forKey: "time")
            } catch {
                print("failed fetch session")
            }
            
            do {
                try context.save()
                fetchDataQuestionnaire()
                listQuestionnaire.reloadData()
                clearForm()
                showAlert(header: "Hurray :)", message: "success save questionnaire")
                
            } catch {
                print("failed save questionnaire")
            }
        } else {
            showAlert(header: "Sorry :( ", message: "Anda belum memasukkan data")
        }
        
    }
    
    func validateFormValue() -> Bool
    {
        let link = self.link.text
        let point = self.point.text
        
        if link == "" || point == "" {
            return false
        }
        
        return true
    }
    
    func clearForm()
    {
        self.link.text = ""
        self.point.text = ""
    }
    
    func fetchDataQuestionnaire()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let list = NSFetchRequest<NSManagedObject>(entityName: "Questionnaire")
//        let list = NSFetchRequest<NSFetchRequestResult>(entityName: "Questionnaire")
//        let delete = NSBatchDeleteRequest(fetchRequest: list)
//
//        do {
//            try context.execute(delete)
//        } catch {
//
//        }
//
        list.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
        list.returnsObjectsAsFaults = false

        do {
            questionnaire = try context.fetch(list)
            print("success fetch questionnaire")
        } catch {
            print("failed fetch questionnaire")
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
//        testLabel.text = locValue.longitude.description
    }
    
    func setUpGeofenceForIosda() {
        let geofenceRegionCenter = CLLocationCoordinate2DMake(-6.302336, 106.652397);
        let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 1, identifier: "IosdaClass");
        geofenceRegion.notifyOnExit = true;
        geofenceRegion.notifyOnEntry = true;
        self.locationManager.startMonitoring(for: geofenceRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Welcome to Playa Grande! If the waves are good, you can try surfing!")
        
        let alert = UIAlertController(title: "Alert", message: "Welcome to Playa Grande! If the waves are good, you can try surfing!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        // Good place to schedule a local notification
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Bye! Hope you had a great day at the beach!")
        // Good place to schedule a local notification
        
        let alert = UIAlertController(title: "Alert", message: "Bye! Hope you had a great day at the beach!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WebView" {
            if let destinationVC = segue.destination as? WebController {
                destinationVC.urlDefault = selectedData
            }
        }
    }

}

