//
//  FacebookPhotoCollectionsLayout.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

class FacebookPhotoCollectionsLayout: UICollectionViewFlowLayout {
  override init() {
    super.init()
    setupLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init()
    setupLayout()
  }
  
  func setupLayout() {
    minimumInteritemSpacing = 0
    minimumLineSpacing = 0
    scrollDirection = .vertical
  }
  
  override func prepare() {
    super.prepare()
    guard let collectionView = collectionView else { return }
    itemSize = CGSize(width: collectionView.frame.width, height: 80)
  }
}
