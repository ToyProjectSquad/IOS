//
//  DetailCafeView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/25.
//

import SwiftUI
import GoogleMaps

struct DetailCafeView: View {
    // MARK: - VARIABLES
    
    // Environment Object
    @EnvironmentObject
    var cafeVM: CafeViewModel
    
    @EnvironmentObject
    var detailCafeVM: DetailCafeViewModel
    
    // State
    @State
    var photoTapped: Bool = false

    // MARK: - BODY
    var body: some View {
        ZStack {
            Color("Background")
            VStack(spacing: 0) {
                HStack() {
                    imageView
                        .padding()
                    VStack(alignment: .leading) {
                        titleView
                        gradeView
                    }
                    Spacer()
                    ellipsis
                }
                contentView
                if detailCafeVM.isEditMode {
                    HStack {
                        saveButton
                        Spacer()
                        cancelButton
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
        .sheet(isPresented: $photoTapped) {
            ImagePicker(selectedImage: $detailCafeVM.image, sourceType: .photoLibrary)
        }
    }
}

// MARK: - COMPONENTS
extension DetailCafeView {
    
    private var imageView: some View {
        Image(uiImage: detailCafeVM.image)
            .resizable()
            .frame(width: 60, height: 60)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
            .onTapGesture {
                if detailCafeVM.isEditMode {
                    photoTapped.toggle()
                }
            }
    }
    
    private var titleView: some View {
        TextField("", text: $detailCafeVM.title)
            .foregroundColor(Color("TextColor"))
            .font(.system(size: 30, weight: .bold))
            .disabled(detailCafeVM.isEditMode ? false : true)
    }
    
    private var gradeView: some View {
        HStack {
            ForEach(0..<5) { index in
                Image(systemName: "star.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Int16(detailCafeVM.grade) >= index ? .yellow : .gray)
                    .onTapGesture {
                        if detailCafeVM.isEditMode {
                            detailCafeVM.grade = index
                        }
                    }
            }
        }
    }
    
    private var ellipsis: some View {
        VStack {
            Menu {
                Button {
                    withAnimation {
                        detailCafeVM.isEditMode.toggle()
                    }
                } label: {
                    Text("Edit")
                }
                Button {
                    if let selectedCafe = cafeVM.selectedCafe {
                        cafeVM.deleteCafe(cafe: selectedCafe)
                        cafeVM.selectedMarker = nil
                        cafeVM.selectedCafe = nil
                    }
                } label: {
                    Text("Delete")
                }
            } label: {
                Image("Ellipsis")
                    .padding(.trailing)
                    .padding(.top, 10)
            }
            Spacer().frame(maxHeight: 80)
        }
    }
    
    private var contentView: some View {
        TextEditor(text: $detailCafeVM.content)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .font(.system(size: 17))
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: .infinity, alignment: .topLeading)
            .background(Color.white.opacity(0.6))
            .cornerRadius(15)
            .padding()
            .disabled(detailCafeVM.isEditMode ? false : true)
    }
    
    private var saveButton: some View {
        Button {
            withAnimation {
                cafeVM.editCafe(title: detailCafeVM.title,
                                grade: detailCafeVM.grade,
                                image: detailCafeVM.image,
                                content: detailCafeVM.content)
                detailCafeVM.isEditMode.toggle()
            }
        } label: {
            Text("SAVE")
                .frame(width: 80)
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .bold))
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 15))
        }
        .disabled(detailCafeVM.isEditMode ? false : true)
        .opacity(detailCafeVM.isEditMode ? 1 : 0)
    }
    
    private var cancelButton: some View {
        Button {
            withAnimation {
                detailCafeVM.cancel(selectedCafe: cafeVM.selectedCafe)
            }
        } label: {
            Text("CANCEL")
                .frame(width: 80)
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .bold))
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 15))
        }
        .disabled(detailCafeVM.isEditMode ? false : true)
        .opacity(detailCafeVM.isEditMode ? 1 : 0)
    }
    
}
