//
//  ContactViewModel.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/09/14.
//

import Foundation
import MessageUI

@MainActor
final class ContactItemViewModel: ObservableObject {

  // MARK: - Properties

  private let recipients: [String] = ["info.ikinarimemo@gmail.com"]
  private let bodyText: String = "お問い合わせの内容をご記入ください"

  @Published var isShowingMailView = false

  var canSendMail: Bool {
    MFMailComposeViewController.canSendMail()
  }

  // MARK: - Methods

  func sendMail() {
    guard canSendMail else {
      print("この端末ではメールを送信できません")
      return
    }
    isShowingMailView = true
  }

  func getRecipients() -> [String] {
    recipients
  }
  
  func getbodyText() -> String {
    bodyText
  }
}
