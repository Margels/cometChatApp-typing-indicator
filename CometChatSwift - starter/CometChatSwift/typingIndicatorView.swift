//
//  typingIndicatorView.swift
//  CometChatSwift
//
//  Created by Margels on 04/08/22.
//  Copyright © 2022 MacMini-03. All rights reserved.
//

import UIKit

class typingIndicatorView: UIView {

    // init
    init() {
        super.init(frame: .zero)
        // createView()
    }
    
    // define view content size
    override var intrinsicContentSize: CGSize {
    	stack.intrinsicContentSize
        
    }

    required init?(coder: NSCoder) {
    	fatalError()
    }


}
