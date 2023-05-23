//
//  welcome.swift
//  Graduation project
//
//  Created by ByteDance on 2023/5/6.
//

import SwiftUI


struct WelcomeView: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            Image("art") // 图片作为背景
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
           
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 1.0)) { // 添加一个1秒的渐变动画
                    self.isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            loginView().transition(.opacity) // 使用渐隐渐现的动画效果
        }
    }
}
struct welContentView_Previews : PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
