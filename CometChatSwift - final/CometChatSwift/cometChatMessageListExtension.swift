//
//  cometChatMessageListExtension.swift
//  CometChatSwift
//
//  Created by Margels on 31/07/22.
//  Copyright © 2022 MacMini-03. All rights reserved.
//

import Foundation
import UIKit
import CometChatPro

extension CometChatMessageList {

    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        typingIndicatorBubble = createTypingIndicator()
        typingAvatars = createAvatarsStackView()
        
    }
    
    private func createTypingIndicator() -> typingIndicatorView {
        let typingIndicator = typingIndicatorView()
        typingIndicator.alpha = 0
        view.insertSubview(typingIndicator, belowSubview: textView)
        var typingIndicatorBottomConstraint = typingIndicator.constraints.first(where: { $0.firstAttribute == .bottom  })
        typingIndicatorBottomConstraint = typingIndicator.bottomAnchor.constraint(
            equalTo: textView.topAnchor,
         constant: -16)
        typingIndicatorBottomConstraint?.isActive = true
        NSLayoutConstraint.activate([
         typingIndicator.heightAnchor.constraint(equalToConstant: 30),
         typingIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25)
        ])
        return typingIndicator
    }
    
    func createAvatarsStackView() -> UIStackView {
        
        let sv = UIStackView()
        sv.axis = .horizontal
        view.insertSubview(sv, belowSubview: typingIndicatorBubble)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 5
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: typingIndicatorBubble.trailingAnchor, constant: 10),
            sv.heightAnchor.constraint(equalTo: typingIndicatorBubble.heightAnchor),
            sv.centerYAnchor.constraint(equalTo: typingIndicatorBubble.centerYAnchor),
            sv.widthAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])
        return sv
        
    }
    
    func createAvatar(_ url: String) -> UIImageView? {
        let iv = UIImageView()
        if let url = URL(string: url), let data = try? Data(contentsOf: url) {
            let i = UIImage(data: data)
            iv.image = i
            iv.layer.cornerRadius = iv.frame.height / 2
            iv.contentMode = .scaleAspectFit
            return iv
        } else {
            print("image of user: nil")
        }
        return UIImageView()
    }
    
    func showTypingIndicator(_ bool: Bool) {
        let alpha: CGFloat = bool ? 1 : 0
        
        self.tableViewBottomConstraint.constant = 75
        self.tableView?.scrollToBottomRow()
        
        UIView.animate(withDuration: 0.5) {
            self.typingIndicatorBubble.alpha = alpha
        } completion: { success in
            let constant: CGFloat = bool ? 75 : 0
            self.tableViewBottomConstraint.constant = constant
            self.tableView?.scrollToBottomRow()

        }

    }
    
    /**
     This method triggers when real time event for  start typing received from  CometChat Pro SDK
     - Parameter typingDetails: This specifies TypingIndicator Object.
     - Author: CometChat Team
     - Copyright:  ©  2020 CometChat Inc.
     - See Also:
     [CometChatMessageList Documentation](https://prodocs.cometchat.com/docs/ios-ui-screens#section-4-comet-chat-message-list)
     */
    public func onTypingStarted(_ typingDetails: TypingIndicator) {
        
        DispatchQueue.main.async{ [weak self] in
            guard let strongSelf = self else { return }
            if typingDetails.sender?.uid == strongSelf.currentUser?.uid && typingDetails.receiverType == .user {
                
                
                strongSelf.showTypingIndicator(true)
                
            } else if typingDetails.receiverType == .group  && typingDetails.receiverID == strongSelf.currentGroup?.guid {
                
                
                strongSelf.showTypingIndicator(true)
                if let str = typingDetails.sender?.avatar, let image = strongSelf.createAvatar(str), let group = self?.groupMembers, !group.contains(where: { $0 == str }) {
                    
                    print("calling first function")
                    image.tag = 100 + group.count
                    self?.groupMembers.append(str)
                    NSLayoutConstraint.activate([
                        image.widthAnchor.constraint(equalToConstant: 15),
                        image.heightAnchor.constraint(equalToConstant: 15)
                    ])
                    self?.typingAvatars.insertArrangedSubview(image, at: 0)
                }
                    
                }
            }
        }
    
    
    /**
     This method triggers when real time event for  stop typing received from  CometChat Pro SDK
     - Parameter typingDetails: This specifies TypingIndicator Object.
     - Author: CometChat Team
     - Copyright:  ©  2020 CometChat Inc.
     - See Also:
     [CometChatMessageList Documentation](https://prodocs.cometchat.com/docs/ios-ui-screens#section-4-comet-chat-message-list)
     */
    public func onTypingEnded(_ typingDetails: TypingIndicator) {
        
        DispatchQueue.main.async{ [weak self] in
            guard let strongSelf = self else { return }
            
            if typingDetails.sender?.uid == strongSelf.currentUser?.uid && typingDetails.receiverType == .user{
                
                strongSelf.showTypingIndicator(false)
                
            } else if typingDetails.receiverType == .group  && typingDetails.receiverID == strongSelf.currentGroup?.guid {
                
                
                if let str = typingDetails.sender?.avatar, let group = self?.groupMembers, group.contains(where: { $0 == str }), let i = group.firstIndex(of: str), let view = self?.typingAvatars.viewWithTag(100+(i)) {
                    
                    print("calling second function")
                    self?.groupMembers.remove(at: i)
                    self?.typingAvatars.removeArrangedSubview(view)
                    view.removeFromSuperview()
                    
                    if self?.groupMembers.count == 0 {
                        strongSelf.showTypingIndicator(false)
                    }
                }
            }
        }
    }

    
    
}

