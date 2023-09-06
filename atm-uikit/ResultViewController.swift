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
    @IBOutlet weak var resetBtn: UIButton!
    var withdrawn: (thousand: Int, fiveHundred: Int, oneHundred: Int)?
    var delegate: ResultViewControllerDelegate?
    let thousand: Int = 1000
    let fiveHundred: Int = 500
    let oneHundred: Int = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thousandLabel.text = processResult(amount: withdrawn?.thousand, type: thousand)
        fiveHundredLabel.text = processResult(amount: withdrawn?.fiveHundred, type: fiveHundred)
        oneHundredLabel.text = processResult(amount: withdrawn?.oneHundred, type: oneHundred)
    }
    
    @IBAction func onResetTap(_ sender: Any) {
        delegate?.reset()
        dismiss(animated: true)
    }

    func processResult(amount: Int?, type: Int) -> String {
        guard let amountWithdrawn = amount else { return "0" }
        return String(amountWithdrawn)
    }
}
