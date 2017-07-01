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
  
  open var fetchOptions = PHFetchOptions().then {
    $0.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
  }
  
  // to show collection types.
  open var showsCollectionTypes: [PHAssetCollectionSubtype] = [
    .smartAlbumUserLibrary,
    .smartAlbumGeneric,
    .smartAlbumFavorites,
    .smartAlbumRecentlyAdded,
    .smartAlbumSelfPortraits,
    .smartAlbumPanoramas,
    .smartAlbumBursts,
    .smartAlbumScreenshots
  ]
  
  // If you create a custom PhotoCollectionCell, size of thumbnailImageView in PhotoCollectionCell and
  // photoCollectionThumbnailSize must be the same
  // because get photo collection thumbnail image from PHCachingImageManager
  // based on the 'photoCollectionThumbnailSize'
  
  // * recommand: To provide image according to device resolution,
  //              must multiply thumbnailSize to UIScreen.main.scale
  open var photoCollectionThumbnailSize = CGSize(
    width: 54 * UIScreen.main.scale,
    height: 54 * UIScreen.main.scale)
  
  open var layout: UICollectionViewFlowLayout = PhotoCollectionsLayout()
  
  open var photoCollectionCellClass: PhotoCollectionCell.Type = PhotoCollectionCell.self
  
  public init() { }
}





