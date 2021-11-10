//
//  DetailView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct DetailView: View {
    // MARK: - VARIABLES
    
    // Environment Object
    @EnvironmentObject
    var coffeeVM: CoffeeViewModel
    
    // Observed Object
    @ObservedObject
    var detailVM: DetailViewModel
    
    // State
    @State
    var title: String
    @State
    var size: String
    @State
    var caffeine: String
    @State
    var image: UIImage
    @State
    var photoModified: Bool = false
    @State
    var textfieldTapped: Int = 0
    @State
    var selectedCoffee: Coffee? = nil
    
    // MARK: - INIT
    init(detailVM: DetailViewModel) {
        self.detailVM = detailVM
        if let item = detailVM.selectedItem {
            self.title = item.title ?? "이름"
            self.size = String(item.size)
            self.caffeine = String(item.caffeine)
            self.selectedCoffee = item
            if let imageData = item.image {
                self.image = UIImage(data: imageData) ?? UIImage(named: "Placeholder")!
            } else {
                image = UIImage(named: "Placeholder")!
            }
        }
        else {
            self.title = "이름"
            self.size = "0"
            self.caffeine = "0"
            self.image = UIImage(named: "Placeholder")!
        }
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            if detailVM.isPresent {
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
                        saveButton
                            .padding(.leading, 20)
                        Spacer()
                        cancelButton
                            .padding(.trailing, 20)
                    }
                    Spacer()
                }
                .blur(radius: textfieldTapped != 0 ? 20 : 0)
                inputView
            }
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
        .sheet(isPresented: $photoModified) {
            ImagePicker(selectedImage: $image, sourceType: .photoLibrary)
        }
    }
}

// MARK: - COMPONENTS
extension DetailView {
    private var background: some View {
        Color("Background")
            .shadow(color: .black.opacity(0.7), radius: 5, x: 0, y: 5)
            .ignoresSafeArea()
    }
    
    private var ellipsis: some View {
        HStack {
            Spacer()
            Menu {
                Button {
                    if let selectedCoffee = selectedCoffee {
                        detailVM.setEditMode(coffee: selectedCoffee)
                    }
                } label: {
                    Text("Edit")
                }
                .disabled(detailVM.mode != 0 ? true : false)
                Button {
                    if let selectedCoffee = selectedCoffee {
                        coffeeVM.deleteCoffeeInFavorite(coffee: selectedCoffee)
                    }
                } label: {
                    Text("Delete")
                }
                .disabled(detailVM.mode != 0 ? true : false)
                Button {
                    coffeeVM.addCoffeeToDaily(caffeine: Double(caffeine) ?? 0, size: Double(size) ?? 0, image: image, title: title)
                    detailVM.setDefualtMode()
                } label: {
                    Text("Add to daily")
                }
            } label: {
                Image("Ellipsis")
                    .padding(.trailing, 10)
                    .padding(.top, 24)
            }
        }
    }
    
    private var titleView: some View {
        Text(title)
            .multilineTextAlignment(.center)
            .font(.system(size: 30, weight: .bold))
            .onTapGesture {
                withAnimation {
                    if detailVM.mode != 0 {
                        self.textfieldTapped = 3
                    }
                }
            }
    }
    
    private var imageView: some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: 150, height: 150)
            .cornerRadius(30)
            .onTapGesture {
                if detailVM.mode != 0 && textfieldTapped == 0 {
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
                            if detailVM.mode != 0 {
                                self.textfieldTapped = 1
                            }
                        }
                    }
                .frame(maxWidth: .infinity)
                Text("Caffeine: \(self.caffeine)mg")
                    .onTapGesture {
                        withAnimation {
                            if detailVM.mode != 0 {
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
            else if textfieldTapped == 3 {
                InputView(inputText: $title, textfieldTapped: $textfieldTapped, placeholder: "Input title here...", unit: "")
            }
        }
    }
    
    private var saveButton: some View {
        Button {
            withAnimation {
                // TODO: ALERT
                guard let size = Double(self.size) else { return }
                guard let caffeine = Double(self.caffeine) else { return }
            
                if detailVM.mode == 1 {
                    coffeeVM.addCoffeeToFavorite(title: title, image: image, size: size, caffeine: caffeine)
                }
                else if detailVM.mode == 2 {
                    if let selectedCoffee = detailVM.selectedItem {
                        coffeeVM.editCoffee(coffee: selectedCoffee, caffeine: caffeine, size: size, image: image, title: title)
                    }
                }
                detailVM.setDefualtMode()
            }
        } label: {
            Text("SAVE")
                .frame(width: 80)
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .bold))
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 15))
        }
        .disabled(detailVM.mode != 0 ? false : true)
        .opacity(detailVM.mode != 0 ? 1 : 0)
    }
    
    private var cancelButton: some View {
        Button {
            withAnimation {
                detailVM.setDefualtMode()
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
}
