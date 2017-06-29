//
//  VideoCellViewModel.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 29..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import Photos
import RxSwift

public class VideoCellViewModel: PhotoCellViewModel {

  public var playerItem: AVPlayerItem? {
    return photoAsset.playerItem
  }
  
  public var playEvent = PublishSubject<PlayEvent>()
  
  public var duration: TimeInterval {
    return self.photoAsset.asset.duration
  }
}








