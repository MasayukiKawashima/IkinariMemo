//
//  SideMenuView.swift
//  Child
//
//  Created by 川島真之 on 2025/07/08.
//

import SwiftUI

struct SideMenuView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: SideMenuViewModel = SideMenuViewModel()
  
  @Binding var isOpen: Bool
  
  
  private let maxWidth = UIScreen.main.bounds.width
  
  // Iphone16Pro(Height: 874px)を基準に各レートを算出
  // 例　memoRowsHeightRatio → 38 % 874 = 0.043478.....
  private let memoRowsHeightRatio: CGFloat = 0.0434
  private let moreTextHeightRatio: CGFloat = 0.0228
  private let gearshapeIconHeightRatio: CGFloat = 0.040
  private let gearshapeIconLeadingPaddingRatio = 0.017
  private let xmarkIconHeightRatio: CGFloat = 0.040
  private let xmarkIconTrailingPaddingRatio = 0.017
  private let moreSectionFotterHeightRatio: CGFloat = 0.068
  private let settingsSectionSpaceRatio: CGFloat = 0.0228
  
  // MARK: - Body
  
  var body: some View {
    ZStack {
        GeometryReader { geometry in
          Color.black
            .edgesIgnoringSafeArea(.all)
            .opacity(isOpen ? 0.4 : 0)
            .onTapGesture {
              withAnimation(.linear(duration: 0.2)) {
                isOpen.toggle()
              }
            }
          ZStack {
            
            let fullHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
            
            List() {
              
              Section {
                ForEach(viewModel.getDisplayItems()) { item in
                  HStack {
                    Text(item.displayTitle)
                      .frame(height: fullHeight * memoRowsHeightRatio)
                      .lineLimit(1)
                      .truncationMode(.tail)
                    
                    Spacer()
                  }
                  .contentShape(Rectangle())
                  .onTapGesture {
                    handleMemoTap(item)
                  }
                }
                .onDelete { offsets in
                  viewModel.deleteItems(at: offsets)
                }
              }
              
              Section {
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
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
              } footer: {
                Spacer()
                  .frame(height: fullHeight * moreSectionFotterHeightRatio)
              }

              
              Section {
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
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
              }
            }
            .scrollDisabled(true)
            .listStyle(.grouped)
            .frame(maxHeight: geometry.size.height)
          }
          .padding(.trailing, maxWidth/4)
          .offset(x: isOpen ? 0 : -maxWidth)
        }
      
    }
  }
  
  private func handleMemoTap(_ item: UserMemoListItem) {
    if !item.isEmpty {
      viewModel.selectMemo(item)
      withAnimation(.linear(duration: 0.2)) {
        isOpen = false
      }
    }
  }
}
