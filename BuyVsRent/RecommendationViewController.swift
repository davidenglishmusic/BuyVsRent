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
    
    let monthsInYear = 12.0
    let roundHelper = 100.0
    let getPercentHelper = 0.01
    
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
        self.title = "Recommendation"
        
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
        setFutureHouseLabelsArea(years)
        setGainsArea(years)
        setRecommendation(years)
    }
    
    func setLabelsWithYears(years: String) {
        self.guideTotalOverXYearsLabel.text = "Total over \(years) years"
        self.afterXYearsLabel.text = "After \(years) years"
    }
    
    func setRentLabelsInFirstArea(monthlyRent: Double, years: Int) {
        
        self.rentMPLabel.text = String(monthlyRent)
        self.rentMFLabel.text = "--"
        self.rentMTLabel.text = String(monthlyRent)
        self.rentYTLabel.text = String((round(calculateRentOverTime(monthlyRent, years: years) * roundHelper) / roundHelper))
    }
    
    func setBuyLabelsInFirstArea(years: Int) {
        let monthlyMP = calculateMortgagePayment()
        let monthlyFees = calculateMonthlyFees()
        self.buyMPLabel.text = String(round((monthlyMP * roundHelper) / roundHelper))
        self.buyMFLabel.text = String(round((monthlyFees * roundHelper) / roundHelper))
        self.buyMTLabel.text = String(round(((monthlyMP + monthlyFees) * roundHelper) / roundHelper))
        self.buyYTLabel.text = String(round(((monthlyMP + monthlyFees) * Double(years) * monthsInYear * roundHelper) / roundHelper))
    }
    
    func calculateMortgagePayment() -> Double {
        let loanAmount = houses[0].valueForKey("mortgageAmount") as! Double
        let monthlyInterest = ((houses[0].valueForKey("interestRate") as! Double) * getPercentHelper / monthsInYear)
        let totalMonths = houses[0].valueForKey("amortization") as! Double * monthsInYear
        
        // A = L[c(1 + c)^n]/[(1 + c)^n - 1]
        
        let top = monthlyInterest * pow(1 + monthlyInterest, totalMonths)
        let bottom = pow((1 + monthlyInterest), totalMonths) - 1
        
        return loanAmount * top / bottom
    }
    
    func calculateMonthlyFees() -> Double {
        let monthlyTaxes = (houses[0].valueForKey("annualTaxes") as! Double) / monthsInYear
        let monthlyMaintenance = (houses[0].valueForKey("annualMaintenance") as! Double) / monthsInYear
        let monthlyInsurance = (houses[0].valueForKey("annualInsurance") as! Double) / monthsInYear
        return monthlyTaxes + monthlyMaintenance + monthlyInsurance
    }
    
    func calculateRentOverTime(monthlyRent: Double, years: Int) -> Double {
        var total: Double
        
        total = monthlyRent * monthsInYear
        
        if years > 1 {
            var currentRent = monthlyRent
            let rentIncreaseRate = rents[0].valueForKey("annualIncrease") as! Double * getPercentHelper + 1
            for _ in 2...years {
                currentRent = currentRent * (rentIncreaseRate)
                total += currentRent * monthsInYear
            }
        }
        
        return total
    }
    
    func setFutureHouseLabelsArea(years: Int) {
        self.fhvLabel.text = String(round((calculateFutureValueOfHome(years) * roundHelper) / roundHelper))
        self.rmvLabel.text = String(round((calculateRemainingMortgage(years) * roundHelper) / roundHelper))
        self.scvLabel.text = String(round((calculateSellingCosts(years) * roundHelper) / roundHelper))
    }

    func calculateFutureValueOfHome(years: Int) -> Double {
        let initialValue = houses[0].valueForKey("purchasePrice") as! Double
        let appreciationRate = houses[0].valueForKey("annualAppreciation") as! Double * getPercentHelper + 1
        // A = P ( 1+r )^t
        return initialValue * pow(appreciationRate, Double(years))
    }
    
    func calculateRemainingMortgage(years: Int) -> Double {
        let originalMortgage = houses[0].valueForKey("mortgageAmount") as! Double
        let monthlyInterest = ((houses[0].valueForKey("interestRate") as! Double) * getPercentHelper / monthsInYear + 1 )
        let totalMonths = houses[0].valueForKey("amortization") as! Double * monthsInYear
        
        // B = L[(1 + c)^n - (1 + c)^p]/[(1 + c)^n - 1]
        
        let firstSection = pow(monthlyInterest,totalMonths) - pow(monthlyInterest,Double(years) * monthsInYear)
        let secondSection = pow(monthlyInterest,totalMonths) - 1
        return originalMortgage * firstSection / secondSection
    }
    
    func calculateSellingCosts(years: Int) -> Double {
        let sellingCosts = houses[0].valueForKey("sellingCosts")! as! Double * getPercentHelper
        return calculateFutureValueOfHome(years) * sellingCosts
    }
    
    func setGainsArea(years: Int) {
        let finalValueOfHome = calculateFutureValueOfHome(years) - calculateRemainingMortgage(years) - calculateSellingCosts(years)
        self.fhLabel.text = String(round((finalValueOfHome * roundHelper) / roundHelper))
        self.fiLabel.text = String(round((calculateFutureInvestmentValue(years) * roundHelper) / roundHelper))
    }
    
    func calculateFutureInvestmentValue(years: Int) -> Double {
        // A = P ( 1+r )^t
        let downPayment = houses[0].valueForKey("downPayment") as! Double
        let investmentRate = rents[0].valueForKey("investmentRate") as! Double * getPercentHelper + 1
        let downPaymentFutureValue = downPayment * pow(investmentRate , Double(years))
        let additionalRentFutureValue = calculateRentDifferenceInvestment(years, investmentRate: investmentRate)
        return downPaymentFutureValue + additionalRentFutureValue
    }
    
    func calculateRentDifferenceInvestment(years: Int, investmentRate: Double) -> Double {
        var total = 0.0
        let totalMonthlyMortgagePayment = calculateMortgagePayment() + calculateMonthlyFees()
        if (totalMonthlyMortgagePayment < rents[0].valueForKey("monthlyRent") as! Double) {
            return total
        }
        
        let monthlyRent = rents[0].valueForKey("monthlyRent") as! Double

        var difference = totalMonthlyMortgagePayment - monthlyRent
        
        let investmentRate = rents[0].valueForKey("investmentRate") as! Double * getPercentHelper + 1
        
        total += difference * monthsInYear * investmentRate
        
        if (years > 1) {
            var currentRent = monthlyRent
            let rentIncreaseRate = rents[0].valueForKey("annualIncrease") as! Double * getPercentHelper + 1
            for _ in 2...years {
                currentRent = currentRent * (rentIncreaseRate)
                difference = totalMonthlyMortgagePayment - currentRent
                if difference < 0 {
                    break
                }
                total += difference * 12
                total *= investmentRate
            }
        }
        
        return total
    }
    
    func setRecommendation(years: Int) {
        if (calculateFutureInvestmentValue(years) > calculateFutureValueOfHome(years) - calculateRemainingMortgage(years) - calculateSellingCosts(years)) {
            self.recommendationLabel.text = "Rent"
        }
        else {
            self.recommendationLabel.text = "Buy"
        }
    }
    
    
    
}
