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
    
    var houses = [NSManagedObject]()
    
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
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveHouse(address: String, purchasePrice: Double, downPayment: Double, mortgageAmount: Double, interestRate: Double, amortization: Int, annualAppreciation: Double, annualTaxes: Double, annualMaintenance: Double, annualInsurance: Double, sellingCosts: Double, ownershipTime: Int) {
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

}
