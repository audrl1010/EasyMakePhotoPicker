//
//  InputBar.swift
//  KaKaoChatInputView
//
//  Created by smg on 2017. 5. 13..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

class InputBar: BaseView {
  
  // MARK: - Constants
  fileprivate struct Constant {
    
    static let maxNumberOfLines = CGFloat(4)
    static let placeholder = "Input..."
    static let textContainerLineFragmentPadding = CGFloat(0)
    static let textContainerInsets =
      UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    static let textBorderViewPadding =
      UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
    
    static let intrinsicContentSize =
      CGSize(width: UIViewNoIntrinsicMetric, height: Metric.height)
    
    static let textViewBorderWidth = CGFloat(0.1)
    
    static let textViewCornerRadius = CGFloat(3)
    
    static let plusButtonLineWidth = CGFloat(3)
  }
  
  fileprivate struct Font {
    
    static let placeholderFont = UIFont.systemFont(ofSize: 14)
  }
  
  fileprivate struct Color {
    
    static let containerViewColor =
      UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
    static let textViewPlaceholderColor =
      UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
    static let textViewTextColor = UIColor.darkGray
    static let textViewBGColor = UIColor.white
    static let textViewTintColor = UIColor.white
    static let textBorderViewBGColor = UIColor(white: 0.9, alpha: 1)
    static let plusButtonLineColor = UIColor.gray
  }
  
  fileprivate struct Metric {
    
    static let height = CGFloat(44)
    
    static let textBorderViewHeight = CGFloat(0.1)
    
    static let textViewLeft = CGFloat(5)
    static let textViewRight = CGFloat(-10)
    
    static let plusButtonWidth = CGFloat(30)
    static let plusButtonHeight = CGFloat(30)
    static let plusButtonBottom = CGFloat(-8)
    static let plusButtonLeft = CGFloat(5)
  }
  
  // MARK: - Properites
  
  var textViewDidTap: (() -> Void)?
  
  var heightConstraint: NSLayoutConstraint?
  
  var containerView = UIView().then {
    $0.backgroundColor = Color.containerViewColor
  }
  
  var textBorderView = UIView().then {
    $0.backgroundColor = Color.textBorderViewBGColor
    $0.layer.borderWidth = Constant.textViewBorderWidth
  }
  
  var plusButton = PlusButton().then() {
    $0.lineColor = Color.plusButtonLineColor
    $0.lineWidth = Constant.plusButtonLineWidth
  }
  
  var textView = TextView().then {
    $0.maxNumberOfLines = Constant.maxNumberOfLines
    $0.font = Font.placeholderFont
    $0.placeholder = Constant.placeholder
    $0.textContainerInset = Constant.textContainerInsets
    $0.textContainer.lineFragmentPadding =
      Constant.textContainerLineFragmentPadding
    $0.tintColor = Color.textViewTintColor
    $0.backgroundColor = Color.textViewBGColor
    $0.layer.borderWidth = Constant.textViewBorderWidth
    $0.layer.cornerRadius = Constant.textViewCornerRadius
  }
  
  // MARK: - View Life Cycle
  
  override func setupViews() {
    super.setupViews()
    
    addSubview(containerView)
    containerView.addSubview(textBorderView)
    containerView.addSubview(plusButton)
    containerView.addSubview(textView)
    
    backgroundColor = .clear
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTextView))
    tap.delegate = self
    textView.addGestureRecognizer(tap)
    textView.delegate = self
    textView.heightDidChange = { [weak self] newHeight in
      guard let `self` = self else { return }
      let padding = Metric.height - self.textView.minimumHeight
      let height = padding + newHeight
      
      for constraint in self.constraints {
        if constraint.firstAttribute ==
          NSLayoutAttribute.height &&
          constraint.firstItem as! NSObject == self {
          constraint.constant =
            height < Metric.height ? Metric.height : height
          UIView.animate(withDuration: 0.01) { [weak self] in
            guard let `self` = self else { return }
            self.setNeedsLayout()
            self.layoutIfNeeded()
          }
        }
      }
    }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    containerView
      .fs_leftAnchor(equalTo: leftAnchor)
      .fs_rightAnchor(equalTo: rightAnchor)
      .fs_topAnchor(equalTo: topAnchor)
      .fs_bottomAnchor(equalTo: bottomAnchor)
      .fs_endSetup()
    
    textBorderView
      .fs_leftAnchor(equalTo: containerView.leftAnchor)
      .fs_rightAnchor(equalTo: containerView.rightAnchor)
      .fs_topAnchor(equalTo: containerView.topAnchor)
      .fs_heightAnchor(equalToConstant: Metric.textBorderViewHeight)
      .fs_endSetup()
    
    plusButton
      .fs_leftAnchor(
        equalTo: containerView.leftAnchor,
        constant: Metric.plusButtonLeft)
      .fs_bottomAnchor(
        equalTo: containerView.bottomAnchor,
        constant: Metric.plusButtonBottom)
      .fs_widthAnchor(equalToConstant: Metric.plusButtonWidth)
      .fs_heightAnchor(equalToConstant: Metric.plusButtonHeight)
      .fs_endSetup()
    
    let padding = (Metric.height - textView.minimumHeight) / 2
    
    textView
      .fs_leftAnchor(
        equalTo: plusButton.rightAnchor,
        constant: Metric.textViewLeft)
      .fs_rightAnchor(
        equalTo: containerView.rightAnchor,
        constant: Metric.textViewRight)
      .fs_topAnchor(
        equalTo: containerView.topAnchor,
        constant: padding)
      .fs_bottomAnchor(
        equalTo: containerView.bottomAnchor,
        constant: -padding)
      .fs_endSetup()
  }
  
  override var intrinsicContentSize: CGSize {
    return Constant.intrinsicContentSize
  }
}


// MARK: Events
extension InputBar {
  func didTapTextView() {
    guard let textViewDidTap = textViewDidTap else { return }
    textViewDidTap()
  }
}

// MARK: - UITextViewDelegate

extension InputBar: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    self.textView.textViewDidChange()
  }
}

// MARK: - UIGestureRecognizerDelegate

extension InputBar: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
