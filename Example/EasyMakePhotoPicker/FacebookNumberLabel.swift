//
//  FacebookNumberLabel.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import Photos
import RxSwift

class FacebookNumberLabel: UILabel {
  
  struct Constant {
    static let cornerRadius = CGFloat(5)
  }
  
  struct Color {
    static let labelTextColor = UIColor.white
    static let backgroundColor = UIColor(
      red: 104/255,
      green: 156/255,
      blue: 255/255,
      alpha: 1.0)
  }
  
  struct Font {
    static let labelFont = UIFont.systemFont(ofSize: 14)
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
    font = Font.labelFont
    textColor = Color.labelTextColor
    backgroundColor = Color.backgroundColor
    textAlignment = .center
    clipsToBounds = true
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = Constant.cornerRadius
    layer.masksToBounds = true
  }
}
