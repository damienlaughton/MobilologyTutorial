//
//  ViewController.swift
//  MobilologyDateStampTutorial
//
//  Created by Damien Laughton on 30/03/2016.
//  Copyright © 2016 Damien Laughton. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    let pounds = Double(1 + arc4random_uniform(100))
    let pence = Double(1 + arc4random_uniform(99))
    let price = pounds + (pence / 100)
    
    persistNewQuote(price)
    
    for quote in retrieveQuotes() {
      print("price [£\(quote.price!)] date_created [\(quote.date_created!)] date_modified [\(quote.date_modified!)]")
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Core Data
  
  // Insert a new QuoteManagedObject in Core Data
  func persistNewQuote(price: Double) {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let moc = appDelegate.managedObjectContext
    
    if let quoteEntity = NSEntityDescription.entityForName("QuoteManagedObject", inManagedObjectContext: moc) {
      
      if let newQuoteManagedObject = NSManagedObject(entity: quoteEntity,
                                                    insertIntoManagedObjectContext: moc) as? QuoteManagedObject {
        
        newQuoteManagedObject.price = price
        
        appDelegate.saveContext()
      }
    }
    

    
  }
  
  // Get all the quotes that have ever been persisted
  func retrieveQuotes() -> [QuoteManagedObject] {
    var retrievedQuotes:[QuoteManagedObject] = []
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let moc = appDelegate.managedObjectContext
      
    let fetchRequest = NSFetchRequest(entityName: "QuoteManagedObject")
    
    do {
      let results =
        try moc.executeFetchRequest(fetchRequest)
      retrievedQuotes = results as! [QuoteManagedObject]
    } catch let error as NSError {
      print("Could not fetch \(error), \(error.userInfo)")
    }
    
    return retrievedQuotes
  }


}

