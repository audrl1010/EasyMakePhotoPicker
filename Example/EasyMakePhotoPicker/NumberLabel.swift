//
//  NumberLabel.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 25..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

class NumberLabel: BaseView {
  
  struct Color {
    static let labelTextColor = UIColor.black
    static let backgroundColor = UIColor(
      red: 255/255,
      green: 255/255,
      blue: 0/255,
      alpha: 1.0)
  }
  
  struct Font {
    static let labelFont = UIFont.systemFont(ofSize: 12)
  }
  
  var number: Int = 0 {
    didSet {
      label.text = "\(number)"
    }
  }
  
  var font: UIFont = Font.labelFont {
    didSet {
      label.font = font
    }
  }
  
  var label = UILabel().then {
    $0.font = Font.labelFont
    $0.textColor = Color.labelTextColor
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = frame.height / 2
  }
  
  override func setupViews() {
    super.setupViews()
    addSubview(label)
    backgroundColor = Color.backgroundColor
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    label
      .fs_centerXAnchor(equalTo: centerXAnchor)
      .fs_centerYAnchor(equalTo: centerYAnchor)
      .fs_endSetup()
  }
}









