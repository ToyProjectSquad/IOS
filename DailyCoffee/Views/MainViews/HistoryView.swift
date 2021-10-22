//
//  HistoryView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        Color.red.ignoresSafeArea()
            .overlay(
                Text("This is history")
            )
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
