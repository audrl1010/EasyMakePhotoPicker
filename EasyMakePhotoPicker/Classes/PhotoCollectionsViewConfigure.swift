//
//  PhotoCollectionsViewConfigure.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import Foundation
import Photos

public protocol PhotoCollectionsViewConfigure {
  
  var fetchOptions: PHFetchOptions { get }

  // to show collection types.
  var showsCollectionTypes: [PHAssetCollectionSubtype] { get }
  
  // If you create a custom PhotoCollectionCell, size of thumbnailImageView in PhotoCollectionCell and
  // photoCollectionThumbnailSize must be the same
  // because get photo collection thumbnail image from PHCachingImageManager
  // based on the 'photoCollectionThumbnailSize'
  var photoCollectionThumbnailSize: CGSize { get }
  
  var layout: UICollectionViewFlowLayout { get }
  
  var photoCollectionCellTypeConverter: PhotoCollectionCellTypeConverter { get }
}

public struct PhotoCollectionCellTypeConverter: CellTypeConverter {
  public typealias Cellable = PhotoCollectionCellable
  public var cellIdentifier: String
  public var cellClass: AnyClass
  
  public init<C: UICollectionViewCell>(type: C.Type) where C: Cellable {
    cellIdentifier = NSStringFromClass(type)
    cellClass = type
  }
}

public protocol PhotoCollectionCellable {
  var viewModel: PhotoCollectionCellViewModel? { get set }
}




