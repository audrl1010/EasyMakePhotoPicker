//
//  PhotoManager+Permission.swift
//  ObservableTest
//
//  Created by myung gi son on 2017. 6. 6..
//  Copyright © 2017년 grutech. All rights reserved.
//

import AVFoundation
import Photos
import RxSwift


// MARK: - Permission

extension PhotoManager {
  
  open func checkPhotoLibraryPermission() -> Observable<Bool> {
    return Observable.create { observer in
      if PHPhotoLibrary.authorizationStatus() == .authorized {
        observer.onNext(true)
        observer.onCompleted()
      }
      else {
        observer.onNext(false)
        PHPhotoLibrary.requestAuthorization { newStatus in
          observer.onNext(newStatus == .authorized)
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
  
  open func checkCameraPermission() -> Observable<Bool> {
    return Observable.create { observer in
      let authStatus =
        AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
      
      if authStatus == .authorized {
        observer.onNext(true)
        observer.onCompleted()
      }
      else {
        observer.onNext(false)
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
          observer.onNext(granted)
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
}















