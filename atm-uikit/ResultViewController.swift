//
//  ResultViewController.swift
//  atm-uikit
//
//  Created by Renzy Ortega on 9/1/23.
//

import UIKit
import Foundation

class ResultViewController: UIViewController {
    
    @IBOutlet weak var thousandLabel: UILabel!
    @IBOutlet weak var fiveHundredLabel: UILabel!
    @IBOutlet weak var oneHundredLabel: UILabel!
    var amount: Int?
    var delegate: ResultViewControllerDelegate?
    let thousand: Int = 1000
    let fiveHundred: Int = 500
    let oneHundred: Int = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let amount else { return }
        let result = breakdownAmount(amount)
        let thousandResult = processResult(result: result, type: thousand)
        thousandLabel.text = String(thousandResult)
        let fiveHundredResult = processResult(result: result, type: fiveHundred)
        fiveHundredLabel.text = String(fiveHundredResult)
        let oneHundredResult = processResult(result: result, type: oneHundred)
        oneHundredLabel.text = String(oneHundredResult)
    }
    
    func processResult(result: [Int: Int], type: Int) -> Int {
        guard let amount = result[type] else { return 0 }
        return amount
    }
    
    func breakdownAmount(_ amount: Int) -> [Int: Int] {
        var remainingAmount = amount
        var breakdown: [Int: Int] = [:]
        
        let denominations = [thousand, fiveHundred, oneHundred]
        
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
