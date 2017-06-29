//
//  PhotoAsset.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 30..
//  Copyright © 2017년 grutech. All rights reserved.
//

import Foundation
import Photos
import RxSwift

public enum AssetType {
  case camera
  case photo
  case video
  case livePhoto
}

public struct PhotoAsset: Equatable {
  
  public var localIdentifier: String {
    return asset.localIdentifier
  }

  public var asset: PHAsset
  
  public var isSelected: Bool = false
  
  public var selectedOrder: Int = 0
  
  public var playerItem: AVPlayerItem?
  
  public var livePhoto: PHLivePhoto?
  
  public var type: AssetType {
    if asset.mediaSubtypes.contains(.photoLive) {
      return .livePhoto
    }
    else if asset.mediaType == .video {
      return .video
    }
    else if asset.mediaType == .image {
      return .photo
    }
    else {
      return .camera
    }
  }
  
  public var disposeBag = DisposeBag()
  
  public var fullResolutionImage: UIImage {
    var fullImage = UIImage()
    PhotoManager.shared.fullResolutionImage(for: self.asset)
      .subscribeOn(MainScheduler.instance)
      .subscribe(onNext: { image in
        fullImage = image
      })
      .disposed(by: disposeBag)
    return fullImage
  }
  
  public var originalFileName: String? {
    if let resource = PHAssetResource.assetResources(for: asset).first {
        return resource.originalFilename
    }
    return nil
  }
  
  public init(asset: PHAsset) {
    self.asset = asset
  }
  
  public static func == (
    lhs: PhotoAsset,
    rhs: PhotoAsset) -> Bool {
    return lhs.asset.localIdentifier ==
      rhs.asset.localIdentifier
  }
}






