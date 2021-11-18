//
//  ProfileView.swift
//  DailyCoffee
//
//  Created by Junseok Lee on 2021/11/10.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isShowingImagePicker = false
    @State var profileImage:UIImage
    @State var displayName:String
    @State var comment:String
    var body: some View {
        ZStack {
            backgroundView
            VStack{
                titleView
                UserMainImage
                UserInfo
                HStack{
                    saveButton
                    Spacer()
                    cancelButton
                }
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $profileImage, sourceType: .photoLibrary)
        }
        }
    }
}

extension ProfileView{
    
    private var backgroundView: some View {
        Color("Background")
            .ignoresSafeArea()
    }
    
    private var titleView: some View{
        HStack(){
            Text("Profile")
                .font(.system(size: 34, weight: .bold))
                .padding(.leading, 22)
            Spacer()
        }
        .offset(y: -180)
    }
    
    private var UserMainImage: some View{
        Image(uiImage: profileImage)
            .resizable()
            .frame(width: 300, height: 300)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth:  3))
            .shadow(radius: 5)
            .offset(y: -130)
            .padding(.bottom, -130)
            .onTapGesture { isShowingImagePicker = true }
    }
    
    private var UserInfo: some View{
        VStack(alignment: .leading){
            TextField("닉네임을 입력하세요", text: $displayName)
                .font(.title)
                .keyboardType(.numbersAndPunctuation)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            HStack(alignment: .top){
                TextField("Comment를 남기세요.", text: $comment)
                    .font(.subheadline)
                    .keyboardType(.numbersAndPunctuation)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                Spacer()
            }
        }
        .padding()
    }
    
    private var cancelButton: some View {
        Button {
            withAnimation {
                self.presentationMode.wrappedValue.dismiss()
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
            withAnimation{
                userVM.editUser( displayName: displayName, comment: comment, photo: profileImage)
                self.presentationMode.wrappedValue.dismiss()
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
