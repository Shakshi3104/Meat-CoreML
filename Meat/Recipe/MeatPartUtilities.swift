//
//  MeatPartUtilities.swift
//  Meat
//
//  Created by MacBook Pro M1 on 2021/08/06.
//

import Foundation


enum MeatPart: String, CaseIterable {
    case gyu_harami = "gyu-harami"
    case gyu_kara_roast = "gyu-kata-roast"
    case gyu_tongue = "gyu-tongue"
    case sankaku_bara = "sankaku-bara"
    case sasami = "sasami"
    case seseri = "seseri"
    case sunagimo = "sunagimo"
    case tori_liver = "tori-liver"
    case tori_momo = "tori-momo"
    
    /// Name
    var name: String { rawValue }
    /// Rakuten Recipe Category ID
    var rakutenRecipeCategoryID: String {
        switch self {
        case .gyu_tongue:
            return "10-275-1483"
        case .gyu_harami, .gyu_kara_roast:
            return "10-275-822"
        case .sankaku_bara:
            return "10-275-2134"
        case .sasami:
            return "10-277-519"
        case .seseri:
            return "10-277-834"
        case .sunagimo:
            return "10-277-1489"
        case .tori_liver:
            return "10-277-1490"
        case .tori_momo:
            return "10-277-518"
    }
    }
}
