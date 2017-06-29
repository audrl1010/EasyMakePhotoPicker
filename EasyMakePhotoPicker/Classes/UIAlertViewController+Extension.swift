//
//  UIAlertViewController+Extension.swift
//  KaKaoChatInputView
//
//  Created by myung gi son on 2017. 5. 27..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit

extension UIAlertController {
  class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
      return topViewController(nav.visibleViewController)
    }
    
    if let tab = base as? UITabBarController {
      if let selected = tab.selectedViewController {
        return topViewController(selected)
      }
    }
    
    if let presented = base?.presentedViewController {
      return topViewController(presented)
    }
    
    return base
  }
  
  class func show(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let action = UIAlertAction(title: "확인", style: .default, handler: nil)
    alertController.addAction(action)
    
    topViewController()?.present(alertController, animated: true, completion: nil)
  }
  
  class func show(_ mainTitle: String, message: String, cancelTitle: String, confirmTitle: String, _ handleComfirm: @escaping (UIAlertAction) -> Void, _ handleCancel: @escaping (UIAlertAction) -> Void) {
    let alertController = UIAlertController(title: mainTitle, message: message, preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: handleCancel)
    
    let comfirmAction = UIAlertAction(title: confirmTitle, style: .destructive, handler: handleComfirm)
    
    alertController.addAction(cancelAction)
    alertController.addAction(comfirmAction)
    
    topViewController()?.present(alertController, animated: true, completion: nil)
  }
  
  class func show(_ itemTitles: [String], itemClosures: [((UIAlertAction) -> Void)], cancelTitle: String, handleCancel: @escaping (UIAlertAction) -> Void) {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    for i in 0 ..< itemTitles.count {
      let action = UIAlertAction(title: itemTitles[i],
                                 style: .default,
                                 handler: itemClosures[i])
      alertController.addAction(action)
    }
    
    let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: handleCancel)
    
    alertController.addAction(cancelAction)
    topViewController()?.present(alertController, animated: true, completion: nil)
  }
}

