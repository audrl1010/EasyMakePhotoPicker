//
//  Base+View+VC.swift
//  KaKaoChatInputView
//
//  Created by smg on 2017. 5. 13..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

open class BaseView: UIView {
  
  // MARK: - View Life Cycle
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    addSubviews()
    setupConstraints()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
    addSubviews()
    setupConstraints()
  }
  
  // MARK: - Public Methods
  
  open func setupViews() { }
  open func addSubviews() { }
  open func setupConstraints() { }
}



open class BaseCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Properties
  
  open class var cellIdentifier: String { return "\(self)" }
  
  // MARK: - View Life Cycle
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    addSubviews()
    setupConstraints()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
    addSubviews()
    setupConstraints()
  }
  
  // MARK: - Public Methods
  
  open func setupViews() { }
  open func addSubviews() { }
  open func setupConstraints() { }
}


open class BaseTableViewCell: UITableViewCell {
  
  // MARK: - Properties
  
  open class var cellIdentifier: String { return "\(self)" }
  
  // MARK: - View Life Cycle
  
  override public init(
    style: UITableViewCellStyle,
    reuseIdentifier: String?) {
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    addSubviews()
    setupConstraints()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
    addSubviews()
    setupConstraints()
  }
  
  // MARK: - Public Methods
  
  open func setupViews() { }
  open func addSubviews() { }
  open func setupConstraints() { }
}

open class BaseVC: UIViewController {
  
  // MARK: - View Life Cycle
  override open func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    addSubviews()
    setupConstraints()
  }
  
  // MARK: - Public Methods
  open func setupViews() { }
  open func addSubviews() { }
  open func setupConstraints() { }
}





