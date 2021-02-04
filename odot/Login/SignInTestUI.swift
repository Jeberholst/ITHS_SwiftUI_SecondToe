//
//  SignInTestUI.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-02-03.
//

import SwiftUI
import FirebaseUI

struct SignInTestUI: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let authUI = FUIAuth.defaultAuthUI()
        let providers = [FUIGoogleAuth(authUI: authUI!)]
        authUI?.providers = providers
        let authViewController = authUI!.authViewController()
        return authViewController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    
}

struct SignInTestUI_Previews: PreviewProvider {
    static var previews: some View {
        SignInTestUI()
    }
}
