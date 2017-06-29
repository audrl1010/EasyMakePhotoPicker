//
//  PhotoCollectionsViewConfigure.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import Foundation
import Photos

public class PhotoCollectionsViewConfigure {
  
  public var fetchOptions = PHFetchOptions().then {
    $0.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
  }
  
  // to show collection types.
  public var showsCollectionTypes: [PHAssetCollectionSubtype] = [
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
  public var photoCollectionThumbnailSize = CGSize(
    width: 54 * UIScreen.main.scale,
    height: 54 * UIScreen.main.scale)
  
  public var layout: UICollectionViewFlowLayout = PhotoCollectionsLayout()
  
  public var photoCollectionCellClass: PhotoCollectionCell.Type = PhotoCollectionCell.self
}





