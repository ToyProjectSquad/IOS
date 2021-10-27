//
//  HomeView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct HomeView: View {
    // MARK: - COMPONENTS
    
    // Environment Object
    @EnvironmentObject
    var userVM: UserViewModel
    @EnvironmentObject
    var coffeeVM: CoffeeViewModel
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                HStack {
                    commentView
                    Spacer()
                }
                Spacer()
                imageView
                caffeineView
                    .padding()
                Spacer()
            }
        }
        .onAppear { configure() }
    }
}

// MARK: - COMPONENTS
extension HomeView {
    
    private var commentView: some View {
        Text("향긋한 커피와 좋은 오후 보내세요")
            .foregroundColor(Color("TextColor"))
            .font(.system(size: 35, weight: .bold))
            .lineLimit(2)
            .padding()
    }
    
    private var caffeineView: some View {
        Text(String(format: "%.2f",
                    userVM.user!.maxFull != 0 ? coffeeVM.todayCaffeine / userVM.user!.maxFull * 100 : 0) + "%")
            .foregroundColor(Color("TextColor"))
            .font(.system(size: 40, weight: .bold))
    }
    
    private var imageView: some View {
        coffeeView
            .opacity(0.2)
            .overlay(
                overlayView
                    .mask(coffeeView)
            )
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
    }
    
    private var coffeeView: some View {
        Image("HomeCoffee")
            .resizable()
            .scaledToFit()
            .frame(maxHeight: 300)
    }
    
    private var overlayView: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Rectangle()
                    .foregroundColor(Color(hex: "#362614"))
                    .frame(height: userVM.user!.maxFull != 0 ? min(coffeeVM.todayCaffeine / userVM.user!.maxFull, 1) * geometry.size.height : 0)
                    .transition(AnyTransition.move(edge: .bottom))
                    .animation(.easeInOut)
            }
        }
    }
    
}

// MARK: - FUNCTIONS
extension HomeView {
    
    private func configure() {
        coffeeVM.configureUser(user: userVM.user!)
        coffeeVM.getTodayCaffeine()
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
