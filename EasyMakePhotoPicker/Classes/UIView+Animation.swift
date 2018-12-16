//
//  UIView+Animation.swift
//  UIViewAnimationSyntaxSugar
//
//  Created by myung gi son on 2017. 5. 17..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

// MARK: - Animatoir (Basic)

extension UIView {
  
  public class Animator {
    public typealias AnimationsBlock = () -> Void
    public typealias CompletionBlock = (Bool) -> Void
    public typealias BlockBeforeExcutingAnimations = () -> Void
    
    fileprivate var _beforeAnimations: BlockBeforeExcutingAnimations
    fileprivate var _animations: AnimationsBlock
    fileprivate var _completion: CompletionBlock?
    fileprivate var _duration: TimeInterval
    fileprivate var _delay: TimeInterval
    fileprivate var _options: UIView.AnimationOptions
    
    public init(
      duration: TimeInterval,
      delay: TimeInterval = 0.0,
      options: UIView.AnimationOptions = []) {
      
      _duration = duration
      _delay = delay
      _options = options
      _beforeAnimations = {}
      _animations = {}
      _completion = nil
    }
    
    public func delay(_ delay: TimeInterval) -> Self {
      _delay = delay
      return self
    }
    
    public func options(_ options: UIView.AnimationOptions) -> Self {
      _options = options
      return self
    }
    
    public func beforeAnimations(_ beforeAnimations: @escaping BlockBeforeExcutingAnimations) -> Self {
      _beforeAnimations = beforeAnimations
      return self
    }
    
    public func animations(_ animations: @escaping AnimationsBlock) -> Self {
      _animations = animations
      return self
    }
    
    public func completion(_ completion: @escaping CompletionBlock) -> Self {
      _completion = completion
      return self
    }

    public func animate() {
      _beforeAnimations()
      UIView.animate(
        withDuration: _duration,
        delay: _delay,
        options: _options,
        animations: _animations,
        completion: _completion)
    }
  }
}


// MARK: - SpringAnimator

extension UIView {
  
  public class SpringAnimator: Animator {
    fileprivate var _damping: CGFloat
    fileprivate var _velocity: CGFloat
    
    public init(
      duration: TimeInterval,
      delay: TimeInterval = 0.0,
      damping: CGFloat = 0.1,
      velocity: CGFloat = 0.1,
      options: UIView.AnimationOptions = []) {
      
      _damping = damping
      _velocity = velocity
      
      super.init(duration: duration, delay: delay, options: options)
    }
    
    public func damping(_ damping: CGFloat) -> Self {
      _damping = damping
      return self
    }
    
    public func velocity(_ velocity: CGFloat) -> Self {
      _velocity = velocity
      return self
    }
    
    override public func animate() {
      _beforeAnimations()
      UIView.animate(
        withDuration: _duration,
        delay: _delay,
        usingSpringWithDamping: _damping,
        initialSpringVelocity: _velocity,
        options: _options,
        animations: _animations,
        completion: _completion)
    }
  }
}



