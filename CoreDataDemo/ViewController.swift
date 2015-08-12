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
    
    struct Constants {
        static let CoreDataEntityName = "Contacts"
        static let NameKey = "name"
        static let PhoneKey = "phone"
        static let AddressKey = "address"
        
        static let NameQuery = "(" + Constants.NameKey + " = %@)"
    }
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    lazy var contacts:NSEntityDescription! = NSEntityDescription.entityForName(Constants.CoreDataEntityName, inManagedObjectContext: self.context)
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func saveContact(sender: UIButton) {
        let contact = Contacts(entity: contacts, insertIntoManagedObjectContext: context)
        
        contact.name = name.text
        contact.address = address.text
        contact.phone = phone.text
        
        do {
            try context.save()
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
        request.entity = contacts
        
        let pred = NSPredicate(format: Constants.NameQuery, name.text!)
        request.predicate = pred
        
        do {
            let results = try context.executeFetchRequest(request) as! [NSManagedObject]
            if results.count > 0 {
                let match = results[0]
                
                name.text = match.valueForKey(Constants.NameKey) as? String
                address.text = match.valueForKey(Constants.AddressKey) as? String
                phone.text = match.valueForKey(Constants.PhoneKey) as? String
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

