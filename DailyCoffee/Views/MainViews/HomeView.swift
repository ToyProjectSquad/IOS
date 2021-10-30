//
//  HomeView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct HomeView: View {
        
    @EnvironmentObject
    var userVM: UserViewModel
    @EnvironmentObject
    var coffeeVM: CoffeeViewModel
    
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
                .overlay(
                    Text("This is home")
                )
        }
        .onAppear {
            coffeeVM.configureUser(user: userVM.user!)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
