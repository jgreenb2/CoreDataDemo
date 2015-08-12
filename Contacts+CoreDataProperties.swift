//
//  Contacts+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by jeff greenberg on 8/12/15.
//  Copyright © 2015 Jeff Greenberg. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Contacts {

    @NSManaged var address: String?
    @NSManaged var name: String?
    @NSManaged var phone: String?

}
