//
//  DetailView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject
    var detailVM: DetailViewModel
    @State
    var title: String = "이름"
    @State
    var size: String = "0ml"
    @State
    var caffeine: String = "0mg"
    @State
    var image: Image = Image("Placeholder")
    @State
    var photoModified: Bool = false
    @State
    var mlIsHidden: Bool = false
    @State
    var mgIsHidden: Bool = false
    
    init() {
        if let item = detailVM.selectedItem {
            self.title = item.title ?? "이름"
            self.size = String(item.size) + "ml"
            self.caffeine = String(item.caffeine) + "mg"
            if let imageData = item.image {
                self.image = Image(uiImage: (UIImage(data: imageData)) ?? UIImage(named: "Placeholder")!)
            } else {
                image = Image("Placeholder")
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            VStack(spacing: 0) {
                ellipsis
                Spacer()
                titleView
                imageView
                RoundedRectangle(cornerRadius: 15)
                    .frame(maxHeight: 150)
                    .foregroundColor(Color.white.opacity(0.4))
                    .overlay(
                        contentView
                    )
                    .padding(20)
                Spacer()
            }
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
        .sheet(isPresented: $photoModified) {
            ImagePicker(selectedImage: $image, sourceType: .photoLibrary)
        }
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
            .font(.system(size: 30, weight: .bold))
            .padding(.bottom, 18)
            .disabled(detailVM.isEditMode ? true : false)
    }
    
    private var imageView: some View {
        image
            .resizable()
            .frame(width: 150, height: 150)
            .clipShape(Circle())
            .padding(.bottom, 44)
            .onTapGesture {
                if detailVM.isEditMode {
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
            VStack {
                HStack {
                    Text("Size: ")
                    TextField("size", text: $size)
                        .frame(maxWidth: 120)
                        .keyboardType(.numberPad)
                }
                HStack {
                    Text("Caffeine: ")
                    TextField("size", text: $caffeine)
                        .frame(maxWidth: 120)
                        .keyboardType(.numberPad)
                }
            }
            .font(.system(size: 20, weight: .bold, design: .default))
            Spacer()
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
