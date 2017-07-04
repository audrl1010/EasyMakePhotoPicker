//
//  PhotosViewConfigure.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 25..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import Photos

open class PhotosViewConfigure {
  open var fetchOptions = PHFetchOptions()

  open var allowsMultipleSelection: Bool = true
  
  open var allowsCameraSelection: Bool = true
  
  open var allowsPlayTypes: [AssetType] = [
    .video, .livePhoto
  ]
  
  open var messageWhenMaxCountSelectedPhotosIsExceeded: String = "max count that can select photos is exceeded !!!!"
  
  open var maxCountSelectedPhotos: Int = 30

  // get item image from PHCachingImageManager
  // based on the UICollectionViewFlowLayout`s itemSize,
  // therefore must set well itemSize in UICollectionViewFlowLayout.
  open var layout: UICollectionViewFlowLayout = PhotosLayout()
  
  open var cameraCellClass: CameraCell.Type = CameraCell.self
  
  open var photoCellClass: PhotoCell.Type = PhotoCell.self
  
  open var livePhotoCellClass: LivePhotoCell.Type = LivePhotoCell.self
  
  open var videoCellClass: VideoCell.Type = VideoCell.self
  
  public init() {}
}










