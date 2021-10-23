//
//  HomeView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct HomeView: View {
    
    @AppStorage("userID") var userID: String?
    
    @EnvironmentObject
    var userVM: UserViewModel
    @ObservedObject
    var coffeeVM: CoffeeViewModel
    
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
                .overlay(
                    Text("This is home")
                )
        }
        .onAppear {
            configure()
        }
    }
}

extension HomeView {
    
    private func configure() {
        userVM.configureID(id: userID!)
        userVM.configureUser()
        coffeeVM.configureUser(user: userVM.user!)
    }
    
}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(coffeeVM: CoffeeViewModel())
//    }
//}
