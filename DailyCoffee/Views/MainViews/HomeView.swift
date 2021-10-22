//
//  HomeView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Color.green.ignoresSafeArea()
            .overlay(
                Text("This is home")
            )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
