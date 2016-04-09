//
//  SignatureManagedObject.swift
//  MobilologyDateStampTutorial
//
//  Created by Damien Laughton on 09/04/2016.
//  Copyright © 2016 Damien Laughton. All rights reserved.
//

import Foundation
import CoreData


class SignatureManagedObject: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

  // This method date stamps the object. Call this method just before saving
  // A listener has been added to the core data singletion to catch the moc
  // being saved. Just before the moc we should sign each object which has been
  // changed or inserted.
  func sign() {
    let now = NSDate()
    
    if date_created == .None {
      date_created = now
    }
    
    date_modified = now
  }
}
