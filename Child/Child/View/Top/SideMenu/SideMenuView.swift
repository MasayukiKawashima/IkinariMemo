//
//  SideMenuView.swift
//  Child
//
//  Created by 川島真之 on 2025/07/08.
//

import SwiftUI

struct SideMenuView: View {
  
  //memo fullHeight = 874, geometry.size.height = 778.0
  //memoTitleFontSize = 17.7384, memoUpdateDateFontSize = 12.448
  
  // MARK: - Properties
  
  @StateObject var viewModel: SideMenuViewModel = SideMenuViewModel()
  
  @Binding var isOpen: Bool
  
  private let maxWidth = UIScreen.main.bounds.width
  
  private let backgroundColor = Color(red: 0.95, green: 0.95, blue: 0.95)
  
  // Iphone16Pro(Height: 874px, Width: 402px)を基準に各レートを算出
  // 例　memoRowsHeightRatio → 38 % 874 = 0.043478.....
  private let memoRowsHeightRatio: CGFloat = 0.0286
  private let moreTextHeightRatio: CGFloat = 0.0228
  private let gearshapeIconHeightRatio: CGFloat = 0.040
  private let gearshapeIconLeadingPaddingRatio = 0.017
  private let xmarkIconHeightRatio: CGFloat = 0.040
  private let xmarkIconTrailingPaddingRatio = 0.017
  private let moreTextTrailingPaddingRatio = 0.017
  private let moreSectionFotterHeightRatio: CGFloat = 0.068
  private let settingsSectionSpaceRatio: CGFloat = 0.0228
  private let placerHolderTextFontSizeRatio: CGFloat = 0.08
  
  // MARK: - Body
  
  var body: some View {
    ZStack() {
      GeometryReader { geometry in
        Color.black
          .edgesIgnoringSafeArea(.all)
          .opacity(isOpen ? 0.4 : 0)
          .onTapGesture {
            withAnimation(.linear(duration: 0.2)) {
              isOpen.toggle()
            }
          }
        
        VStack {
          let fullHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
          
          let results = viewModel.hasAnyUserMemo()
          //メモが一件でもある場合
          if results {
            //　メモリスト
            List() {
              Section {
                ForEach(viewModel.getDisplayItems()) { item in
                  
                  UserMemoListItemView(item: item)
                    .onTapGesture {
                      handleMemoTap(item)
                    }
                }
                .onDelete { offsets in
                  viewModel.deleteItems(at: offsets)
                }
              }
            }
            .frame(height: geometry.size.height * 0.7)
            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
            .listStyle(.grouped)
          } else {
            //メモが一件もない場合
            VStack {
              Text("No Memos")
                .bold()
                .font(.system(size: geometry.size.width * placerHolderTextFontSizeRatio))
            }
            .frame(height: geometry.size.height * 0.7)
          }
          
          // moreボタン
          NavigationLink(
            destination: MemoListView()
              .onAppear {
                // 画面遷移のアニメーション時間を考慮して遅延
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  isOpen = false
                }
              }
          ) {
            HStack(spacing: 4) {
              Spacer()
              Text("more")
                .font(.system(size: fullHeight * moreTextHeightRatio))
            }
            .foregroundStyle(.gray)
            .padding(.top, 8)
            .padding(.trailing,  fullHeight * moreTextTrailingPaddingRatio)
          }
          
          Spacer()
          //　閉じる、設定ボタン
          VStack(spacing: fullHeight * settingsSectionSpaceRatio) {
            Divider()
              .frame(height: 1.5)
              .background(Color.gray.opacity(0.4))
              .shadow(color: Color.black.opacity(0.4),
                      radius: 4, x: 0, y: -2)
            
            HStack {
              Image(systemName: "gearshape")
                .font(.system(size: fullHeight * gearshapeIconHeightRatio))
                .foregroundStyle(.gray)
                .padding(.leading, fullHeight * gearshapeIconLeadingPaddingRatio)
              Spacer()
              
              Button(action: {
                withAnimation(.linear(duration: 0.2)) {
                  isOpen.toggle()
                } }) {
                  Image(systemName: "xmark")
                    .font(.system(size: fullHeight * xmarkIconHeightRatio))
                }
                .buttonStyle(XmarkButtonColorStyle())
                .padding(.trailing, fullHeight * xmarkIconTrailingPaddingRatio)
            }
          }
          .padding(.bottom, 10)
        }
        .frame(height: geometry.size.height)
        .background(backgroundColor)
        .padding(.trailing, maxWidth/4)
        .offset(x: isOpen ? 0 : -maxWidth)
      }
    }
    //// 左向きスワイプで閉じる処理
    .gesture(
      DragGesture()
        .onEnded { value in
          if value.translation.width < -50 {
            withAnimation {
              isOpen = false
            }
          }
        }
    )
    
  }
  
  // MARK: - Methods
  
  private func handleMemoTap(_ item: UserMemoListItem) {
    
    viewModel.selectMemo(item)
    withAnimation(.linear(duration: 0.2)) {
      isOpen = false
    }
  }
}
