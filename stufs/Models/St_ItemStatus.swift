//
//  St_ItemStatus.swift
//  stufs
//
//  Created by Thomas Andre Johansen on 21/10/2020.
//

import Foundation
import UIKit

enum St_ItemStatus: CaseIterable {
    
    case favorite
    case wishlist
    case owned
    case discarded
    
    var name: String {
        switch self {
        case .favorite:
            return "Favorite"
        case .wishlist:
            return "Wish List"
        case .owned:
            return "Owned"
        case .discarded:
            return "Discarded"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .favorite:
            return UIImage(systemName: "star")!
        case .discarded:
            return UIImage(systemName: "trash")!
        default:
            return nil
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .favorite:
            return UIImage(systemName: "star.fill")!
        case .discarded:
            return UIImage(systemName: "trash.fill")!
        default:
            return nil
        }
    }
    
    var infoText: String {
        switch self {

        case .favorite:
            return " Favorite items are items you own, but like a bit more than other items. 🤩"
        case .wishlist:
            return " Your Wish List contains items you one day would like to own. 😏"
        case .owned:
            return " Every item added needs to be put in a state. \n Owned items are items you own. 😊"
        case .discarded:
            return " Discarded items are items that you for some reason no longer own. 🥺"
        }
    }
    
}
