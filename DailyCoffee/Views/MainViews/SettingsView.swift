//
//  SettingsView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Color.blue.ignoresSafeArea()
            .overlay(
                Text("This is settings")
            )
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
