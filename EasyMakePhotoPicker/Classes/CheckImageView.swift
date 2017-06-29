//
//  CheckImageView.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

public class CheckImageView: BaseView {
  
  public var lineWidth: CGFloat = 2.5 {
    didSet {
      setNeedsLayout()
    }
  }
  
  public var checkColor: UIColor = UIColor.white {
    didSet {
      setNeedsLayout()
    }
  }
  
  override public func setupViews() {
    super.setupViews()
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
  }
  
  override public func draw(_ rect: CGRect) {
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
