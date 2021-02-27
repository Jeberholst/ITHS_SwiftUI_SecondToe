//
//  ShareController.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-02-11.
//

import SwiftUI
import FirebaseUI

struct ShareController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController
    
    @Binding var text: String

    init(text: Binding<String>) {
        _text = text
    }
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let avc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            avc.excludedActivityTypes = [.postToFacebook,
                                            .postToTwitter,
                                            .postToWeibo,
                                            .assignToContact,
                                            .saveToCameraRoll,
                                            .addToReadingList,
                                            .postToFlickr,
                                            .postToVimeo,
                                            .postToTencentWeibo,
                                            .airDrop]
        return avc
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    
}
