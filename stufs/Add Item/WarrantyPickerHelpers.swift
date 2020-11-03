//
//  WarrantyPickerHelpers.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 03/11/2020.
//

import Foundation

//A Struct for defining the data source of a picker relating to warranty.
struct WarrantyLength {
    var length: Int
    var timeUnit: TimeUnit
    
    var warrantyLengthInDays: Int {
        
        switch timeUnit {
        case .days:
            return length
        case .years:
            #warning("This wont be correct for leap years, etc, need to be fixed")
            return length*365
        }
    }
}

enum TimeUnit: String {
    case days = "days"
    case years = "years"
    
}

protocol WarrantyPickerVCDelegate {
    func setWarrantyLength(_ warrantyLength: WarrantyLength)
}
