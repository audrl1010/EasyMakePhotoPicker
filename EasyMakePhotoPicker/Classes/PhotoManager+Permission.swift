//
//  PhotoManager+Permission.swift
//  ObservableTest
//
//  Created by myung gi son on 2017. 6. 6..
//  Copyright © 2017년 grutech. All rights reserved.
//

import Photos
import RxSwift

// MARK: - Permission

extension PhotoManager {
  
  public func checkPhotoPermission() -> Observable<Bool> {
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
    .subscribeOn(MainScheduler.instance)
  }
}


