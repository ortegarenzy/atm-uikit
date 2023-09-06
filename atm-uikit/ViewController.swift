//
//  ViewController.swift
//  atm-uikit
//
//  Created by Renzy Ortega on 8/31/23.
//

import UIKit

class ViewController: UIViewController, ResultViewControllerDelegate {
    
    // Constants for denominations
    let thousand: Int = 1000
    let fiveHundred: Int = 500
    let oneHundred: Int = 100

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var btnWithdraw: UIButton!
    var availableBills = (thousandBills: 10, fiveHundredBills: 10, oneHundredBills: 10)
    var alert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
    }

    @IBAction func onButtonTapped(_ sender: Any) {
        let amount = Int(self.amountTextField!.text!) ?? 0
        if(amount < 1) {
            alert.message = "Amount should be valid"
            present(alert, animated: true, completion: nil)
            return
        }
        if(amount > 10000) {
            alert.message = "Amount should be below 10,000"
            present(alert, animated: true, completion: nil)
            return
        }
        let withdrawable = isAmountWithdrawable(amount)
        if(!withdrawable) {
            alert.message = "Amount should be withdrawn using \(thousand), \(fiveHundred), \(oneHundred) denominations."
            present(alert, animated: true, completion: nil)
            return
        }
        let (success, withdrawn) = tryToWithdraw(amount: amount, bills: availableBills)
        if(!success) {
            alert.message = "We ran out of bills. Sorry!"
            present(alert, animated: true, completion: nil)
            return
        }
        let viewController = ResultViewController(nibName: "ResultViewController", bundle: Bundle.main)
        viewController.withdrawn = withdrawn
        viewController.delegate = self
        present(viewController, animated: true)
    }
    
    func isAmountWithdrawable(_ amount: Int) -> Bool {
        let denominations = [thousand, fiveHundred, oneHundred]
        var remaining = amount
        for denomination in denominations {
            let numberOfNotes = remaining / denomination
            remaining -= numberOfNotes * denomination
        }
        return remaining == 0
    }
    
    func reset() {
        amountTextField.text = ""
    }

    
    func tryToWithdraw(amount: Int, bills: (thousandBills: Int, fiveHundredBills: Int, oneHundredBills: Int)) -> (Bool, (thousand: Int, fiveHundred: Int, oneHundred: Int)) {
        let availableAmount = (bills.thousandBills * thousand) + (bills.fiveHundredBills * fiveHundred) + (bills.oneHundredBills * oneHundred)
        guard amount <= availableAmount else {
            return (false, (0, 0, 0))
        }
        var remainingAmount = amount
        var remainingBills = (thousandBills: bills.thousandBills, fiveHundredBills: bills.fiveHundredBills, oneHundredBills: bills.oneHundredBills)
        
        let thousandBillsNeeded = computeBillsNeeded(bill: remainingBills.thousandBills, amount: remainingAmount, denomination: thousand)
        remainingBills.thousandBills -= thousandBillsNeeded
        remainingAmount -= thousandBillsNeeded * thousand
        
        let fiveHundredBillsNeeded = computeBillsNeeded(bill: remainingBills.fiveHundredBills, amount: remainingAmount, denomination: fiveHundred)
        remainingBills.fiveHundredBills -= fiveHundredBillsNeeded
        remainingAmount -= fiveHundredBillsNeeded * fiveHundred
        
        let oneHundredBillsNeeded = computeBillsNeeded(bill: remainingBills.oneHundredBills, amount: remainingAmount, denomination: oneHundred)
        remainingBills.oneHundredBills -= oneHundredBillsNeeded
        remainingAmount -= oneHundredBillsNeeded * oneHundred

        if(remainingAmount == 0) {
            availableBills = remainingBills
            return (true, (thousandBillsNeeded, fiveHundredBillsNeeded, oneHundredBillsNeeded))
        }
        print("remaining amount: \(remainingAmount)")
        return (false, (0, 0, 0))
    }
    
    func computeBillsNeeded(bill: Int, amount: Int, denomination: Int) -> Int {
        let needed = min(bill, amount / denomination)
        return needed
    }
}

