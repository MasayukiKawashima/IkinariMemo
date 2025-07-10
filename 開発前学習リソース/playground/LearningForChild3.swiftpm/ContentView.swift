import SwiftUI

// MARK: - ContentView

struct ContentView: View {
  /// メニューの開閉
  @State var isMenuOpen = false
  
  var body: some View {
    ZStack {
      NavigationStack {
        Text("ContentView")
          .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
              Button {
                /// isMenuOpenの変化にアニメーションをつける
                withAnimation(.easeInOut(duration: 0.3)) {
                  isMenuOpen.toggle()
                }
              } label: {
                Image(systemName: "line.3.horizontal")
              }
            }
          }
      }
      MenuView(isOpen: $isMenuOpen)
    }
  }
}

// MARK: - MenuView

struct MenuView: View {
  /// メニュー開閉
  @Binding var isOpen: Bool
  /// iPhoneの幅
  private let maxWidth = UIScreen.main.bounds.width
  
  var body: some View {
    ZStack {
      /// isOpenで背景が透明な黒になる
      /// この黒をタップすると閉じる
      Color.black
        .edgesIgnoringSafeArea(.all)
        .opacity(isOpen ? 0.7 : 0)
        .onTapGesture {
          /// isOpenの変化にアニメーションをつける
          withAnimation(.easeInOut(duration: 0.3)) {
            isOpen.toggle()
          }
        }
      ZStack {
        List {
          /// 注意：増やしすぎて縦スクロールになると使いづらくなる
          Section {
            /// ここをNavigationLinkにするとそれっぽい
            HStack {
              Image(systemName: "gearshape")
              Text("設定")
            }
            HStack {
              Image(systemName: "info.circle")
              Text("アプリケーション情報")
            }
          }
        }
        /// 開発者とか入れるとそれっぽい
        VStack {
          Spacer()
          Text("developed by")
            .font(.footnote)
          Text("Cafe")
            .font(.footnote)
        }
        .foregroundColor(.secondary)
        .padding()
      }
      /// 画面幅の1/4だけ右側を開ける
      .padding(.trailing, maxWidth/4)
      /// isOpenで、そのままの位置か、画面幅だけ右にズレるかを決める
      .offset(x: isOpen ? 0 : -maxWidth)
    }
  }
}

