//
//  OpenSourceView.swift
//  DailyCoffee
//
//  Created by Junseok Lee on 2021/11/16.
//

import SwiftUI

struct OpenSourceView: View {
    var body: some View {
        ZStack{
            backgroundView
            Text("오픈 소스?!?!")
        }
    }
}

struct OpenSourceView_Previews: PreviewProvider {
    static var previews: some View {
        OpenSourceView()
    }
}

extension OpenSourceView{
    private var backgroundView: some View {
        Color("Background")
            .ignoresSafeArea()
    }
}
