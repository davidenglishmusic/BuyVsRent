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
    @IBOutlet weak var buyMPLabel: UILabel!
    @IBOutlet weak var rentMPLabel: UILabel!
    @IBOutlet weak var buyMFLabel: UILabel!
    @IBOutlet weak var rentMFLabel: UILabel!
    @IBOutlet weak var buyMTLabel: UILabel!
    @IBOutlet weak var rentMTLabel: UILabel!
    @IBOutlet weak var buyYTLabel: UILabel!
    @IBOutlet weak var rentYTLabel: UILabel!
    
    @IBOutlet weak var fhvLabel: UILabel!
    @IBOutlet weak var rmvLabel: UILabel!
    @IBOutlet weak var scvLabel: UILabel!
    
    @IBOutlet weak var fhLabel: UILabel!
    @IBOutlet weak var fiLabel: UILabel!
    
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
