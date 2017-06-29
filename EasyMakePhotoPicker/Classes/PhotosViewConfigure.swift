//
//  PhotosViewConfigure.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 25..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import Photos

public class PhotosViewConfigure {
  public var fetchOptions = PHFetchOptions().then {
    $0.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
  }
  
  public var allowsMultipleSelection: Bool = true
  
  public var allowsCameraSelection: Bool = true
  
  public var allowsPlayTypes: [AssetType] = [
    .video, .livePhoto
  ]
  
  public var messageWhenMaxCountSelectedPhotosIsExceeded: String = "max count that can select photos is exceeded !!!!"
  
  public var maxCountSelectedPhotos: Int = 30

  // get item image from PHCachingImageManager
  // based on the UICollectionViewFlowLayout`s itemSize,
  // therefore must set well itemSize in UICollectionViewFlowLayout.
  public var layout: UICollectionViewFlowLayout = PhotosLayout()
  
  public var cameraCellClass: CameraCell.Type = CameraCell.self
  
  public var photoCellClass: PhotoCell.Type = PhotoCell.self
  
  public var livePhotoCellClass: LivePhotoCell.Type = LivePhotoCell.self
  
  public var videoCellClass: VideoCell.Type = VideoCell.self
}










