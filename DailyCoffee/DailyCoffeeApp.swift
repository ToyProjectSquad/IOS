//
//  DailyCoffeeApp.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI
import Firebase

@main
struct DailyCoffeeApp: App {

    @StateObject
    var userVM: UserViewModel = UserViewModel()
    
    @AppStorage("userID") var userID: String?
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if let _ = userID {
                    CustomTabView()
                }
                else {
                    SetupView()
                }
            }
            .environmentObject(userVM)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
