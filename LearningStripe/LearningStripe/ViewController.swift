//
//  ViewController.swift
//  LearningStripe
//
//  Created by Daniel Akinniranye on 6/17/21.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func proceedButtonPressed(_ sender: UIButton) {
        if let cvv = cvvTextField.text, let cardNumber = cardNumberTextField.text {
            // let name = nameTextField.text
            // name.isValidName()
            if cvv.isValidCVV() && cardNumber.isValidCardNumber() {
                print("Successful")
            } else {
                print("Error here")
            }
        } else {
            print("Error")
        }
    }
}


extension String {
    func isValidName() -> Bool {
        let inputP = NSPredicate(format: "SELF MATCHES %@", K.nameRegex)
        return inputP.evaluate(with: self)
    }
    
    func isValidCardNumber() -> Bool {
        let inputP = NSPredicate(format: "SELF MATCHES %@", K.mastercardRegex)
        return inputP.evaluate(with: self)
    }
    
    func isValidCVV() -> Bool {
        let inputP = NSPredicate(format: "SELF MATCHES %@", K.cvvRegex)
        return inputP.evaluate(with: self)
    }
}
