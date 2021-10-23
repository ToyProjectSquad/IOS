//
//  FavoriteView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct FavoriteView: View {
    // MARK: - Variables
    
    // State Object
    @StateObject
    var detailVM: DetailViewModel = DetailViewModel()
    
    // State
    @State
    var selection: Int = 0

    // MARK: - Body view
    var body: some View {
        ZStack {
            backgroundView
            VStack(spacing: 0) {
                Spacer().frame(height: 70)
                HStack(alignment: .top) {
                    titleView
                        .padding(.bottom, 40)
                    Spacer()
                    plusButton
                        .padding(.trailing, 18)
                }
                TabView(selection: $selection) {
                    DailyView()
                        .tag(0)
                    ListView()
                        .tag(1)
                }
                .cornerRadius(15)
                .padding(18)
            }
            .opacity(0.8)
        }
        .onTapGesture {
            withAnimation {
                detailVM.isPresent = false
            }
        }
        .blur(radius: detailVM.isPresent ? 20 : 0)
        .overlay(detailView.scaleEffect(detailVM.isPresent ? 1 : 0))
    }
    
}

// MARK: - Components
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
                    }
                }
                .padding(.leading, 18)
            Text("즐겨찾기")
                .font(.system(size: selection == 1 ? 24 : 20, weight: .bold, design: .default))
                .foregroundColor(selection == 1 ? Color("TextColor") : Color(hex: "#606060"))
                .onTapGesture {
                    withAnimation {
                        selection = 1
                    }
                }
            Spacer()
        }
    }
    
    private var plusButton: some View {
        Button {
            withAnimation {
                detailVM.isEditMode = true
                detailVM.selectedItem = nil
                detailVM.isPresent.toggle()
            }
        } label: {
            Image(systemName: "plus.app")
                .resizable()
                .frame(width: 30, height: 30)
        }
        .disabled(selection == 1 ? false : true)
        .opacity(selection == 1 ? 1 : 0)
    }
    
    private var detailView: some View {
        ZStack(alignment: .top) {
            if detailVM.isPresent {
                DetailView(detailVM: detailVM)
                    .cornerRadius(15)
                    .padding([.leading, .trailing], 15)
                    .padding([.top, .bottom], 100)
            }
        }
    }
}
