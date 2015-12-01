//
//  RentCalculator.swift
//  BuyVsRent
//
//  Created by David English on 2015-11-29.
//  Copyright © 2015 David English. All rights reserved.
//

import Foundation

infix operator ** { associativity left precedence 170 }

func ** (num: Double, power: Double) -> Double{
    return pow(num, power)
}

class RentCalculator {
    
    var rateOfReturn: Double?
    var monthlyRent: Double?
    var rentIncreaseRate: Double?
    
    func getTotalRentSpentOverTime(numberOfYears: Int) -> Double{
        var total: Double
        
        total = monthlyRent! * 12
        
        var currentRent = monthlyRent
        
        if numberOfYears > 1 {
            for _ in 2...numberOfYears {
                currentRent = currentRent! * ( 1 + rentIncreaseRate!)
                total += currentRent! * 12
            }
        }
        
        return total
    }
    
    func getTotalValueOfInvestment(downPayment: Double, numberOfYears: Int ) -> Double{
        //  A = P ( 1+r ) ^ t
        return downPayment * ( 1 + rateOfReturn! ) ** Double(numberOfYears)
    }
}