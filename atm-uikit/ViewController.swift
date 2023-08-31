//
//  ViewController.swift
//  atm-uikit
//
//  Created by Renzy Ortega on 8/31/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var btnWithdraw: UIButton!
    
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
            alert.message = "Amount should be withdrawn using 1000 / 500 / 100 denominations."
            present(alert, animated: true, completion: nil)
            return
        }
        print("amount found: \(amount)")
        let viewController = ResultViewController(nibName: "ResultViewController", bundle: Bundle.main)
        present(viewController, animated: true)
    }
    
    func isAmountWithdrawable(_ amount: Int) -> Bool {
        let denominations = [1000, 500, 100]
        var remainingAmount = amount
        for denomination in denominations {
            let numberOfNotes = remainingAmount / denomination
            remainingAmount -= numberOfNotes * denomination
        }
        return remainingAmount == 0
    }
}

