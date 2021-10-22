//
//  DailyFavoriteView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct DailyFavoriteView: View {
    var body: some View {
        Color.yellow.ignoresSafeArea()
            .overlay(
                Text("This is DailyFavorite")
            )
    }
}

struct DailyFavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        DailyFavoriteView()
    }
}
