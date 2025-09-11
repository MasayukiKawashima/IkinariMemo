//
//  ContentView.swift
//  Child
//
//  Created by 川島真之 on 2025/07/07.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
  
  // MARK: - Properties
  
  @StateObject private var viewModel: ContentViewModel = ContentViewModel()
  var focusedField: FocusState<TopView.FocusedField?>.Binding
  private let TextEditorSidePaddingRatio: CGFloat = 0.024
  private let placeholderText: String = "本文"
  
  // MARK: - Body
  
  var body: some View {
    GeometryReader { geometry in
      ScrollView(.vertical, showsIndicators: true) {
        
        ZStack(alignment: .topLeading) {
          
          Color.clear
            .contentShape(Rectangle()) // タップ判定を全体に
            .onTapGesture {
              focusedField.wrappedValue = .content
            }
          
          TextEditor(text: Binding(
            get: { viewModel.textContent },
            set: { viewModel.updateContent($0) }
          ))
//          .font(.system(size: 64))
          .padding(.horizontal, geometry.size.width * TextEditorSidePaddingRatio)
          .frame(width: geometry.size.width, height: geometry.size.height)
          .focused(focusedField, equals: .content)
          
          HStack {
            Text("本文")
              .opacity(viewModel.textContent.isEmpty ? 0.3 : 0.0)
              .padding(.init(top: 9, leading: 8, bottom: 0, trailing: 0))
              .allowsHitTesting(false)
            
            Spacer()
          }
          .padding(.horizontal, geometry.size.width * TextEditorSidePaddingRatio)
        }

      }
    }
  }
}
