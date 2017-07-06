//
//  PlayerView.swift
//  Pods
//
//  Created by myung gi son on 2017. 7. 5..
//
//

import UIKit
import AVFoundation

class PlayerView: UIView {
  
  var player: AVPlayer? {
    get { return playerLayer.player }
    set { playerLayer.player = newValue }
  }
  
  var playerLayer: AVPlayerLayer {
    return layer as! AVPlayerLayer
  }
  
  override static var layerClass: AnyClass {
    return AVPlayerLayer.self
  }
}
