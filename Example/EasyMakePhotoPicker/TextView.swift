//
//  TextView.swift
//  KaKaoChatInputView
//
//  Created by smg on 2017. 5. 13..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

protocol HasPlaceholder {
  var placeholderLabel: UILabel { get set }
}

class TextView: UITextView, HasPlaceholder {
  
  // MARK - Properties
  
  var heightDidChange: ((_ newHeight: CGFloat) -> Void)?

  lazy var placeholderLabel = UILabel().then {
    $0.clipsToBounds = false
    $0.numberOfLines = 1
    $0.font = self.font
    $0.backgroundColor = .clear
    $0.textColor = self.placeholderColor
    $0.isHidden = true
    $0.autoresizesSubviews = false
  }
  
  var expectedHeight: CGFloat = 0
  
  var maxNumberOfLines: CGFloat = 0
  
  var minimumHeight: CGFloat {
    return ceil(font!.lineHeight) +
      textContainerInset.top + textContainerInset.bottom
  }
  
  var placeholder: String = "" {
    didSet {
      placeholderLabel.text = placeholder
    }
  }
  
  var placeholderColor: UIColor = .gray {
    didSet {
      placeholderLabel.textColor = placeholderColor
    }
  }
  
  override var font: UIFont? {
    didSet { placeholderLabel.font = font }
  }
  
  override var contentSize: CGSize {
    didSet { updateSize() }
  }
  
  // MARK: - View Life Cycle
  
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    setupViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
  }
  
  func setupViews() {
    addSubview(placeholderLabel)
    isScrollEnabled = false
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    placeholderLabel.isHidden = isHiddenPlaceholder
    
    if !isHiddenPlaceholder {
      placeholderLabel.frame = placeholderRectThatFits(bounds)
      sendSubview(toBack: placeholderLabel)
    }
  }
  
  // MARK - Public Methods
  func textViewDidChange() {
    placeholderLabel.isHidden = isHiddenPlaceholder
    updateSize()
  }
  
  // MARK: - Helper Methods
  
  fileprivate var isHiddenPlaceholder:Bool {
    return placeholder.lengthOfBytes(using: .utf8) == 0
      || text.lengthOfBytes(using: .utf8) > 0
  }
  
  fileprivate func placeholderRectThatFits(_ rect: CGRect) -> CGRect {
    var placeholderRect = CGRect.zero
    placeholderRect.size = placeholderLabel.sizeThatFits(rect.size)
    
    placeholderRect.origin =
      UIEdgeInsetsInsetRect(rect, textContainerInset).origin
    
    let padding = textContainer.lineFragmentPadding
    placeholderRect.origin.x += padding
    return placeholderRect
  }
  
  fileprivate func ensureCaretDisplaysCorrectly() {
    if let s = selectedTextRange {
      let rect = caretRect(for: s.end)
      UIView.performWithoutAnimation { [weak self] in
        guard let `self` = self else { return }
        self.scrollRectToVisible(rect, animated: false)
      }
    }
  }
  
  fileprivate func updateSize() {
    var maxHeight = CGFloat.infinity
    
    if maxNumberOfLines > 0 {
      maxHeight = (ceil(font!.lineHeight) * maxNumberOfLines) +
        textContainerInset.top + textContainerInset.bottom
    }
    
    let roundedHeight = roundHeight
    if roundedHeight >= maxHeight {
      expectedHeight = maxHeight
      isScrollEnabled = true
    }
    else {
      expectedHeight = roundedHeight
      isScrollEnabled = false
    }
    
    if let heightDidChange = heightDidChange {
      heightDidChange(expectedHeight)
    }
    
    ensureCaretDisplaysCorrectly()
  }
  
  fileprivate var roundHeight: CGFloat {
    var newHeight = CGFloat(0)
    if let font = font {
      let attributes = [NSFontAttributeName: font]
      let boundingSize =
        CGSize(width: frame.size.width, height: CGFloat.infinity)
      
      let size =
        (text as NSString).boundingRect(
          with: boundingSize,
          options: NSStringDrawingOptions.usesLineFragmentOrigin,
          attributes: attributes, context: nil)
      newHeight = ceil(size.height)
    }
    return newHeight + textContainerInset.top + textContainerInset.bottom
  }
}


