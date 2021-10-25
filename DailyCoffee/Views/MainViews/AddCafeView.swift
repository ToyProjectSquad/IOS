//
//  AddCafeView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/24.
//

import SwiftUI
import CoreLocation

struct AddCafeView: View {
    
    @ObservedObject
    var cafeVM: CafeViewModel
    
    @Binding
    var didTapped: Bool
    @Binding
    var coordinate: CLLocationCoordinate2D?
    
    @State
    var grade: Int = 0
    @State
    var title: String = ""
    @State
    var image: UIImage = UIImage(named: "Placeholder")!
    @State
    var comment: String = ""
    @State
    var imageTapped: Bool = false

    let commentPlaceholder: String = "Enter comment here.."
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    titleView
                    imageView
                    starView
                        .padding()
                    nameView
                        .padding([.leading, .trailing])
                    commentView
                        .padding()
                    HStack {
                        saveButton
                            .padding()
                        Spacer()
                        cancelButton
                            .padding()
                    }
                }
            }
        }
        .cornerRadius(15)
        .shadow(color: .black, radius: 5, x: 0, y: 5)
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
        .sheet(isPresented: $imageTapped) {
            ImagePicker(selectedImage: $image)
        }
    }
}

extension AddCafeView {

    private var starView: some View {
        HStack {
            ForEach(0..<5) { index in
                Image(systemName: "star.fill")
                    .font(.system(size: 30))
                    .foregroundColor(grade >= index ? .yellow : .gray)
                    .onTapGesture {
                        grade = index
                    }
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
            }
        }
    }
    
    private var titleView: some View {
        Text("Add Cafe")
            .font(.system(size: 30, weight: .bold))
            .padding()
    }
    
    private var imageView: some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: 140, height: 140)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
            .onTapGesture {
                imageTapped.toggle()
            }
    }
    
    private var nameView: some View {
        VStack(alignment: .leading) {
            Text("Name")
                .fontWeight(.bold)
            VStack(spacing: 0) {
                TextField("Enter name here..", text: $title)
                    .keyboardType(.default)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                RoundedRectangle(cornerRadius: 0.5)
                    .frame(height: 1)
                    .opacity(0.4)
            }
        }
        .font(.system(size: 20))
    }
    
    private var commentView: some View {
        VStack(alignment: .leading) {
            Text("Comment")
                .font(.system(size: 20, weight: .bold))
            ZStack(alignment: .topLeading) {
                TextEditor(text: $comment)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .foregroundColor(.black)
                    .frame(height: 200)
                    .background(Color.white.opacity(0.4))
                    .cornerRadius(15)
                if comment == "" {
                    Text(commentPlaceholder)
                        .foregroundColor(.gray)
                        .padding(7)
                }
            }
            .font(.system(size: 17))
        }
    }
    
    private var saveButton: some View {
        Button {
            withAnimation {
                cafeVM.addCafe(title: title, latitude: coordinate?.latitude ?? 0, longitutde: coordinate?.longitude ?? 0, image: image, content: comment)
                didTapped.toggle()
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
    
    private var cancelButton: some View {
        Button {
            withAnimation {
                didTapped.toggle()
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
