//
//  SignatureManagedObject+CoreDataProperties.swift
//  MobilologyDateStampTutorial
//
//  Created by Damien Laughton on 09/04/2016.
//  Copyright © 2016 Damien Laughton. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SignatureManagedObject {

    @NSManaged var date_created: NSDate?
    @NSManaged var date_modified: NSDate?

}
