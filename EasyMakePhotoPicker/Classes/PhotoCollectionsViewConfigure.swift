//
//  PhotoCollectionsViewConfigure.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import Foundation
import Photos

open class PhotoCollectionsViewConfigure {
  
  open var fetchOptions = PHFetchOptions()

  // to show collection types.
  open var showsCollectionTypes: [PHAssetCollectionSubtype] = [
    .smartAlbumUserLibrary,
    .smartAlbumGeneric,
    .smartAlbumFavorites,
    .smartAlbumRecentlyAdded,
    .smartAlbumSelfPortraits,
    .smartAlbumVideos,
    .smartAlbumPanoramas,
    .smartAlbumBursts,
    .smartAlbumScreenshots
  ]
  
  // If you create a custom PhotoCollectionCell, size of thumbnailImageView in PhotoCollectionCell and
  // photoCollectionThumbnailSize must be the same
  // because get photo collection thumbnail image from PHCachingImageManager
  // based on the 'photoCollectionThumbnailSize'
  open var photoCollectionThumbnailSize = CGSize(width: 54, height: 54)
  
  open var layout: UICollectionViewFlowLayout = PhotoCollectionsLayout()
  
  open var photoCollectionCellClass: PhotoCollectionCell.Type = PhotoCollectionCell.self
  
  public init() { }
}





