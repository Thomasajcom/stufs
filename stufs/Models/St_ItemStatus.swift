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
    
}
