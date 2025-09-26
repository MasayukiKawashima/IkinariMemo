//
//  MailView.swift
//  IkinariMemo
//
//  Created by 川島真之 on 2025/09/14.
//

import Foundation
import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
  
  // MARK: - Properties
  
  @Environment(\.dismiss) var dismiss
  
  let recipients: [String]
  
  
  // MARK: - Coordinator
  class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
    var parent: MailView
    init(parent: MailView) { self.parent = parent }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
      controller.dismiss(animated: true) {
        self.parent.dismiss()
      }
    }
  }
  
  // MARK: - Methods
  
  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
  
  
  func makeUIViewController(context: Context) -> MFMailComposeViewController {
    let vc = MFMailComposeViewController()
    vc.mailComposeDelegate = context.coordinator
    vc.setToRecipients(recipients)
    vc.setSubject("")               // 常に空
    vc.setMessageBody("", isHTML: false) // 常に空
    return vc
  }
  
  func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}



