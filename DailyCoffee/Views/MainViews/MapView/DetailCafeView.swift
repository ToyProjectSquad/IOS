//
//  DetailCafeView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/25.
//

import SwiftUI
import GoogleMaps

struct DetailCafeView: View {
    @Binding
    var selectedCafe: Cafe?
    @Binding
    var content: String

    var body: some View {
        ZStack {
            Color("Background")
            VStack(spacing: 0) {
                HStack() {
                    Image(uiImage: UIImage(data: selectedCafe!.image!) ?? UIImage(named: "Placeholder")!)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
                        .padding()
                    VStack(alignment: .leading) {
                        Text(selectedCafe!.title ?? "Name")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(Color("TextColor"))
                        HStack {
                            ForEach(0..<5) { index in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Int16(selectedCafe!.grade) >= index ? .yellow : .gray)
                            }
                        }
                    }
                    Spacer()
                    Image("Ellipsis")
                        .padding(.trailing)
                        .padding(.bottom, 80)
                }
                TextEditor(text: $content)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .font(.system(size: 17))
                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height * 0.2, alignment: .topLeading)
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(15)
                    .padding()
                    .disabled(true)
            }
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
    }
}
