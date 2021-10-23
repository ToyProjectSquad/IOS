//
//  ListView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/22.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject
    var coffeeVM: CoffeeViewModel
    
    var body: some View {
        ScrollViewReader { _ in
            List {
                ForEach(coffeeVM.favoriteCoffees) { coffee in
                    HStack {
                        Image(uiImage: UIImage(data: coffee.image!) ?? UIImage(named: "Placeholder")!)
                            .resizable()
                            .frame(width: 55, height: 55)
                            .cornerRadius(15)
                            .shadow(color: .black, radius: 5, x: 0, y: 2)
                            .padding()
                        VStack(alignment: .leading) {
                            Text(coffee.title ?? "Coffee")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("TextColor"))
                            Text("\(String(format: "%.2f", coffee.size))ml/\(String(format: "%.2f", coffee.caffeine))mg")
                                .padding(.leading, 30)
                                .font(.system(size: 15))
                        }
                    }
                }
                .onDelete(perform: coffeeVM.deleteCoffeeInFavorite)
            }
        }
        .onAppear {
            coffeeVM.getCoffeeWithFavorite()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
