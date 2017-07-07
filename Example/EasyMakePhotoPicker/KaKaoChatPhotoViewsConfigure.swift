//
//  KaKaoChatPhotoViewsConfigure.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 7..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import Photos
import EasyMakePhotoPicker

struct KaKaoChatPhotosViewConfigure: PhotosViewConfigure {
  var fetchOptions: PHFetchOptions = PHFetchOptions()
  
  var allowsMultipleSelection: Bool = true
  
  var allowsCameraSelection: Bool = false
  
  // .video, .livePhoto
  var allowsPlayTypes: [AssetType] = []
  
  var messageWhenMaxCountSelectedPhotosIsExceeded: String = "over!!!"
  
  var maxCountSelectedPhotos: Int = 10
  
  var layout: UICollectionViewFlowLayout = KaKaoChatPhotosLayout()
  
  var cameraCellTypeConverter = CameraCellTypeConverter(type: KaKaoCameraCell.self)
  
  var photoCellTypeConverter = PhotoCellTypeConverter(type: KaKaoPhotoCell.self)
  
  var livePhotoCellTypeConverter = LivePhotoCellTypeConverter(type: KaKaoLivePhotoCell.self)
  
  var videoCellTypeConverter = VideoCellTypeConverter(type: KaKaoVideoCell.self)
}
