//
//  FavoriteView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct FavoriteView: View {
    // MARK: - VARIABLES
    
    // State Object
    @StateObject
    var detailVM: DetailViewModel = DetailViewModel()
    
    // Environment Object
    @EnvironmentObject
    var coffeeVM: CoffeeViewModel
    @EnvironmentObject
    var chartVM: ChartViewModel
    
    // State
    @State
    var selection: Int = 0
    @State
    var selectedCoffee: Coffee? = nil

    // MARK: - BODY
    var body: some View {
        ZStack {
            backgroundView
                .blur(radius: detailVM.isPresent ? 20 : 0)
            VStack(spacing: 0) {
                Spacer().frame(height: 70)
                HStack(alignment: .top) {
                    titleView
                        .padding(.bottom, 40)
                    Spacer()
                    plusButton
                        .padding(.trailing, 18)
                }
                contentView
                    .cornerRadius(15)
                    .padding(18)
            }
            .blur(radius: detailVM.isPresent ? 20 : 0)
            .opacity(0.8)
            if detailVM.isPresent {
                detailView
            }
        }
        .onAppear {
            coffeeVM.getCoffeeWithHistory()
        }
    }
    
}

// MARK: - COMPONENTS
extension FavoriteView {
    private var backgroundView: some View {
        Color("Background")
            .ignoresSafeArea()
    }
    
    private var titleView: some View {
        HStack(spacing: 10) {
            Text("오늘의 커피")
                .font(.system(size: selection == 0 ? 24 : 20, weight: .bold, design: .default))
                .foregroundColor(selection == 0 ? Color("TextColor") : Color(hex: "#606060"))
                .onTapGesture {
                    withAnimation {
                        selection = 0
                        coffeeVM.getCoffeeWithHistory()
                    }
                }
                .padding(.leading, 18)
            Text("즐겨찾기")
                .font(.system(size: selection == 1 ? 24 : 20, weight: .bold, design: .default))
                .foregroundColor(selection == 1 ? Color("TextColor") : Color(hex: "#606060"))
                .onTapGesture {
                    withAnimation {
                        selection = 1
                        coffeeVM.getCoffeeWithFavorite()
                    }
                }
            Spacer()
        }
    }
    
    private var plusButton: some View {
        Button {
            withAnimation {
                detailVM.setEditMode()
            }
        } label: {
            Image(systemName: "plus.app")
                .resizable()
                .frame(width: 30, height: 30)
        }
        .disabled(selection == 1 ? false : true)
        .opacity(selection == 1 ? 1 : 0)
    }
    
    private var contentView: some View {
        List {
            ForEach(coffeeVM.coffees) { coffee in
                Menu {
                    Button {
                        coffeeVM.addCoffeeToDaily(coffee: coffee)
                        chartVM.getWeeklyCoffee()
                    } label: {
                        Text("Add to daily")
                    }
                    .disabled(selection == 0 ? true : false)
                    
                    Button {
                        detailVM.setSelectMode(coffee: coffee)
                    } label: {
                        Text("Show detail")
                    }
                } label: {
                    HStack {
                        Image(uiImage: UIImage(data: coffee.image!) ?? UIImage(named: "Placeholder")!)
                            .resizable()
                            .frame(width: 55, height: 55)
                            .cornerRadius(15)
                            .shadow(color: .black, radius: 5, x: 0, y: 2)
                            .padding(8)
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

            }
            .onDelete { indexSet in
                if selection == 0 {
                    coffeeVM.deleteCoffeeFromDaily(indexSet: indexSet)
                    chartVM.getWeeklyCoffee()
                } else {
                    coffeeVM.deleteCoffeeFromFavorite(indexSet: indexSet)
                }
            }
        }
    }
    
    private var detailView: some View {
        DetailView(detailVM: detailVM)
            .cornerRadius(15)
            .padding([.leading, .trailing], 15)
            .padding([.top, .bottom], 100)
    }
}
