//
//  ViewController.swift
//  LearningStripe
//
//  Created by Daniel Akinniranye on 6/17/21.
//

import UIKit
import Stripe



class ViewController: UIViewController {
   
    
    
    let backendUrl = "http://127.0.0.1:5000/"

    var paymentIntentClientSecret: String? {
        
        didSet{
            print("The Payment intent is:  \(paymentIntentClientSecret!)")
        }
    }

    
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        StripeAPI.defaultPublishableKey = "pk_test_51J5Wl7BgcuVnPZy2vxSfVniKUso2zTQg4265FcS2sRHRaNYtDPy6LXfWMa9zrajyRg8wO4F0DGy75ZikliLl0Mtr00npeuu1vM"
        
        startCheckout()
    }
    @IBAction func proceedButtonPressed(_ sender: UIButton) {
        if let cvv = cvvTextField.text, let cardNumber = cardNumberTextField.text {
            // let name = nameTextField.text
            // name.isValidName()
//            if cvv.isValidCVV() && cardNumber.isValidCardNumber() {
//                print("Successful")
//                pay()
//            } else {
//                print("Error here")
//            }
//        } else {
//            print("Error")
            
            pay()
        }
    }
    
    
    
    
    func startCheckout() {
      // Create a PaymentIntent as soon as the view loads
      let url = URL(string: backendUrl + "create-payment-intent")!
      let json: [String: Any] = [
        "items": [
            ["id": "xl-shirt"]
        ]
      ]
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = try? JSONSerialization.data(withJSONObject: json)
      let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
        guard let response = response as? HTTPURLResponse,
          response.statusCode == 200,
          let data = data,
          let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
          let clientSecret = json["clientSecret"] as? String else {
              let message = error?.localizedDescription ?? "Failed to decode response from server."
              print("Error Loading page: \(message)")
              return
        }
        print("Created PaymentIntent")
        self?.paymentIntentClientSecret = clientSecret
      })
      task.resume()
    }
    
    
    func displayAlert(title: String, message: String, restartDemo: Bool = false) {
      DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true, completion: nil)
      }
    }
    
    
    
    
    func pay() {
        guard let paymentIntentClientSecret = paymentIntentClientSecret else {
            return;
        }
        // Collect card details
        
        let params = STPCardParams()
        params.cvc = cvvTextField.text!
        params.number = cardNumberTextField.text!
        params.expYear = 2025
        params.expMonth = 07
        let cardParams = STPPaymentMethodCardParams(cardSourceParams: params)

        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams
        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
          switch (status) {
          case .failed:
              self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
              break
          case .canceled:
              self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
              break
          case .succeeded:
              self.displayAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "")
              break
          @unknown default:
              fatalError()
              break
          }

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



extension ViewController : STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
    
    
}
