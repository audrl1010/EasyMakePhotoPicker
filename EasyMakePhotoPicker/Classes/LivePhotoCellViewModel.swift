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

public class LivePhotoCellViewModel: PhotoCellViewModel {
  
  // MARK: - Output
  public var livePhoto: PHLivePhoto? {
    return photoAsset.livePhoto
  }
  
  public var playEvent = PublishSubject<PlayEvent>()
  
  public var badgeImage: UIImage {
    return PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
  }
}




