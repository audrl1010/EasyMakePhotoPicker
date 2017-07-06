//
//  DurationLabel.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 30..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit


class DurationLabel: UILabel {
  
  struct Constant {
    static let padding = UIEdgeInsets(top: 5, left: 3, bottom: 5, right: 3)
  }
  
  struct Color {
    static let bgColor = UIColor(
      red: 0/255,
      green: 0/255,
      blue: 0/255,
      alpha: 0.35)
    
    static let durationLabelTextColor = UIColor.white
  }
  
  struct Font {
    static let durationLabelFont = UIFont.systemFont(ofSize: 14)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  func commonInit() {
    backgroundColor = Color.bgColor
    textColor = Color.durationLabelTextColor
    font = Font.durationLabelFont
    text = "00:00"
  }
  
  override func drawText(in rect: CGRect) {
    super.drawText(in: UIEdgeInsetsInsetRect(rect, Constant.padding))
  }
  
  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(
      width: size.width + Constant.padding.left + Constant.padding.right,
      height: size.height + Constant.padding.top + Constant.padding.bottom)
  }
}





