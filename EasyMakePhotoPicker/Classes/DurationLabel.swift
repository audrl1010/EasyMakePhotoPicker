//
//  DurationLabel.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 30..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit


public class DurationLabel: UILabel {
  
  public struct Constant {
    public static let padding = UIEdgeInsets(top: 5, left: 3, bottom: 5, right: 3)
  }
  
  public struct Color {
    public static let bgColor = UIColor(
      red: 0/255,
      green: 0/255,
      blue: 0/255,
      alpha: 0.35)
    
    public static let durationLabelTextColor = UIColor.white
  }
  
  public struct Font {
    public static let durationLabelFont = UIFont.systemFont(ofSize: 14)
  }
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  public func commonInit() {
    backgroundColor = Color.bgColor
    textColor = Color.durationLabelTextColor
    font = Font.durationLabelFont
    text = "00:00"
  }
  
  override public func drawText(in rect: CGRect) {
    super.drawText(in: UIEdgeInsetsInsetRect(rect, Constant.padding))
  }
  
  override public var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(
      width: size.width + Constant.padding.left + Constant.padding.right,
      height: size.height + Constant.padding.top + Constant.padding.bottom)
  }
}





