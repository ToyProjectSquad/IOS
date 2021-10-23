//
//  DetailView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct DetailView: View {
    // MARK: - Variables
    
    // Environment Object
    @EnvironmentObject
    var coffeeVM: CoffeeViewModel
    
    // Observed Object
    @ObservedObject
    var detailVM: DetailViewModel
    
    // State
    @State
    var title: String = "이름"
    @State
    var size: String = "0"
    @State
    var caffeine: String = "0"
    @State
    var image: UIImage = UIImage(named: "Placeholder")!
    @State
    var photoModified: Bool = false
    @State
    var textfieldTapped: Int = 0
    @State
    var mlIsHidden: Bool = false
    @State
    var mgIsHidden: Bool = false
    
    // MARK: - INIT
    init(detailVM: DetailViewModel) {
        self.detailVM = detailVM
        if let item = self.detailVM.selectedItem {
            self.title = item.title ?? "이름"
            self.size = String(item.size) + "ml"
            self.caffeine = String(item.caffeine) + "mg"
            if let imageData = item.image {
                self.image = UIImage(data: imageData) ?? UIImage(named: "Placeholder")!
            } else {
                image = UIImage(named: "Placeholder")!
            }
        }
    }
    
    // MARK: - Body view
    var body: some View {
        ZStack {
            background
            VStack(spacing: 0) {
                ellipsis
                Spacer()
                titleView
                    .padding(.bottom, 18)
                imageView
                    .padding(.bottom, 30)
                RoundedRectangle(cornerRadius: 15)
                    .frame(maxHeight: 150)
                    .foregroundColor(Color.white.opacity(0.4))
                    .overlay(
                        contentView
                    )
                    .padding(20)
                HStack {
                    cancelButton
                        .padding(.leading, 20)
                    Spacer()
                    saveButton
                        .padding(.trailing, 20)
                }
                Spacer()
            }
        }
        .blur(radius: textfieldTapped != 0 ? 20 : 0)
        .overlay(inputView.scaleEffect(textfieldTapped != 0 ? 1 : 0, anchor: .center))
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
        .sheet(isPresented: $photoModified) {
            ImagePicker(selectedImage: $image, sourceType: .photoLibrary)
        }
    }
}

// MARK: - Components
extension DetailView {
    
    private var background: some View {
        Color("Background")
            .shadow(color: .black.opacity(0.7), radius: 5, x: 0, y: 5)
            .ignoresSafeArea()
    }
    
    private var ellipsis: some View {
        HStack {
            Spacer()
            Image("Ellipsis")
                .padding(.trailing, 10)
                .padding(.top, 24)
        }
    }
    
    private var titleView: some View {
        TextField("", text: $title)
            .multilineTextAlignment(.center)
            .font(.system(size: 30, weight: .bold))
            .disabled(detailVM.isEditMode && textfieldTapped == 0 ? false : true)
    }
    
    private var imageView: some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: 150, height: 150)
            .clipShape(Circle())
            .onTapGesture {
                if detailVM.isEditMode && textfieldTapped == 0{
                    photoModified.toggle()
                }
            }
    }
    
    private var contentView: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                Text("Information")
                    .font(.system(size: 17)).bold()
                    .padding(10)
                Spacer()
            }
            Spacer()
            VStack(alignment: .leading) {
                Text("Size: \(self.size)ml")
                    .onTapGesture {
                        withAnimation {
                            if detailVM.isEditMode {
                                self.textfieldTapped = 1
                            }
                        }
                    }
                .frame(maxWidth: .infinity)
                Text("Caffeine: \(self.caffeine)mg")
                    .onTapGesture {
                        withAnimation {
                            if detailVM.isEditMode {
                                self.textfieldTapped = 2
                            }
                        }
                    }
                .frame(maxWidth: .infinity)
            }
            .font(.system(size: 20, weight: .bold, design: .default))
            Spacer()
        }
    }
    
    private var inputView: some View {
        ZStack(alignment: .top) {
            if textfieldTapped == 1 {
                InputView(inputText: $size, textfieldTapped: $textfieldTapped, placeholder: "Input size here...", unit: "ml")
            }
            else if textfieldTapped == 2 {
                InputView(inputText: $caffeine, textfieldTapped: $textfieldTapped, placeholder: "Input caffeine here...", unit: "mg")
            }
        }
        .frame(height: 240)
    }
    
    private var saveButton: some View {
        Button {
            withAnimation {
                // TODO: ALERT
                guard let size = Double(self.size) else { return }
                guard let caffeine = Double(self.caffeine) else { return }
            
                coffeeVM.addCoffeeToFavorite(title: title, image: image, size: size, caffeine: caffeine)
                detailVM.isPresent = false
            }
        } label: {
            Text("SAVE")
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .bold))
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 15))
        }
    }
    
    private var cancelButton: some View {
        Button {
            withAnimation {
                detailVM.isPresent = false
            }
        } label: {
            Text("CANCEL")
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .bold))
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 15))
        }
    }
    
}
