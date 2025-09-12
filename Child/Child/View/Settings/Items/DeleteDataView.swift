//
//  DeleteDataView.swift
//  Child
//
//  Created by 川島真之 on 2025/09/11.
//

import SwiftUI

struct DeleteDataView: View {
  
  // MARK: - Properties
  
  @State private var isShowAlert = false
  
  // MARK: - Body
  
  var body: some View {
    VStack {
      List {
        HStack {
          Text("全てのメモを削除")
            .foregroundStyle(Color.red)
          
          Spacer()
          
          Button(action: {
              // ボタンがタップされた時のアクション
            isShowAlert.toggle()
          }) {
            Image(systemName: "trash.fill")
          }
          .alert("警告", isPresented: $isShowAlert) {
      
              Button("削除する", role: .destructive) {
                  // 🔴 削除処理を書く
                  print("削除実行")
              }
              
              Button("キャンセル", role: .cancel) {
              }
          } message: {
              Text("アプリ内の全てのデータを削除してもよろしいですか\nこの操作は取り消せません")
          }
        }
      }
    }
    .customBackButton()
  }
}

#Preview {
    DeleteDataView()
}
