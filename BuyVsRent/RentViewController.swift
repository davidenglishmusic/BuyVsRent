//
//  RentViewController.swift
//  BuyVsRent
//
//  Created by David English on 2015-12-01.
//  Copyright © 2015 David English. All rights reserved.
//

import UIKit
import CoreData

class RentViewController: UIViewController {
    
    var rents = [NSManagedObject]()
    
    @IBOutlet weak var monthlyRentField: UITextField!
    @IBOutlet weak var annualIncreaseField: UITextField!
    @IBOutlet weak var investmentRateField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    @IBAction func saveButtonPressed(sender: AnyObject) {
        saveRent(Double(self.monthlyRentField.text!)!, annualIncrease: Double(self.annualIncreaseField.text!)!, investmentRate: Double(investmentRateField.text!)!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRent("Rent")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func saveRent(monthlyRent: Double, annualIncrease: Double, investmentRate: Double) {
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Rent",
            inManagedObjectContext:managedContext)
        
        let rent = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        //3
        rent.setValue(monthlyRent, forKey: "monthlyRent")
        rent.setValue(annualIncrease, forKey: "annualIncrease")
        rent.setValue(investmentRate, forKey: "investmentRate")
        
        //4
        
        deletePreviousRent()
        
        do {
            try managedContext.save()
            //5
            rents.append(rent)
            print("Rent is saved")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func deletePreviousRent() {
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext
        let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest(entityName: "Rent")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord.executeRequest(deleteRequest, withContext: context)
        } catch let error as NSError {
            debugPrint(error)
        }
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
                setFields(String(answer[0].valueForKey("monthlyRent")!), annualIncrease: String(answer[0].valueForKey("annualIncrease")!), investmentRate: String(answer[0].valueForKey("investmentRate")!))
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    

    func setFields(monthlyRent: String, annualIncrease: String, investmentRate: String) {
        self.monthlyRentField.text = monthlyRent
        self.annualIncreaseField.text = annualIncrease
        self.investmentRateField.text = investmentRate
    }
    
}
