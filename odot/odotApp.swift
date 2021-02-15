//
//  odotApp.swift
//  odot
//
//  Created by Joakim Eberholst on 2021-01-24.
//

import SwiftUI
import Firebase
import FirebaseUI

@main
struct odotApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject private var authUtil: AuthUtil
    @ObservedObject private var todoDataModel: TodoDataModel
    
    init() {
        FirebaseApp.configure()
        authUtil = AuthUtil()
        todoDataModel = TodoDataModel()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginRegisterView()
                .background(Color("Background").ignoresSafeArea())
                .environmentObject(authUtil)
                .environmentObject(todoDataModel)
        }
    }
 
}

class AppDelegate: NSObject, UIApplicationDelegate, FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
      if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
        return true
      }
      // other URL handling goes here.
      return false
    }
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
      // handle user and error as necessary
    }
}
