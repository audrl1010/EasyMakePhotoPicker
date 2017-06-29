//
//  CameraCellViewModel.swift
//  PhotoTest
//
//  Created by myung gi son on 2017. 6. 19..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import Photos
import RxSwift

public class CameraCellViewModel: PhotoCellViewModel {
  override public init(photoAsset: PhotoAsset, configure: PhotosViewConfigure) {
    super.init(photoAsset: photoAsset, configure: configure)
    isSelect.onCompleted()
    selectedOrder.onCompleted()
  }
}
