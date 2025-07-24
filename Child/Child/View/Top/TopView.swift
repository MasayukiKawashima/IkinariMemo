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
  
  // iPhone16Proの画面のHeight874（CSSピクセル）を基準に算出
  private let titleHeightRatio: CGFloat = 0.11
  private let contentHeightRatio: CGFloat = 0.66
  private let sideMenuIconBottomSpacerHeightRatio: CGFloat = 0.06
  private let contentViewBottomSpacerHeightRatio: CGFloat = 0.023
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
                  .font(.system(size: geometry.size.height * iconSizeRatio , weight: .bold))
                  .foregroundStyle(Color.black)
                  .padding(.leading, geometry.size.width * iconSidePaddingRatio)
              }
              
              Spacer()
              
              //新規メモ作成ボタン
              Button(action: {
                viewModel.upDateCurrentUserMemo()
              }) {
                Image(systemName: "pencil.circle.fill")
                  .font(.system(size: geometry.size.height * iconSizeRatio , weight: .bold))
                  .foregroundStyle(Color.black)
                  .padding(.trailing, geometry.size.width * iconSidePaddingRatio)
              }
            }
            
            Spacer().frame(height: geometry.size.height * sideMenuIconBottomSpacerHeightRatio)
            
            TitleView()
                .frame(height: geometry.size.height * titleHeightRatio)
              
            ContentView()
                .frame(height: geometry.size.height * contentHeightRatio)
            
            
            Spacer().frame(height: geometry.size.height * contentViewBottomSpacerHeightRatio)
            
            Color.yellow
              .frame(height: adBannerHeight)
              .overlay(Text("Ad Banner"))
          }
          SideMenuView(isOpen: $viewModel.isSideMenuOpen)
        }
      }
    }
    .navigationBarHidden(true)
    .accentColor(.gray)
  }
}

#Preview {
  TopView()
}
