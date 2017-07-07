//
//  FacebookPhotosLayout.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 7..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit

class FacebookPhotosLayout: UICollectionViewFlowLayout {
  
  // MARK: - Constant
  
  fileprivate struct Constant {
    static let padding = CGFloat(5)
    static let numberOfColumns = CGFloat(3)
  }
  
  override var itemSize: CGSize {
    set { }
    
    get {
      guard let collectionView = collectionView else { return .zero }
      let collectionViewWidth = (collectionView.bounds.width)
      
      let columnWidth = (collectionViewWidth -
        Constant.padding * (Constant.numberOfColumns - 1)) / Constant.numberOfColumns
      return CGSize(width: columnWidth, height: columnWidth)
    }
  }
  
  override init() {
    super.init()
    setupLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init()
    setupLayout()
  }
  
  func setupLayout() {
    minimumLineSpacing = Constant.padding
    minimumInteritemSpacing = Constant.padding
  }
}




