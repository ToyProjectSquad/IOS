//
//  FavoriteView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct FavoriteView: View {
    @State
    var selection: Int = 0
    @EnvironmentObject
    var detailVM: DetailViewModel

    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer().frame(height: 70)
                HStack(alignment: .top) {
                    titleField
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
        .overlay(
            ZStack(alignment: .top) {
                if detailVM.isPresent {
                    DetailView()
                        .onAppear {
                            print("detailView is presenting")
                        }
                }
            }
        )
    }
    
    private var titleField: some View {
        HStack(spacing: 10) {
            Text("오늘의 커피")
                .font(.system(size: selection == 0 ? 24 : 20, weight: .bold, design: .default))
                .foregroundColor(selection == 0 ? Color("TextColor") : Color(hex: "#606060"))
                .onTapGesture {
                    selection = 0
                }
                .padding(.leading, 18)
            Text("즐겨찾기")
                .font(.system(size: selection == 1 ? 24 : 20, weight: .bold, design: .default))
                .foregroundColor(selection == 0 ? Color("TextColor") : Color(hex: "#606060"))
                .onTapGesture {
                    selection = 1
                }
            Spacer()
        }
    }
    private var plusButton: some View {
        Button {
            detailVM.isPresent.toggle()
            detailVM.isEditMode = true
            detailVM.selectedItem = nil
        } label: {
            Image(systemName: "plus.app")
                .resizable()
                .frame(width: 30, height: 30)
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
