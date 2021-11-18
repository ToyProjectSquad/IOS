//
//  SetupView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/23.
//

import SwiftUI

struct SetupView: View {
    
    @AppStorage("userID") var userID: String?
    
    @EnvironmentObject
    var userVM: UserViewModel
    
    @State
    var displayName: String = ""
    @State
    var maxCaffeineString: String = ""
    @State
    private var maxCaffeine: Double = 0
    @State
    private var isFinished: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: CustomTabView(), isActive: $isFinished) { EmptyView() }
                Text("Set up information")
                    .font(.system(size: 40, weight: .bold))
                    .padding()
                Spacer()
                displayNameView
                maxCaffeineView
                saveButton
                    .padding()
                Spacer()
            }
        }
    }
}

extension SetupView {
    
    private var displayNameView: some View {
        HStack {
            Text("Display name: ")
            TextField("Display name", text: $displayName)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(width: 200, height: 40)
                .padding([.leading, .trailing])
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.gray.opacity(0.2))
                )
        }
    }
    
    private var maxCaffeineView: some View {
        HStack {
            Text("Max caffeine: ")
            TextField("Max caffeine", text: $maxCaffeineString)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.numbersAndPunctuation)
                .frame(width: 200, height: 40)
                .padding([.leading, .trailing])
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.gray.opacity(0.2))
                )
                .overlay(
                    HStack {
                        Spacer()
                        Text("mg")
                            .padding()
                    }
                )
        }
    }
    
    private var saveButton: some View {
        Button {
            if self.verifyInfo() {
                userID = UUID().uuidString
                userVM.addUser(id: userID!, displayName: displayName, maxFull: maxCaffeine, photo: UIImage(named: "placeholder")!)
                isFinished = true
            }
            else {
                // TODO: ALERT
            }
        } label: {
            Text("SAVE")
                .foregroundColor(.white)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 15))
        }
    }
}

extension SetupView {
    
    private func verifyInfo() -> Bool {
        if displayName == "" { return false }
        if maxCaffeineString == "" { return false }
        let caffeine = Double(maxCaffeineString)
        if let caffeine = caffeine {
            maxCaffeine = caffeine
        } else { return false }
        return true
    }
    
}
