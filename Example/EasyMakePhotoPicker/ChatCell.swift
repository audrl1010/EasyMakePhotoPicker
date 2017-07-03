//
//  ChatCell.swift
//  KaKaoChatInputView
//
//  Created by smg on 2017. 5. 13..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

class ChatCell: BaseTableViewCell {
  
  // MARK: - Constants
  
  fileprivate struct Constant {
    static let labelNumberOfLines = 1
  }
  
  fileprivate struct Font {
    static let labelFont = UIFont.systemFont(ofSize: 16)
  }
  
  fileprivate struct Metric {
    static let labelLeft = CGFloat(10)
    static let labelRight = CGFloat(-10)
    static let labelTop = CGFloat(10)
    static let labelBottom = CGFloat(-10)
  }
  
  // MARK: - Properties
  
  var label = UILabel().then {
    $0.font = Font.labelFont
    $0.numberOfLines = Constant.labelNumberOfLines
  }
  
  // MARK: - Life Cycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  override func setupViews() {
    addSubview(label)
  }
  
  override func setupConstraints() {
    label
      .fs_leftAnchor(
        equalTo: leftAnchor,
        constant: Metric.labelLeft)
      .fs_rightAnchor(
        equalTo: rightAnchor,
        constant: Metric.labelRight)
      .fs_topAnchor(
        equalTo: topAnchor,
        constant: Metric.labelTop)
      .fs_bottomAnchor(
        equalTo: bottomAnchor,
        constant: Metric.labelBottom)
      .fs_endSetup()
  }
}
