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
    var detailVM: DetailViewModel = DetailViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                CustomTabView()
            }
            .environmentObject(detailVM)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
