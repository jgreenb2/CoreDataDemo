//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by jeff greenberg on 8/11/15.
//  Copyright © 2015 Jeff Greenberg. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    lazy var contactEntity:NSEntityDescription! = NSEntityDescription.entityForName("Contacts", inManagedObjectContext: self.managedObjectContext)
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func getFoo() -> Int { return 4 }
    @IBAction func saveContact(sender: UIButton) {
        let contact = Contacts(entity: contactEntity, insertIntoManagedObjectContext: managedObjectContext)
        
        contact.name = name.text
        contact.address = address.text
        contact.phone = phone.text
        
        do {
            try managedObjectContext.save()
            name.text = ""
            address.text = ""
            phone.text = ""
            status.text = ""
        } catch {
            status.text = (error as NSError).localizedDescription
        }
    }
    
    @IBAction func findContact(sender: UIButton) {
        let request = NSFetchRequest()
        request.entity = contactEntity
        
        let pred = NSPredicate(format: "(name = %@)", name.text!)
        request.predicate = pred
        
        do {
            let results = try managedObjectContext.executeFetchRequest(request)
            if results.count > 0 {
                let match = results[0] as! NSManagedObject
                
                name.text = match.valueForKey("name") as? String
                address.text = match.valueForKey("address") as? String
                phone.text = match.valueForKey("phone") as? String
            }
            status.text = "\(results.count) matches found"
        } catch {
            status.text = (error as NSError).localizedDescription
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

