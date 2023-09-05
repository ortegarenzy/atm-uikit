//
//  ResultViewController.swift
//  atm-uikit
//
//  Created by Renzy Ortega on 9/1/23.
//

import UIKit
import Foundation

class ResultViewController: UIViewController {
    
    var amount: Int?
    var delegate: ResultViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let amount else { return }
        print("amount withdrawn \(amount)")
        let result = breakdownAmount(amount)

        for (denomination, count) in result {
            print("\(denomination) x \(count)")
        }
    }
    
    func breakdownAmount(_ amount: Int) -> [Int: Int] {
        var remainingAmount = amount
        var breakdown: [Int: Int] = [:]
        
        let denominations = [1000, 500, 100]
        
        for denomination in denominations {
            let count = remainingAmount / denomination
            if count > 0 {
                breakdown[denomination] = count
                remainingAmount %= denomination
            }
        }
        
        return breakdown
    }
}
