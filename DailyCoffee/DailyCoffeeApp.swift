//
//  DailyCoffeeApp.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI
import Firebase
import GoogleMaps

@main
struct DailyCoffeeApp: App {

    @StateObject
    var userVM: UserViewModel = UserViewModel()
    
    @AppStorage("userID") var userID: String?
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
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
            .onAppear(perform: {
                if let userID = userID {
                    userVM.configureID(id: userID)
                    userVM.configureUser()
                }
            })
            .environmentObject(userVM)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        GMSServices.provideAPIKey("AIzaSyASC46x_stwzmVtRB321-fU33_GDRyc6Y4")
        FirebaseApp.configure()
        return true
    }
}
