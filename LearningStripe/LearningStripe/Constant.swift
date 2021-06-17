//
//  Constant.swift
//  LearningStripe
//
//  Created by Daniel Akinniranye on 6/17/21.
//

import Foundation

struct K {
    static let visaRegex = "^4[0-9]{12}(?:[0-9]{3})?$"
    static let mastercardRegex = "^5[1-5][0-9]{14}$"
    static let nameRegex = "^[a-zA-Z\\_]{2,25}$"
    static let cvvRegex = "^[0-9]{3,4}$"
}
