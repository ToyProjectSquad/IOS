//
//  InputView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/23.
//

import SwiftUI

struct InputView: View {
    // MARK: - VARIABLES
    
    // Binding
    @Binding
    var inputText: String
    @Binding
    var textfieldTapped: Int
    
    // State
    @State
    var text: String = ""
    
    let placeholder: String
    let unit: String
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            textFieldView
            lineView
            Spacer()
            HStack {
                saveButton
                Spacer()
                cancelButton
            }
        }
        .frame(height: 240)
        .padding()
    }
}

// MARK: - COMPONENTS
extension InputView {
    private var textFieldView: some View {
        HStack {
            TextField(placeholder, text: $text)
                .keyboardType(.numbersAndPunctuation)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(height: 50)
            Spacer()
            Text(unit)
        }
        .font(.system(size: 20, weight: .bold))
    }

    private var lineView: some View {
        Rectangle()
            .opacity(0.6)
            .frame(height: 1)
            .shadow(color: .black.opacity(0.8), radius: 5, x: 0, y: 5)
    }
    
    private var cancelButton: some View {
        Button {
            withAnimation {
                textfieldTapped = 0
            }
        } label: {
            Text("CANCEL")
                .frame(width: 80)
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .bold))
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 15))
        }
    }
    
    private var saveButton: some View {
        Button {
            withAnimation {
                self.inputText = text
                textfieldTapped = 0
            }
        } label: {
            Text("SAVE")
                .frame(width: 80)
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .bold))
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 15))
        }
    }
}
