//
//  Util.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-02-20.
//

import Foundation
import SwiftUI

func LocalizeNoCom(name: String) -> String {
    return NSLocalizedString(name, comment: "")
}

func getPriorityColor(priority: Int) -> Color {
    
    switch priority {
    
    case 1:
        return Color(.green)
    case 2:
        return Color(.orange)
    case 3:
        return Color(.red)
        
    default:
        return Color(.gray)
    }
    
}
