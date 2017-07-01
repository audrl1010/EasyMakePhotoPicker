//
//  PhotoManager+Change.swift
//  ObservableTest
//
//  Created by myung gi son on 2017. 6. 6..
//  Copyright © 2017년 grutech. All rights reserved.
//

import Photos
import RxSwift

// MARK: - Change

extension PhotoManager: PHPhotoLibraryChangeObserver {
  open func photoLibraryDidChange(_ changeInstance: PHChange) {
    photoLibraryChangeEvent.onNext(changeInstance)
  }
}

public enum PerformChangesEvent {
  case completion(success: Bool)
}

extension PhotoManager {
  open func performChanges(changeBlock: @escaping () -> Void) -> Observable<PerformChangesEvent> {
    return Observable.create { observer in
      PHPhotoLibrary.shared().performChanges({
        changeBlock()
      }, completionHandler: { success, error in
        if let error = error {
          observer.onError(error)
          return
        }
        observer.onNext(.completion(success: success))
        observer.onCompleted()
      })
      return Disposables.create()
    }
  }

}






