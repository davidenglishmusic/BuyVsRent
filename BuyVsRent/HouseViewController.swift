//
//  HouseViewController.swift
//  BuyVsRent
//
//  Created by David English on 2015-12-02.
//  Copyright © 2015 David English. All rights reserved.
//

import UIKit
import CoreData

class HouseViewController: UIViewController {
    
    let roundHelper = 100.0
    
    var houses = [NSManagedObject]()
    
    var housesCheck = [NSManagedObject]()
    
    var currentHouse = [NSManagedObject]()
    
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var purchasePriceField: UITextField!
    @IBOutlet weak var downPaymentField: UITextField!
    @IBOutlet weak var mortgageAmountField: UITextField!
    @IBOutlet weak var interestRateField: UITextField!
    @IBOutlet weak var amortizationField: UITextField!
    @IBOutlet weak var annualAppreciationField: UITextField!
    @IBOutlet weak var annualTaxesField: UITextField!
    @IBOutlet weak var annualMaintenanceField: UITextField!
    @IBOutlet weak var annualInsuranceField: UITextField!
    @IBOutlet weak var sellingCostsField: UITextField!
    @IBOutlet weak var ownershipTimeField: UITextField!
    
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        saveHouse(
            self.addressField.text!, purchasePrice: Double(self.purchasePriceField.text!)!, downPayment: Double(self.downPaymentField.text!)!, mortgageAmount: Double(mortgageAmountField.text!)!, interestRate: Double(self.interestRateField.text!)!, amortization: Int(self.amortizationField.text!)!, annualAppreciation: Double(self.annualAppreciationField.text!)!, annualTaxes: Double(self.annualTaxesField.text!)!, annualMaintenance: Double(self.annualMaintenanceField.text!)!, annualInsurance: Double(self.annualInsuranceField.text!)!, sellingCosts: Double(self.sellingCostsField.text!)!, ownershipTime: Int(self.ownershipTimeField.text!)!
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Property Information"
        
        if currentHouse.count > 0 {
            setFields()
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setFields() {
        let house = currentHouse[0]
        addressField.text = String(house.valueForKey("address")!)
        purchasePriceField.text = String(house.valueForKey("purchasePrice")!)
        downPaymentField.text = String(house.valueForKey("downPayment")!)
        mortgageAmountField.text = String(house.valueForKey("mortgageAmount")!)
        interestRateField.text = String(house.valueForKey("interestRate")!)
        amortizationField.text = String(house.valueForKey("amortization")!)
        annualAppreciationField.text = String(house.valueForKey("annualAppreciation")!)
        annualTaxesField.text = String(house.valueForKey("annualTaxes")!)
        annualMaintenanceField.text = String(house.valueForKey("annualMaintenance")!)
        annualInsuranceField.text = String(house.valueForKey("annualInsurance")!)
        sellingCostsField.text = String(house.valueForKey("sellingCosts")!)
        ownershipTimeField.text = String(house.valueForKey("ownershipTime")!)
    }
    
    func saveHouse(address: String, purchasePrice: Double, downPayment: Double, mortgageAmount: Double, interestRate: Double, amortization: Int, annualAppreciation: Double, annualTaxes: Double, annualMaintenance: Double, annualInsurance: Double, sellingCosts: Double, ownershipTime: Int) {
        
        if currentHouse != [] {
            deleteHouse()
        }
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("House",
            inManagedObjectContext:managedContext)
        
        let house = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        //3
        house.setValue(address, forKey: "address")
        house.setValue(purchasePrice, forKey: "purchasePrice")
        house.setValue(downPayment, forKey: "downPayment")
        house.setValue(mortgageAmount, forKey: "mortgageAmount")
        house.setValue(interestRate, forKey: "interestRate")
        house.setValue(amortization, forKey: "amortization")
        house.setValue(annualAppreciation, forKey: "annualAppreciation")
        house.setValue(annualTaxes, forKey: "annualTaxes")
        house.setValue(annualMaintenance, forKey: "annualMaintenance")
        house.setValue(annualInsurance, forKey: "annualInsurance")
        house.setValue(sellingCosts, forKey: "sellingCosts")
        house.setValue(ownershipTime, forKey: "ownershipTime")

        
        //4
        do {
            try managedContext.save()
            //5
            
            houses.append(house)
            
            // setCurrentHouse
            if currentHouse != [] {
                currentHouse[0] = house
            }
            else {
                currentHouse.append(house)
            }
            
            displayHouseSaveConfirmation()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func displayHouseSaveConfirmation() {
        let alertController = UIAlertController(title: "BuyVsRent", message:
            "The house information has been saved", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func deleteHouse(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "House")
        
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            houses = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        managedContext.deleteObject(currentHouse[0])
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func respondToDeleteButton(sender: AnyObject) {
        if (currentHouse.count > 0) {
            confirmDelete()
        }
        else {
            let alertController = UIAlertController(title: "BuyVsRent", message:
                "A house must be saved first before it can be deleted", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func confirmDelete() {
        let confirmAlert = UIAlertController(title: "BuyVsRent", message: "This house will be deleted.", preferredStyle: UIAlertControllerStyle.Alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Confirm Deletion", style: .Default, handler: { (action: UIAlertAction!) in
            self.deleteHouse()
            self.navigationController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            if let navController = self.navigationController {
                navController.popViewControllerAnimated(true)
            }
        }))
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        
        presentViewController(confirmAlert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        if (segue.identifier == "segueToRecommendation") {
            if let recommendationViewController = segue.destinationViewController as? RecommendationViewController {
                recommendationViewController.houses = currentHouse
            }
        }
    }
    
    
    @IBAction func respondToPurchasePriceField(sender: AnyObject) {
        setMortgageField()
    }
    
    @IBAction func respondToDownPaymentField(sender: AnyObject) {
        setMortgageField()
    }
    
    func setMortgageField() {
        let purchasePrice = Double(self.purchasePriceField.text!)
        let downPayment = Double(self.downPaymentField.text!)
        
        if (purchasePrice != nil && downPayment != nil) {
            self.mortgageAmountField.text = String(round((purchasePrice! - downPayment!) * roundHelper / roundHelper))
        }
    }
    
}
