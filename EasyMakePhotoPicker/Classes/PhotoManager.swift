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

public class PhotoManager: NSObject {
  // MARK: - Properties
  
  public class var shared: PhotoManager {
    struct Singleton {
      static var sharedInstance = PhotoManager()
    }
    return Singleton.sharedInstance
  }
  
  public var photoLibraryChangeEvent =
    PublishSubject<PHChange>()

  public var imageManager: PHCachingImageManager = PHCachingImageManager()
  
  public var disposeBag: DisposeBag = DisposeBag()
  
  // MARK: - Life Cycle
  
  deinit {
    PHPhotoLibrary.shared().unregisterChangeObserver(self)
  }
  
  override public init() {
    super.init()
    PHPhotoLibrary.shared().register(self)
  }
}










