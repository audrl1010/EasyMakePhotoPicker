//
//  PhotoCollectionsLayout.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

open class PhotoCollectionsLayout: UICollectionViewFlowLayout {

  open override var itemSize: CGSize {
    set { }
    
    get {
      guard let collectionView = collectionView else { return .zero }
      return CGSize(width: collectionView.frame.width, height: 120)
    }
  }
  
  override public init() {
    super.init()
    setupLayout()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init()
    setupLayout()
  }
  
  open func setupLayout() {
    minimumInteritemSpacing = 0
    minimumLineSpacing = 0
    scrollDirection = .vertical
  }
}
