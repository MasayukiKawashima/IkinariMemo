//
//  ContactViewModel.swift
//  Child
//
//  Created by 川島真之 on 2025/09/14.
//

import Foundation
import MessageUI

@MainActor
final class ContactItemViewModel: ObservableObject {
    
    private let recipients: [String] = ["example@example.com"]
    
    @Published var isShowingMailView = false
    
    var canSendMail: Bool {
        MFMailComposeViewController.canSendMail()
    }
    
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
}

