//
//  typingIndicatorView.swift
//  CometChatSwift
//
//  Created by Margels on 30/07/22.
//  Copyright © 2022 MacMini-03. All rights reserved.
//

import UIKit
import CometChatPro

class typingIndicatorView: UIView {

    private enum Constants {
        
        static let size: CGFloat = 7
        static let scaleDuration: Double = 1
        static let scaleAmount: Double = 0.4
        static let delayBetweenRepeats: Double = 0.7
        
     }
    
    private var stack: UIStackView!
    
    init() {
        super.init(frame: .zero)
        createView()
    }
    
    override var intrinsicContentSize: CGSize {
     stack.intrinsicContentSize
        
    }
    
    private func createView() {
        translatesAutoresizingMaskIntoConstraints = false
           let bubble = makeBubble()
           bubble.translatesAutoresizingMaskIntoConstraints = false
           stack = UIStackView()
           stack.translatesAutoresizingMaskIntoConstraints = false
           stack.axis = .horizontal
           stack.alignment = .center
           stack.spacing = 5
           
           let totDots = 3
           for i in 1...totDots {
               let dot = makeDot(animationDelay: Double(i)/Double(totDots))
               stack.insertArrangedSubview(dot, at: i-1)
               
               if i == totDots {
                   addSubview(bubble)
                   bubble.addSubview(stack)
                   self.createConstraints(bubble: bubble, stack: stack)
                   
               }
           }
           
    }
    
    

    
    func createConstraints(bubble: UIView, stack: UIView) {
        
        let bubbleWidth = (Constants.size * 3) + (5 * 2) + (5 * 3)
        let stackWidth: CGFloat = ((7*3)+(5*2))
        print("anchor:", (bubbleWidth-stackWidth))
        
        NSLayoutConstraint.activate([
         bubble.leadingAnchor.constraint(equalTo: leadingAnchor),
         bubble.trailingAnchor.constraint(equalTo: trailingAnchor),
         bubble.topAnchor.constraint(equalTo: topAnchor),
         bubble.bottomAnchor.constraint(equalTo: bottomAnchor),
         stack.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 11),
         stack.centerYAnchor.constraint(equalTo: bubble.centerYAnchor)
        ])
        
    }
    
    func makeBubble() -> UIView {
        
        let width = (Constants.size * 3) + (5 * 2) + (5 * 3)
        let height = (Constants.size) + (10 * 2)
        
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width:  width, height: height)))
        view.layer.cornerRadius = view.frame.size.height / 2
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
        
    }
    
    func makeDot(animationDelay: Double) -> UIView {
    let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: Constants.size, height: Constants.size)))
     view.translatesAutoresizingMaskIntoConstraints = false
     view.widthAnchor.constraint(equalToConstant: Constants.size).isActive = true
        
        let circle = CAShapeLayer()
        let path = UIBezierPath(
         arcCenter: .zero,
         radius: Constants.size / 2,
         startAngle: 0,
         endAngle: 2 * .pi,
         clockwise: true)
        circle.path = path.cgPath
        circle.frame = view.bounds
        circle.fillColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(circle)
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = Constants.scaleDuration / 2
        animation.toValue = Constants.scaleAmount
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.autoreverses = true
        
        let animation2 = CABasicAnimation(keyPath: "transform.scale")
        animation2.duration = Constants.scaleDuration / 2
        animation2.toValue = 1.2
        animation2.isRemovedOnCompletion = false
        animation2.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation2.autoreverses = true
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation, animation2]
        animationGroup.duration = Constants.scaleDuration + Constants.delayBetweenRepeats
        animationGroup.repeatCount = .infinity
        animationGroup.beginTime = CACurrentMediaTime() + animationDelay
        
        circle.add(animationGroup, forKey: "pulse")
        
        return view
    }
    
    required init?(coder: NSCoder) {
     fatalError()
    }

}
