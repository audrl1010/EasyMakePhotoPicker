//
//  FacebookPhotosLayout.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit


class FacebookPhotosLayout: UICollectionViewFlowLayout {
  
  fileprivate struct Constant {
    static let padding = CGFloat(5)
    static let numberOfColumns = CGFloat(3)
  }
  
  override func prepare() {
    super.prepare()
    
    // set up itemSize
    guard let collectionView = collectionView else { return }
    let collectionViewWidth = (collectionView.bounds.width)
    
    let columnWidth = (collectionViewWidth -
      Constant.padding * (Constant.numberOfColumns - 1)) / Constant.numberOfColumns
    
    minimumLineSpacing = Constant.padding
    minimumInteritemSpacing = Constant.padding
    
    itemSize = CGSize(width: columnWidth, height: columnWidth)
  }
}
