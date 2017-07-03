//
//  PlusButton.swift
//  KaKaoChatInputView
//
//  Created by smg on 2017. 5. 13..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

class PlusButton: UIButton {
  
  var lineColor: UIColor = .gray {
    didSet {
      setNeedsLayout()
    }
  }
  
  var lineWidth: CGFloat = 3 {
    didSet {
      setNeedsLayout()
    }
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    let padding = CGFloat(8)
    let drawingRect = rect.insetBy(dx: padding, dy: padding)
    
    let path = UIBezierPath()
    path.lineJoinStyle = .round
    path.lineWidth = lineWidth
    lineColor.setStroke()
    
    path.move(
      to: CGPoint(x: padding,
                  y: padding + drawingRect.height/2 + 0.5))
    path.addLine(
      to: CGPoint(x: padding + drawingRect.width,
                  y: padding + drawingRect.height/2 + 0.5))
    path.close()
    
    path.move(
      to: CGPoint(x: padding + drawingRect.width/2 + 0.5,
                  y: padding))
    path.addLine(
      to: CGPoint(x: padding + drawingRect.width/2 + 0.5,
                  y: padding + drawingRect.height + 0.5))
    path.close()
    
    path.stroke()
  }
}
