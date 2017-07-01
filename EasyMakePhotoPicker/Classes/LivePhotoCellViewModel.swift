//
//  LivePhotoCellViewModel.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 29..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import PhotosUI
import RxSwift

open class LivePhotoCellViewModel: PhotoCellViewModel {
  
  // MARK: - Output
  open var livePhoto: PHLivePhoto? {
    return photoAsset.livePhoto
  }
  
  open var playEvent = PublishSubject<PlayEvent>()
  
  open var badgeImage: UIImage {
    return PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
  }
}




