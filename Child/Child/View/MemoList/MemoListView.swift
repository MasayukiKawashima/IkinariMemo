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
  
  private let screenWidth = UIScreen.main.bounds.width
  
  private let placerHolderTextFontSizeRatio: CGFloat = 0.08
  private let backgroundColor = Color(red: 0.95, green: 0.95, blue: 0.95)
  
  // MARK: - Body
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        
        let results = viewModel.hasAnyUserMemo()
        
        if results {
          
          List {
            Section {
              ForEach(viewModel.getDisplayItems()) { item in
                
                UserMemoListItemView(item: item)
                  .onTapGesture {
                    viewModel.selectMemo(item)
                    dismiss()
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
              .foregroundStyle(Color.customDarkGrayColor)
              .font(.system(size: screenWidth * placerHolderTextFontSizeRatio))
            
            Spacer()
          }
          .frame(maxWidth: .infinity)
        }
      }
      .customBackButton()
      .background(Color.listBackgroundColor)
    }
  }
}

#Preview {
    MemoListView()
}
