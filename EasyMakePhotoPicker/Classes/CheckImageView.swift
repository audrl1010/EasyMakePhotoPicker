//
//  CheckImageView.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

open class CheckImageView: BaseView {
  
  open var lineWidth: CGFloat = 2.5 {
    didSet {
      setNeedsLayout()
    }
  }
  
  open var checkColor: UIColor = UIColor.white {
    didSet {
      setNeedsLayout()
    }
  }
  
  open override func setupViews() {
    super.setupViews()
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  open override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    let path = UIBezierPath()
    path.lineJoinStyle = .round
    path.lineCapStyle = .round
    path.lineWidth = lineWidth
    
    checkColor.setStroke()
    
    path.move(
      to: CGPoint(x: rect.midX - 5, y: rect.midY))
    
    path.addLine(
      to: CGPoint(x: rect.midX - 1, y: rect.midY + 4))
    
    path.addLine(
      to: CGPoint(x: rect.midX + 6, y: rect.midY - 4))
    
    path.stroke()
  }
}
