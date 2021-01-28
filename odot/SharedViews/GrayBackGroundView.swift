//
//  GrayBackGroundView.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-28.
//

import SwiftUI

struct GrayBackGroundView: View {
    
    var body: some View {
        Color.init(UIColor.systemGray4.withAlphaComponent(0.2))
            .cornerRadius(10)
    }
    
}

struct GrayBackGroundView_Previews: PreviewProvider {
    static var previews: some View {
        GrayBackGroundView()
    }
}
