//
//  Base+View+VC.swift
//  KaKaoChatInputView
//
//  Created by smg on 2017. 5. 13..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

public class BaseView: UIView {
  
  // MARK: - View Life Cycle
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupConstraints()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
    setupConstraints()
  }
  
  // MARK: - Public Methods
  
  public func setupViews() { }
  public func setupConstraints() { }
}



public class BaseCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Properties
  
  class var cellIdentifier: String { return "\(self)" }
  
  // MARK: - View Life Cycle
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupConstraints()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
    setupConstraints()
  }
  
  // MARK: - Public Methods
  
  public func setupViews() { }
  public func setupConstraints() { }
}


public class BaseTableViewCell: UITableViewCell {
  
  // MARK: - Properties
  
  public class var cellIdentifier: String { return "\(self)" }
  
  // MARK: - View Life Cycle
  
  override public init(
    style: UITableViewCellStyle,
    reuseIdentifier: String?) {
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    setupConstraints()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupViews()
    setupConstraints()
  }
  
  // MARK: - Public Methods
  
  public func setupViews() { }
  public func setupConstraints() { }
}

public class BaseVC: UIViewController {
  
  // MARK: - View Life Cycle
  override public func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
  }
  
  // MARK: - Public Methods
  
  public func setupViews() { }
  public func setupConstraints() { }
}





