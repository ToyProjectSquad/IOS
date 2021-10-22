//
//  MapView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct MapView: View {
    var body: some View {
        Color.purple.ignoresSafeArea()
            .overlay(
                Text("This is map")
            )
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
