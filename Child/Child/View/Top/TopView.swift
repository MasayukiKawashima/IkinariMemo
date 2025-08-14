//
//  TopView.swift
//  Child
//
//  Created by 川島真之 on 2025/07/06.
//

import SwiftUI

struct TopView: View {
  
  // MARK: Properties
  
  @StateObject private var viewModel: TopViewModel = TopViewModel()
  @State private var isKeyboardVisible: Bool = false
  
  // iPhone16Proの画面のHeight874（CSSピクセル）を基準に算出
  private let titleHeightRatio: CGFloat = 0.11
  private let contentHeightRatio: CGFloat = 0.58
  private let sideMenuIconBottomSpacerHeightRatio: CGFloat = 0.06
  private let contentViewBottomSpacerHeightRatio: CGFloat = 0.023
  private let adBannerHeight: CGFloat = 50
  private let iconSidePaddingRatio: CGFloat = 0.024
  private let iconSizeRatio: CGFloat = 0.036
  
  // MARK: Body
  
  var body: some View {
    NavigationStack {
    
      GeometryReader { geometry in
        
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        ZStack {
          VStack(spacing: 0) {
            HStack {
              
              Button(action: {
                withAnimation(.linear(duration: 0.2)) {
                  viewModel.isSideMenuOpen.toggle()
                }
              }) {
                Image(systemName: "line.3.horizontal")
                  .font(.system(
                    size: max(screenHeight * iconSizeRatio, 1),
                    weight: .bold
                  ))
                  .foregroundStyle(Color.black)
                  .padding(.leading, screenWidth * iconSidePaddingRatio)
              }
              
              Spacer()
              
              //新規メモ作成ボタン
              Button(action: {
                viewModel.upDateCurrentUserMemo()
              }) {
                Image(systemName: "pencil.circle.fill")
                  .font(.system(
                    size: max(screenHeight * iconSizeRatio, 1),
                    weight: .bold
                  ))
                  .foregroundStyle(Color.black)
                  .padding(.trailing, screenWidth * iconSidePaddingRatio)
              }
            }
            
            Spacer().frame(height: screenHeight * sideMenuIconBottomSpacerHeightRatio)
            
            TitleView()
              .frame(height: screenHeight * titleHeightRatio)
              
            ContentView()
              .frame(height: screenHeight * contentHeightRatio)
            
            
            Spacer().frame(height: screenHeight * contentViewBottomSpacerHeightRatio)
            
            Color.yellow
              .frame(height: adBannerHeight)
              .overlay(Text("Ad Banner"))
  
          }
          
          SideMenuView(isOpen: $viewModel.isSideMenuOpen)
          
          if isKeyboardVisible {
            Color.black.opacity(0.001)
              .ignoresSafeArea()
              .onTapGesture {} // タップを吸収
          }
        }
      }
    }
    .navigationBarHidden(true)
    .accentColor(.gray)
    
    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
      isKeyboardVisible = true
    }
    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
      isKeyboardVisible = false
    }
  }
}

#Preview {
  TopView()
}
