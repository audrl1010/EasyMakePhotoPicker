//
//  PhotoManager+Cache.swift
//  ObservableTest
//
//  Created by myung gi son on 2017. 6. 6..
//  Copyright © 2017년 grutech. All rights reserved.
//

import Photos

// MARK: - Cache

extension PhotoManager {
  
  open func startCaching(
    assets: [PHAsset],
    targetSize: CGSize,
    contentMode: PHImageContentMode,
    options: PHImageRequestOptions?) {
    
    imageManager.startCachingImages(
      for: assets,
      targetSize: targetSize,
      contentMode: contentMode,
      options: options)
  }
  
  open func stopCaching(
    assets: [PHAsset],
    targetSize: CGSize,
    contentMode: PHImageContentMode,
    options: PHImageRequestOptions?){
    
    imageManager.stopCachingImages(
      for: assets,
      targetSize: targetSize,
      contentMode: contentMode,
      options: options)
  }
  
  open func stopCachingForAllAssets() {
    imageManager.stopCachingImagesForAllAssets()
  }
  
  // cancel image request for requestID.
  open func cancel(imageRequest requestID: PHImageRequestID) {
    imageManager.cancelImageRequest(requestID)
  }
}







