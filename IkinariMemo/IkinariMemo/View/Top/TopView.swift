//
//  TopView.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/07/06.
//

import SwiftUI

struct TopView: View {
  
  // MARK: Properties
  
  @StateObject private var viewModel: TopViewModel = TopViewModel()
  @FocusState private var focusedField: FocusedField?
  
  private let screenHeight = UIScreen.main.bounds.height
  private let screenWidth = UIScreen.main.bounds.width
  
  // iPhone16Proの画面のHeight874（CSSピクセル）を基準に算出
  private let titleHeightRatio: CGFloat = 0.08
  private let contentHeightRatio: CGFloat = 0.58
  private let sideMenuIconBottomSpacerHeightRatio: CGFloat = 0.06
  private let contentViewBottomSpacerHeightRatio: CGFloat = 0.015
  private let topEdgePaddingHeightRatio: CGFloat = 0.025
  private let adBannerHeight: CGFloat = 50
  private let iconSidePaddingRatio: CGFloat = 0.024
  private let iconSizeRatio: CGFloat = 0.036
  
  // MARK: Body
  
  var body: some View {
    NavigationStack {
    
      GeometryReader { geometry in
        
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
                  .foregroundStyle(Color.mainColor)
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
                  .foregroundStyle(Color.mainColor)
                  .padding(.trailing, screenWidth * iconSidePaddingRatio)
              }
            }
            .padding(.top, screenHeight * topEdgePaddingHeightRatio)
            
            Spacer().frame(height: screenHeight * sideMenuIconBottomSpacerHeightRatio)
            
            
            VStack {
              TitleView(focusedField: $focusedField)
                .frame(height: screenHeight * titleHeightRatio)
              
              ContentView(focusedField: $focusedField)
                .frame(maxHeight: .infinity)
                .padding(.bottom, screenHeight * contentViewBottomSpacerHeightRatio)
            }
            .toolbar {
              ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("閉じる") {
                  focusedField = nil   // どちらの入力でも閉じられる
                }
              }
            }
            
            Spacer()
            
//            AdBannerView()
            ZStack {
              Color.gray.opacity(0.5)
              Text("Ad Banner")
                .foregroundStyle(Color.white)
            }
              .frame(height: 50)
          }
          
          SideMenuView(isOpen: $viewModel.isSideMenuOpen)
          
          if viewModel.isKeyboardVisible {
            Color.black.opacity(0.001)
              .ignoresSafeArea()
              .onTapGesture {
              
                UIApplication.shared.sendAction(
                  #selector(UIResponder.resignFirstResponder),
                  to: nil,
                  from: nil,
                  for: nil
                )
              }
          }
        }
        .ignoresSafeArea(.keyboard)
      }
    }
    .navigationBarHidden(true)
    .accentColor(.gray)
    
    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
      viewModel.isKeyboardVisible = true
    }
    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
      viewModel.isKeyboardVisible = false
    }
  }
}

#Preview {
  TopView()
}
