//
//  RecommendationViewController.swift
//  BuyVsRent
//
//  Created by David English on 2015-12-05.
//  Copyright © 2015 David English. All rights reserved.
//

import UIKit
import CoreData

class RecommendationViewController: UIViewController {
    
    var houses = [NSManagedObject]()
    var rents = [NSManagedObject]()
    
    @IBOutlet weak var recommendationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRent("Rent")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadRent(entity: String) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: entity)
        
        //3
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            let answer = results as! [NSManagedObject]
            if answer == [] {
                print("no rent entities currently exist")
            }
            else {
                print(answer[0])
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

}
