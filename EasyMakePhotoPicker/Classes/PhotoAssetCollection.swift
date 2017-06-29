//
//  PhotoAssetCollection.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 30..
//  Copyright © 2017년 grutech. All rights reserved.
//

import Foundation
import Photos

public struct PhotoAssetCollection: Equatable {
  
  public var localIdentifier: String {
    return assetCollection.localIdentifier
  }
  
  public var assetCollection: PHAssetCollection
  
  public var fetchResult: PHFetchResult<PHAsset>
  
  public var thumbnail: UIImage?
  
  public var title: String {
    return assetCollection.localizedTitle ?? ""
  }
  
  public var count: Int {
    return fetchResult.count
  }
  
  public var assetsInFetchResult: [PHAsset] {
    var assets: [PHAsset] = []
    fetchResult.enumerateObjects({ asset, index, stop in
      assets.append(asset)
    })
    return assets
  }

  public init(collection: PHAssetCollection,
       fetchResult: PHFetchResult<PHAsset>) {
    self.assetCollection = collection
    self.fetchResult = fetchResult
  }
  
  public static func == (
    lhs: PhotoAssetCollection,
    rhs: PhotoAssetCollection) -> Bool {
    return lhs.assetCollection.localIdentifier ==
      rhs.assetCollection.localIdentifier
  }
}


