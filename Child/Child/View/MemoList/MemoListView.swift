//
//  MemoListView.swift
//  Child
//
//  Created by 川島真之 on 2025/07/11.
//

import SwiftUI

struct MemoListView: View {
  
  // MARK: - Properties
  
  @StateObject var viewModel: MemoListViewModel = MemoListViewModel()
  @Environment(\.dismiss) private var dismiss
  
  private let placerHolderTextFontSizeRatio: CGFloat = 0.08
  private let backgroundColor = Color(red: 0.95, green: 0.95, blue: 0.95)
  
  // MARK: - Body
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        let fullHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
        let results = viewModel.hasAnyUserMemo()
        
        if results {
          
          List {
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
          .scrollContentBackground(.hidden)
          .listStyle(.grouped)
          
        } else {
          //プレスホルダーView
          VStack {
            Spacer()
            
            Text("No Memos")
              .bold()
              .font(.system(size: geometry.size.width * placerHolderTextFontSizeRatio))
            
            Spacer()
          }
          .frame(maxWidth: .infinity)
        }
      }
    }
    .background(backgroundColor)
  }
  
  // MARK: - Methods
  private func handleMemoTap(_ item: UserMemoListItem) {
    viewModel.selectMemo(item)
    dismiss()
  }
}

#Preview {
    MemoListView()
}
