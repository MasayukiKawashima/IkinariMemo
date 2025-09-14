//
//  ContactItemView.swift
//  Child
//
//  Created by 川島真之 on 2025/09/14.
//

import SwiftUI
import MessageUI

struct ContactItemView: View {
    @StateObject private var viewModel = ContactItemViewModel() // ← ViewModelを保持
    
    var body: some View {
        Button {
            viewModel.sendMail()
        } label: {
            HStack {
                Text("お問い合わせ")
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
            }
            .contentShape(Rectangle()) // 行全体をタップ可能に
        }
        .disabled(!viewModel.canSendMail) // 送信不可なら無効化
        .sheet(isPresented: $viewModel.isShowingMailView) {
            MailView(recipients: viewModel.getRecipients())
        }
    }
}

#Preview {
    ContactItemView()
}
