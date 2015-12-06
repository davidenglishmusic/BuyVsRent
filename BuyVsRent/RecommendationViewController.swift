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
    
    @IBOutlet weak var guideTotalOverXYearsLabel: UILabel!
    @IBOutlet weak var afterXYearsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRent("Rent")
        setLabels()
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
            rents = results as! [NSManagedObject]
            if rents == [] {
                print("no rent entities currently exist")
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func setLabels() {
        let years = houses[0].valueForKey("ownershipTime") as! Int
        let monthlyRent = rents[0].valueForKey("monthlyRent") as! Double
        setLabelsWithYears(String(years))
        setRentLabelsInFirstArea(monthlyRent, years: years)
        setBuyLabelsInFirstArea(years)
        
    }
    
    func setLabelsWithYears(years: String) {
        self.guideTotalOverXYearsLabel.text = "Total over \(years) years"
        self.afterXYearsLabel.text = "After \(years) years"
    }
    
    func setRentLabelsInFirstArea(monthlyRent: Double, years: Int) {
        
        self.rentMPLabel.text = String(monthlyRent)
        self.rentMFLabel.text = "--"
        self.rentMTLabel.text = String(monthlyRent)
        self.rentYTLabel.text = String(calculateRentOverTime(monthlyRent, years: years))
    }
    
    func setBuyLabelsInFirstArea(years: Int) {
        let monthlyMP = calculateMortgagePayment()
        let monthlyFees = calculateMonthlyFees()
        self.buyMPLabel.text = String(round((monthlyMP * 100) / 100))
        self.buyMFLabel.text = String(round((monthlyFees * 100) / 100 ))
        self.buyMTLabel.text = String(round(((monthlyMP + monthlyFees) * 100) / 100 ))
        self.buyYTLabel.text = String(round(((monthlyMP + monthlyFees) * Double(years) * 12 * 100) / 100 ))
    }
    
    func calculateMortgagePayment() -> Double {
        let loanAmount = houses[0].valueForKey("mortgageAmount") as! Double
        let monthlyInterest = ((houses[0].valueForKey("interestRate") as! Double) * 0.01 / 12)
        let totalMonths = houses[0].valueForKey("amortization") as! Double * 12
        
        let top = monthlyInterest * pow(1 + monthlyInterest, totalMonths)
        let bottom = pow((1 + monthlyInterest), totalMonths) - 1
        
        return loanAmount * top / bottom
    }
    
    func calculateMonthlyFees() -> Double {
        let monthlyTaxes = (houses[0].valueForKey("annualTaxes") as! Double) / 12
        let monthlyMaintenance = (houses[0].valueForKey("annualMaintenance") as! Double) / 12
        let monthlyInsurance = (houses[0].valueForKey("annualInsurance") as! Double) / 12
        return monthlyTaxes + monthlyMaintenance + monthlyInsurance
    }
    
    func calculateRentOverTime(monthlyRent: Double, years: Int) -> Double {
        // TO DO NEXT
        return 0
    }

}
