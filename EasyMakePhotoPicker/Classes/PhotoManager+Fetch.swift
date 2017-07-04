//
//  PhotoManager+Fetch.swift
//  ObservableTest
//
//  Created by myung gi son on 2017. 6. 6..
//  Copyright © 2017년 grutech. All rights reserved.
//

import RxSwift
import Photos

// MARK: - Event
public enum LivePhotoDownloadEvent {
  case progress(progress: Double, info: [AnyHashable: Any]?)
  case complete(livePhoto: PHLivePhoto, info: [AnyHashable: Any]?)
}

public enum VideoDownloadEvent {
  case progress(progress: Double, info: [AnyHashable: Any]?)
  case complete(playerItem: AVPlayerItem, info: [AnyHashable: Any]?)
}

public enum CloudPhotoDownLoadEvent {
  case progress(progress: Double, info: [AnyHashable: Any]?)
  case complete(image: UIImage, info: [AnyHashable: Any]?)
}

// MARK: - Fetch

extension PhotoManager {
  
  /// get photoAssetCollections
  open func fetchCollections(
    assetCollectionTypes: [PHAssetCollectionSubtype],
    thumbnailImageSize: CGSize,
    options: PHFetchOptions? = nil) -> Observable<[PhotoAssetCollection]> {

    let assetCollectionsObservable = Observable
      .from(assetCollectionTypes)
      .map { collectionType -> PHFetchResult<PHAssetCollection> in
        PHAssetCollection
          .fetchAssetCollections(
            with: collectionType.rawValue < PHAssetCollectionSubtype.smartAlbumGeneric.rawValue
              ? .album : .smartAlbum,
            subtype: collectionType,
            options: nil)
      }
      .filter { $0.firstObject != nil }
      .map { fetchCollectionsResult -> PHAssetCollection in
        fetchCollectionsResult.firstObject!
      }
      .map { collection -> PhotoAssetCollection in
        let fetchAssets = PHAsset.fetchAssets(in: collection, options: options)
        
        var reversedAssets: [PHAsset] = []
        fetchAssets.enumerateObjects({ (asset, index, stop) in
          reversedAssets.insert(asset, at: 0)
        })
        
        let reversedCollection = PHAssetCollection.transientAssetCollection(
          with: reversedAssets,
          title: collection.localizedTitle)
        
        let reversedFetchAssets = PHAsset.fetchAssets(in: reversedCollection, options: nil)
        
        return PhotoAssetCollection(
          collection: reversedCollection,
          fetchResult: reversedFetchAssets)
      }
      .filter { $0.count > 0 }
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
    
    let assetCollectionsThumbnailObservable =
      assetCollectionsObservable
        .flatMap { [weak self] assetCollection -> Observable<UIImage> in
          guard let `self` = self,
            let latestAsset = assetCollection.fetchResult.firstObject else {
              return .empty()
          }
          
          let options = PHImageRequestOptions()
          options.deliveryMode = .highQualityFormat
          options.isNetworkAccessAllowed = false
          options.isSynchronous = true
          return self.image(
            for: latestAsset,
            size: thumbnailImageSize,
            options: options)
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
    
    return Observable
      .zip(assetCollectionsObservable, assetCollectionsThumbnailObservable) { (assetCollection, thumbnail) -> PhotoAssetCollection in
        var assetCollection = assetCollection
        assetCollection.thumbnail = thumbnail
        return assetCollection
      }
      .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
      .toArray()
      .observeOn(MainScheduler.instance)
  }
  
  /// get image for asset.
  open func image(
    for asset: PHAsset,
    size: CGSize = CGSize(width: 720, height: 1280),
    options: PHImageRequestOptions? = nil) -> Observable<UIImage> {
    
    return Observable.create { [weak self] observer in
      guard let `self` = self else { return Disposables.create() }
      
      var options = options
      
      if options == nil {
        options = PHImageRequestOptions()
        options?.deliveryMode = .highQualityFormat
        options?.isNetworkAccessAllowed = false
      }
      
      _ = self.imageManager.requestImage(
        for: asset,
        targetSize: size,
        contentMode: .aspectFill,
        options: options) { image, info in
          if let image = image {
            observer.onNext(image)
          }
          else {
            observer.onError(NSError())
          }
          observer.onCompleted()
      }
      return Disposables.create()
    }
  }
  
  /// get livePhoto for asset.
  open func livePhoto(
    for asset: PHAsset,
    size: CGSize = CGSize(width: 720, height: 1280)) -> Observable<LivePhotoDownloadEvent> {
    
    return Observable.create { [weak self] observer in
      guard let `self` = self else { return Disposables.create() }
      
      let options = PHLivePhotoRequestOptions()
      options.deliveryMode = .highQualityFormat
      options.isNetworkAccessAllowed = true
      options.progressHandler = { progress, error, stop, info in
        if let error = error {
          observer.onError(error)
        }
        else {
          observer.onNext(.progress(progress: progress, info: info))
        }
      }
      
      _ = self.imageManager.requestLivePhoto(
        for: asset,
        targetSize: size,
        contentMode: .aspectFit,
        options: options) { livePhoto, info in
          if let livePhoto = livePhoto {
            observer.onNext(.complete(livePhoto: livePhoto, info: info))
          }
          observer.onCompleted()
      }
      return Disposables.create()
    }
  }
  
  
  /// get video for asset.
  open func video(
    for asset: PHAsset,
    size: CGSize = CGSize(width: 720, height: 1280)) -> Observable<VideoDownloadEvent> {
    
    return Observable.create { [weak self] observer in
      guard let `self` = self else { return Disposables.create() }
      
      let options = PHVideoRequestOptions()
      options.deliveryMode = .automatic
      options.isNetworkAccessAllowed = true
      options.progressHandler = { progress, error, stop, info in
        if let error = error {
          observer.onError(error)
        }
        else {
          observer.onNext(.progress(progress: progress, info: info))
        }
      }
      
      _ = self.imageManager.requestPlayerItem(
        forVideo: asset,
        options: options) { playerItem, info in
          if let playerItem = playerItem {
            observer.onNext(.complete(playerItem: playerItem, info: info))
          }
          else {
            observer.onError(NSError())
          }
          observer.onCompleted()
      }
      return Disposables.create()
    }
  }
  
  
  /// get cloud image for asset.
  open func cloudImage(
    for asset: PHAsset,
    size: CGSize = PHImageManagerMaximumSize) -> Observable<CloudPhotoDownLoadEvent> {
    return Observable.create { [weak self] observer in
      guard let `self` = self else { return Disposables.create() }
      let options = PHImageRequestOptions()
      options.isSynchronous = false
      options.isNetworkAccessAllowed = true
      options.deliveryMode = .opportunistic
      options.progressHandler = { progress, error, stop, info in
        if let error = error {
          observer.onError(error)
        }
        else {
          observer.onNext(.progress(progress: progress, info: info))
        }
      }
      _ = self.imageManager.requestImageData(
        for: asset,
        options: options) { imageData, dataUTI, orientation, info in
          if let data = imageData,
            let image = UIImage(data: data) {
            observer.onNext(.complete(image: image, info: info))
          }
          else {
            observer.onError(NSError())
          }
          observer.onCompleted()
      }
      return Disposables.create()
    }
  }
  
  /// get full resolution image.
  open func fullResolutionImage(
    for asset: PHAsset) -> Observable<UIImage> {
    return Observable.create { observer in
      let options = PHImageRequestOptions()
      options.isSynchronous = true
      options.resizeMode = .none
      options.isNetworkAccessAllowed = false
      options.version = .current
      _ = PHCachingImageManager().requestImageData(
        for: asset,
        options: options) { imageData, dataUTI, orientation, info in
          if let data = imageData {
            if let image = UIImage(data: data) {
              observer.onNext(image)
              observer.onCompleted()
            }
            else {
              observer.onError(NSError())
            }
          }
      }
      return Disposables.create()
    }
  }
}










