//
//  NumberLabel.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 25..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

public class NumberLabel: UILabel {
  public struct Color {
    public static let labelTextColor = UIColor.black
    public static let backgroundColor = UIColor(
      red: 255/255,
      green: 255/255,
      blue: 0/255,
      alpha: 1.0)
  }
  
  public struct Font {
    public static let labelFont = UIFont.systemFont(ofSize: 12)
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
    font = Font.labelFont
    textColor = Color.labelTextColor
    backgroundColor = Color.backgroundColor
    textAlignment = .center
    clipsToBounds = true
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = frame.height / 2
  }
}









