//
//  KaKaoPhotosViewConfigure.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 5..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//


import Photos
import EasyMakePhotoPicker


struct KaKaoPhotosViewConfigure: PhotosViewConfigure {
  var fetchOptions: PHFetchOptions = PHFetchOptions()
  
  var allowsMultipleSelection: Bool = true
  
  var allowsCameraSelection: Bool = true
  
  // .video, .livePhoto
  var allowsPlayTypes: [AssetType] = [.video, .livePhoto]
  
  var messageWhenMaxCountSelectedPhotosIsExceeded: String = "over!!!"
  
  var maxCountSelectedPhotos: Int = 15

  var layout: UICollectionViewFlowLayout = KaKaoPhotosLayout()

  var cameraCellTypeConverter = CameraCellTypeConverter(type: KaKaoCameraCell.self)
  
  var photoCellTypeConverter = PhotoCellTypeConverter(type: KaKaoPhotoCell.self)
  
  var livePhotoCellTypeConverter = LivePhotoCellTypeConverter(type: KaKaoLivePhotoCell.self)
  
  var videoCellTypeConverter = VideoCellTypeConverter(type: KaKaoVideoCell.self)
}











