//
//  DailyView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/22.
//

import SwiftUI

struct DailyView: View {
    @EnvironmentObject
    var coffeeVM: CoffeeViewModel
    
    var body: some View {
        ScrollViewReader { _ in
            List {
                ForEach(coffeeVM.dailyCoffees, id: \.self) { coffee in
                    HStack {
                        Image(uiImage: UIImage(data: coffee.image!) ?? UIImage(named: "Placeholder")!)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(15)
                            .shadow(color: .black, radius: 5, x: 0, y: 5)
                            .padding()
                        VStack {
                            Text(coffee.title ?? "Coffee")
                            Text("\(String(format: "%.2f", coffee.size))ml/\(String(format: "%.2f", coffee.caffeine))mg")
                                .padding(.leading, 10)
                        }
                    }
                }
            }
        }
        .onAppear {
            coffeeVM.getCoffeeWithHistory()
        }
    }
}
//
//struct DailyView_Previews: PreviewProvider {
//    static var previews: some View {
//        DailyView()
//    }
//}
