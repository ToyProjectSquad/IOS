//
//  MakePeopleView.swift
//  DailyCoffee
//
//  Created by Junseok Lee on 2021/11/16.
//

import SwiftUI

struct MakePeopleView: View {
    var body: some View {
        ZStack{
            backgroundView
            Text("만든 사람들")
        }
    }
}

struct MakePeopleView_Previews: PreviewProvider {
    static var previews: some View {
        MakePeopleView()
    }
}

extension MakePeopleView{
    private var backgroundView: some View {
        Color("Background")
            .ignoresSafeArea()
    }
}
