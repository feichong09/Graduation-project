//
//  login.swift
//  Graduation project
//
//  Created by ByteDance on 2023/5/7.
//
import Foundation
import SwiftUI
struct loginView: View {
    @State private var isActive = false
    @State private var showupdate = false
    var body: some View {
        ZStack {
            Image("login") // 图片作为背景
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("Smart  beauty")
                    .font(.custom("AnandaBlackPersonalUse-Regular", size: 50))
                    .foregroundColor(.white)
                    .padding(.top, UIScreen.main.bounds.height / 4)
                Spacer()
                Button(action: {
                    self.showupdate.toggle()
                }) {
                       Text("进入")
                        .foregroundColor(.white)
                           .font(.system(size: 25, weight: .bold))
                           .padding(.horizontal, 40)
                           .padding(.vertical, 16)
                           .background(Color.white.opacity(0.2))
                           .cornerRadius(10)
                   }.fullScreenCover(isPresented: $showupdate) {
                       uiContentView()
                   }
                   .frame(maxWidth: .infinity, alignment: .center)
                   .offset(y: -UIScreen.main.bounds.height/4)
            }
        }
    }
}
struct loginContentView_Previews : PreviewProvider {
    static var previews: some View {
        loginView()
    }
}
