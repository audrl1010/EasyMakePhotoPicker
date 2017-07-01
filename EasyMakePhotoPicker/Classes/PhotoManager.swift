//
//  AssetManager.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 5. 21..
//  Copyright © 2017년 grutech. All rights reserved.
//

import Photos
import RxSwift

// MARK: - PhotoManager

open class PhotoManager: NSObject {
  // MARK: - Properties
  
  open class var shared: PhotoManager {
    struct Singleton {
      static var sharedInstance = PhotoManager()
    }
    return Singleton.sharedInstance
  }
  
  open var photoLibraryChangeEvent =
    PublishSubject<PHChange>()

  open var imageManager: PHCachingImageManager = PHCachingImageManager()
  
  open var disposeBag: DisposeBag = DisposeBag()
  
  // MARK: - Life Cycle
  
  deinit {
    PHPhotoLibrary.shared().unregisterChangeObserver(self)
  }
  
  override public init() {
    super.init()
    PHPhotoLibrary.shared().register(self)
  }
}










