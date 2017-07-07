//
//  FacebookPhotosViewConfigure.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 7..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import EasyMakePhotoPicker
import Photos

class FacebookPhotosViewConfigure: PhotosViewConfigure {
  var fetchOptions: PHFetchOptions = PHFetchOptions()
  
  var allowsMultipleSelection: Bool = true
  
  var allowsCameraSelection: Bool = true
  
  // .video, .livePhoto
  var allowsPlayTypes: [AssetType] = [.video, .livePhoto]
  
  var messageWhenMaxCountSelectedPhotosIsExceeded: String = "over!!!"
  
  var maxCountSelectedPhotos: Int = 15
  
  var layout: UICollectionViewFlowLayout = FacebookPhotosLayout()
  
  var cameraCellTypeConverter = CameraCellTypeConverter(type: FacebookCameraCell.self)
  
  var photoCellTypeConverter = PhotoCellTypeConverter(type: FacebookPhotoCell.self)
  
  var livePhotoCellTypeConverter = LivePhotoCellTypeConverter(type: FacebookLivePhotoCell.self)
  
  var videoCellTypeConverter = VideoCellTypeConverter(type: FacebookVideoCell.self)
}
