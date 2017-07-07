//
//  KaKaoChatPhotosLayout.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 3..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit

class KaKaoChatPhotosLayout: UICollectionViewFlowLayout {
  
  struct Constant {
    static let itemWidth = CGFloat(160)
    static let minimumLineSpacing = CGFloat(2)
  }
  
  override public init() {
    super.init()
    setupLayout()
  }
  
  open override var itemSize: CGSize {
    set { }
    
    get {
      guard let collectionView = collectionView else { return .zero }
      return CGSize(width: Constant.itemWidth, height: collectionView.bounds.height)
    }
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init()
    setupLayout()
  }
  
  func setupLayout() {
    scrollDirection = .horizontal
    minimumLineSpacing = Constant.minimumLineSpacing
  }
}
