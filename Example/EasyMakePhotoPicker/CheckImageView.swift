//
//  CheckImageView.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

class CheckImageView: BaseView {
  
  struct Color {
    static let bgColor = UIColor(
      red: 132/255,
      green: 132/255,
      blue: 132/255,
      alpha: 0.6)
    
    static let checkColor = UIColor.white
  }
  
  struct Constant {
    static let lineWidth = CGFloat(2.5)
  }
  
  var bgColor: UIColor = Color.bgColor {
    didSet {
      setNeedsLayout()
    }
  }
  
  var lineWidth: CGFloat = Constant.lineWidth {
    didSet {
      setNeedsLayout()
    }
  }
  
  var checkColor: UIColor =  Color.checkColor {
    didSet {
      setNeedsLayout()
    }
  }
  
  override func setupViews() {
    super.setupViews()
    backgroundColor = Color.bgColor
    clipsToBounds = true
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = bounds.height / 2
  }
  
  override func draw(_ rect: CGRect) {
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
