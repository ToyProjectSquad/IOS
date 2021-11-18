//
//  SettingsView.swift
//  DailyCoffee
//
//  Created by Jinseok on 2021/10/18.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    @State var result: Result<MFMailComposeResult, Error>?
    @State var isShowingMailView = false

    var body: some View {
        NavigationView{
            ZStack {
                backgroundView
                VStack{
                    titleView
                    Spacer().frame(height: 12)
                    profileView
                    Spacer().frame(height: 21)
                    versionView
                    Spacer().frame(height: 80)
                    VStack{
                        feedBackbuttonView
                        openSourcebuttonView
                        makePeoplebuttonView
                    }
                    Spacer()
                }
            }
        }
    }
}

extension SettingsView{
    private var backgroundView: some View {
        Color("Background")
            .ignoresSafeArea()
    }
    
    private var titleView: some View{
        HStack(){
            Text("더보기")
                .font(.system(size: 34, weight: .bold))
                .padding(.leading, 22)
            Spacer()
            Button(action: {
                
            }){
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .foregroundColor(Color.black)
                    .frame(width: 27,height: 29)
                    .font(.system(size: 24))
                    .padding(.trailing, 20)
            }
        }
    }
    
    private var profileView: some View{
        HStack(alignment: .top){
            Image(uiImage: UIImage(data: userVM.user!.profileImage!)!)
                .resizable()
                .clipShape(Circle())
                .padding(.leading, 17.0)
                .shadow(radius: 7)
                .frame(width: 70.0, height: 70)
            VStack(alignment: .leading){
                Text(userVM.user!.displayName!)
                    .font(.system(size: 37, weight: .regular))
                Text(userVM.user!.comment!)
            }
            Spacer()
            NavigationLink(
                destination: ProfileView(profileImage: UIImage(data: userVM.user!.profileImage!)!
                                        , displayName: userVM.user!.displayName!
                                            , comment: userVM.user!.comment!),
                label: {
                    Image(systemName: "square.and.pencil")
                    .resizable()
                    .foregroundColor(Color.black)
                    .frame(width: 39,height: 40)
                    .font(.system(size: 34))
                    .padding(.trailing, 49.0)
            }
            )
            }
    }
    
    private var versionView: some View{
        RoundedRectangle(cornerRadius: 8)
                .fill(Color("versionColor"))
                .frame(width: 335, height: 37)
                .padding(.horizontal, 33.0)
                .overlay(HStack(){
            Text("v0.1")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(Color.white)
            Spacer()
            Text("열심히 업데이트 중이에요!")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(Color.white)
                }
                        .padding(.horizontal, 40))
    }
    
    private var feedBackbuttonView: some View{
        Button(action:{
            self.isShowingMailView.toggle()
        }){
            VStack {
                HStack(){
                    Image(systemName: "envelope")
                        .foregroundColor(Color.black)
                        .padding(.leading, 23.0)
                        .font(.system(size: 24))
                    Text("피드백 보내기")
                        .font(.system(size: 24,weight: .regular))
                        .foregroundColor(Color.black)
                        .padding(.leading, 31.0)
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("versionColor"))
                    .frame(width: 335, height: 0.6)
            }
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(isShowing: self.$isShowingMailView, result: self.$result)
        }
    }
    
    private var openSourcebuttonView: some View{
        NavigationLink(destination: OpenSourceView(),
                       label: {
            VStack {
                HStack(){
                    Image(systemName: "folder")
                        .foregroundColor(Color.black)
                        .padding(.leading, 23.0)
                        .font(.system(size: 24))
                    Text("오픈 소스")
                        .font(.system(size: 24,weight: .regular))
                        .foregroundColor(Color.black)
                        .padding(.leading, 31.0)
                    Spacer()
                }
            RoundedRectangle(cornerRadius: 8)
                .fill(Color("versionColor"))
                .frame(width: 335, height: 0.6)
        }})
    }
    
    private var makePeoplebuttonView: some View{
        NavigationLink(destination: MakePeopleView(),
                       label: {
            VStack {
                HStack(){
                    Image(systemName: "person")
                        .foregroundColor(Color.black)
                        .padding(.leading, 23.0)
                        .font(.system(size: 24))
                    Text("만든 사람들")
                        .font(.system(size: 24,weight: .regular))
                        .foregroundColor(Color.black)
                        .padding(.leading, 31.0)
                    Spacer()
                }
            RoundedRectangle(cornerRadius: 8)
                .fill(Color("versionColor"))
                .frame(width: 335, height: 0.6)
        }})
    }
}
