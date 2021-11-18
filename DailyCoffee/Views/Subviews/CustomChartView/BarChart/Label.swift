//
//  Label.swift
//  DailyCoffee
//
//  Created by Jinseok Heo on 2021/10/31.
//

import SwiftUI

struct LabelView: View {
    
    @Binding
    var title: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 13))
            Image(systemName: "arrowtriangle.down")
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
}

struct LabelView_Previews: PreviewProvider {
    static var previews: some View {
        LabelView(title: .constant("Tesla model 3"))
    }
}
