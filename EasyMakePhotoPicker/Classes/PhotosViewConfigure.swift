//
//  PhotosViewConfigure.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 25..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import UIKit

public protocol PhotosViewConfigure {

  var fetchOptions: PHFetchOptions { get }
  
  var allowsMultipleSelection: Bool { get }
  
  var allowsCameraSelection: Bool { get }
  
  // .video, .livePhoto
  var allowsPlayTypes: [AssetType] { get }
  
  var messageWhenMaxCountSelectedPhotosIsExceeded: String { get }
  
  var maxCountSelectedPhotos: Int { get }
  
  // get item image from PHCachingImageManager
  // based on the UICollectionViewFlowLayout`s itemSize,
  // therefore must set well itemSize in UICollectionViewFlowLayout.
  var layout: UICollectionViewFlowLayout { get }
  
  var photoCellTypeConverter: PhotoCellTypeConverter { get }
  
  var livePhotoCellTypeConverter: LivePhotoCellTypeConverter { get }
  
  var videoCellTypeConverter: VideoCellTypeConverter { get }
  
  var cameraCellTypeConverter: CameraCellTypeConverter { get }
}

public protocol CellTypeConverter {
  associatedtype Cellable
  
  var cellIdentifier: String { get }
  var cellClass: AnyClass { get }
}

public struct PhotoCellTypeConverter: CellTypeConverter {
  public typealias Cellable = PhotoCellable
  public var cellIdentifier: String
  public var cellClass: AnyClass
  
  public init<C: UICollectionViewCell>(type: C.Type) where C: Cellable {
    cellIdentifier = NSStringFromClass(type)
    cellClass = type
  }
}

public struct LivePhotoCellTypeConverter: CellTypeConverter {
  public typealias Cellable = LivePhotoCellable
  public var cellIdentifier: String
  public var cellClass: AnyClass
  
  public init<C: UICollectionViewCell>(type: C.Type) where C: Cellable {
    cellIdentifier = NSStringFromClass(type)
    cellClass = type
  }
}

public struct VideoCellTypeConverter: CellTypeConverter {
  public typealias Cellable = VideoCellable
  public var cellIdentifier: String
  public var cellClass: AnyClass
  
  public init<C: UICollectionViewCell>(type: C.Type) where C: Cellable {
    cellIdentifier = NSStringFromClass(type)
    cellClass = type
  }
}

public struct CameraCellTypeConverter: CellTypeConverter {
  public typealias Cellable = CameraCellable
  public var cellIdentifier: String
  public var cellClass: AnyClass
  
  public init<C: UICollectionViewCell>(type: C.Type) where C: Cellable {
    cellIdentifier = NSStringFromClass(type)
    cellClass = type
  }
}

public protocol CameraCellable: class { }

public protocol PhotoCellable: class {
  var viewModel: PhotoCellViewModel? { get set }
}

public protocol LivePhotoCellable: PhotoCellable { }

public protocol VideoCellable: PhotoCellable { }















