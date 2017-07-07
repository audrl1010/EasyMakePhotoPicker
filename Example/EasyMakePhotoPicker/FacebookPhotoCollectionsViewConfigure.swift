//
//  FacebookPhotoCollectionsViewConfigure.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 7..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import Photos
import EasyMakePhotoPicker

struct FacebookPhotoCollectionsViewConfigure: PhotoCollectionsViewConfigure {
  var fetchOptions = PHFetchOptions()
  
  // to show collection types.
  var showsCollectionTypes: [PHAssetCollectionSubtype] = [
    .smartAlbumUserLibrary,
    .smartAlbumGeneric,
    .smartAlbumFavorites,
    .smartAlbumRecentlyAdded,
    .smartAlbumVideos,
    .smartAlbumPanoramas,
    .smartAlbumBursts,
    .smartAlbumScreenshots
  ]
  
  var photoCollectionThumbnailSize = CGSize(width: 54, height: 54)
  
  var layout: UICollectionViewFlowLayout = FacebookPhotoCollectionsLayout()
  
  var photoCollectionCellTypeConverter =
    PhotoCollectionCellTypeConverter(type: FacebookPhotoCollectionCell.self)
}

