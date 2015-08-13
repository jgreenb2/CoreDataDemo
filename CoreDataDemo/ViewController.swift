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
        
        //static let NameQuery = "(" + Constants.NameKey + " = %@)"
        static let StoredNameQuery = "FetchByName"
        static let StoredNameQueryVariable = "FULL_NAME"
    }
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    lazy var model:NSManagedObjectModel! = self.context.persistentStoreCoordinator?.managedObjectModel
    lazy var contacts:NSEntityDescription! = NSEntityDescription.entityForName(Constants.CoreDataEntityName, inManagedObjectContext: self.context)
    var queryResults = [NSManagedObject]()
    var currentRecord = 0
    
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
            resetQueryForm()
         } catch {
            status.text = (error as NSError).localizedDescription
        }
    }
    
    @IBAction func findContact(sender: UIButton) {
//        let request = NSFetchRequest()
//        request.entity = contacts
//        
//        let pred = NSPredicate(format: Constants.NameQuery, name.text!)
//        request.predicate = pred

        if let request = model?.fetchRequestFromTemplateWithName(Constants.StoredNameQuery, 
                         substitutionVariables: [Constants.StoredNameQueryVariable:name.text!]) {
                do {
                    if let results = try context.executeFetchRequest(request) as? [NSManagedObject] where results.count > 0 {
                        queryResults = results
                        currentRecord = 0
                        updateResults()
                    } else {
                        resetQueryForm()
                        status.text = "No records found"
                    }
                } catch {
                    status.text = (error as NSError).localizedDescription
                }
        }
    }
    
    @IBAction func nextRecord(sender: UIButton) {
        var inc: Int {
            return sender.currentTitle == "<<" ?  -1 :  1
        }
        if case 0..<queryResults.count = (currentRecord+inc) {
            currentRecord += inc
            updateResults()
        }
    }
    
    func updateResults() {
        name.text = queryResults[currentRecord].valueForKey(Constants.NameKey) as? String
        address.text = queryResults[currentRecord].valueForKey(Constants.AddressKey) as? String
        phone.text = queryResults[currentRecord].valueForKey(Constants.PhoneKey) as? String
        status.text = "Showing record \(currentRecord+1) of \(queryResults.count)"
    }
    
    func resetQueryForm() {
        queryResults.removeAll()
        name.text = ""
        address.text = ""
        phone.text = ""
        status.text = " "
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

