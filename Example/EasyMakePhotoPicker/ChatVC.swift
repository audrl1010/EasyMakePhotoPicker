//
//  ChatVC.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 3..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//


import UIKit
import PhotosUI
import RxSwift
import RxCocoa
import EasyMakePhotoPicker

protocol KeyboardObservable {
  func registerKeyboardObservers()
  func removeKeyboardObservers()
  func keyboardWillShow(_ notification: Notification)
  func keyboardWillHide(_ notification: Notification)
  func adjustInsetForKeyboard(_ show: Bool, notification: Notification)
}

protocol keyboardDismissableByViewTouch {
  var keyboardDismissTapGesture: UITapGestureRecognizer? { get set }
  
  func adjustKeyboardDismissTapGesture(isKeyboardVisible: Bool)
  func dismissKeyboard()
}

class ChatVC: BaseVC {
  
  // MARK: - Constants
  
  fileprivate struct Constant {
    static let inputBarHeight = CGFloat(40)
    static let tableViewEstimatedRowHeight = CGFloat(100)
  }
  
  fileprivate struct Color {
    static let tableViewColor =
      UIColor(red: 189/255, green: 209/255, blue: 220/255, alpha: 1.0)
  }
  
  // MARK: - Properties
  
  var canShowMenuViewOverKeyboard: Bool = false
  
  var keyboardDismissTapGesture: UITapGestureRecognizer?
  
  fileprivate var inputBarBottomConstraint: NSLayoutConstraint?
  
  lazy var inputBar: InputBar = { [unowned self] in
    let ipb = InputBar()
    ipb.plusButton.addTarget(self,
      action: #selector(didTapPlusButton),
      for: .touchUpInside)
    return ipb
  }()
  
  lazy var tableView: UITableView = { [unowned self] in
    let tv = UITableView()
    tv.dataSource = self
    tv.separatorStyle = .none
    tv.estimatedRowHeight = Constant.tableViewEstimatedRowHeight
    tv.rowHeight = UITableViewAutomaticDimension
    tv.backgroundColor = Color.tableViewColor
    tv.scrollIndicatorInsets.bottom = Constant.inputBarHeight
    tv.contentInset.bottom += Constant.inputBarHeight
    tv.register(ChatCell.self,
      forCellReuseIdentifier: ChatCell.cellIdentifier)
    return tv
  }()
  
  var photosViewConfigure = PhotosViewConfigure().then {
    $0.allowsCameraSelection = false
    $0.allowsPlayTypes = []
    $0.layout = ChatLayout()
  }
  
  lazy var photosView: PhotosView = { [unowned self] in
    let phsv = PhotosView(
      configure: self.photosViewConfigure,
      collectionType: .smartAlbumUserLibrary)
    phsv.autoresizingMask = .flexibleHeight
    return phsv
  }()
  
  var disposeBag = DisposeBag()
  
  var cancelButton = UIBarButtonItem(
    barButtonSystemItem: .cancel,
    target: nil, action: nil)
  
  // MARK: - Life Cycle
  
  deinit {
    removeKeyboardObservers()
  }
  
  override init(
    nibName nibNameOrNil: String?,
    bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    commontInitialize()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commontInitialize()
  }
  
  func commontInitialize() {
    registerKeyboardObservers()
  }
  
  override func setupViews() {
    navigationItem.leftBarButtonItem = cancelButton
    
    cancelButton.rx.tap
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { _ in
        self.dismiss(animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    view.addSubview(tableView)
    view.addSubview(inputBar)
    
    inputBar.textViewDidTap = { [weak self] in
      guard let `self` = self else { return }
      // photoListView가 화면에 보여지고 있는 상태일 때, 유저가 textView를 터치 했다는 것은
      // 키보드에서 키를 입력하고 싶다는 것이므로, photoListView에서 키보드로 전환
      if self.inputBar.textView.isFirstResponder {
        self.inputBar.textView.inputView = nil
        self.inputBar.textView.reloadInputViews()
        self.canShowMenuViewOverKeyboard = false
      }
    }
  }
  
  override func setupConstraints() {
    tableView
      .fs_leftAnchor(equalTo: view.leftAnchor)
      .fs_rightAnchor(equalTo: view.rightAnchor)
      .fs_topAnchor(equalTo: topLayoutGuide.bottomAnchor)
      .fs_bottomAnchor(equalTo: view.bottomAnchor)
      .fs_endSetup()
    
    inputBar
      .fs_leftAnchor(equalTo: view.leftAnchor)
      .fs_rightAnchor(equalTo: view.rightAnchor)
      .fs_bottomAnchor(
        equalTo: view.bottomAnchor,
        constraint: &inputBarBottomConstraint)
      .fs_heightAnchor(equalToConstant: Constant.inputBarHeight)
      .fs_endSetup()
  }
}



// MARK: - Events
extension ChatVC {
  
  func didTapPlusButton() {
    canShowMenuViewOverKeyboard = !canShowMenuViewOverKeyboard
    
    // photoListView를 보여줘라
    if canShowMenuViewOverKeyboard {
      // 키보드가 화면에 보여져있는 상태에서는 키보드 영역에 photoListView를 집어넣음
      if inputBar.textView.isFirstResponder {
        inputBar.textView.inputView = photosView
        inputBar.textView.reloadInputViews()
      }
      else {
        // 키보드가 화면에 보여져있지 않은 상태에서는 키보드를 올려야 됨
        inputBar.textView.inputView = photosView
        inputBar.textView.reloadInputViews()
        inputBar.textView.becomeFirstResponder()
      }
    }
    else {
      // photoListView를 보여주지 말아라.
      // 키보드가 화면에 보여져있는 상태에서만 photoListView를 안보여줄 수 있음
      if inputBar.textView.isFirstResponder {
        inputBar.textView.inputView = nil
        inputBar.textView.reloadInputViews()
      }
    }
  }
}

// MARK: - UITableViewDataSource

extension ChatVC: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
    return 20
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell =
      tableView.dequeueReusableCell(
        withIdentifier: ChatCell.cellIdentifier,
        for: indexPath) as! ChatCell
    cell.backgroundColor = .clear
    cell.isUserInteractionEnabled = false
    return cell
  }
}

// MARK: - KeyboardObservable

extension ChatVC: KeyboardObservable {
  
  func registerKeyboardObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(_:)),
      name: .UIKeyboardWillHide,
      object: nil)
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(_:)),
      name: .UIKeyboardWillShow,
      object: nil)
  }
  
  func removeKeyboardObservers() {
    NotificationCenter.default.removeObserver(self)
  }
  
  func keyboardWillShow(_ notification: Notification) {
    adjustKeyboardDismissTapGesture(isKeyboardVisible: true)
    adjustInsetForKeyboard(true, notification: notification)
  }
  
  func keyboardWillHide(_ notification: Notification) {
    adjustKeyboardDismissTapGesture(isKeyboardVisible: false)
    adjustInsetForKeyboard(false, notification: notification)
  }
  
  func adjustInsetForKeyboard(_ show: Bool, notification: Notification) {
    let userInfo = notification.userInfo ?? [:]
    
    let keyboardFrame =
      (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    
    let keyboardDuration =
      userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
    
    UIView.Animator(duration: keyboardDuration)
      .beforeAnimations { [weak self] in
        guard let `self` = self else { return }
        self.inputBarBottomConstraint?.constant =
          show ? -keyboardFrame.height : 0
      }
      .animations { [weak self] in
        guard let `self` = self else { return }
        self.view.layoutIfNeeded()
      }
      .animate()
    
    let adjustmentHeight = keyboardFrame.height * (show ? 1 : -1)
    tableView.contentInset.bottom += adjustmentHeight
    tableView.scrollIndicatorInsets.bottom += adjustmentHeight
  }
}


// MARK: - keyboardDismissableByViewTouch

extension ChatVC: keyboardDismissableByViewTouch {
  
  func adjustKeyboardDismissTapGesture(isKeyboardVisible: Bool) {
    if isKeyboardVisible {
      if keyboardDismissTapGesture == nil {
        keyboardDismissTapGesture =
          UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(keyboardDismissTapGesture!)
      }
    }
    else {
      if keyboardDismissTapGesture != nil {
        view.removeGestureRecognizer(keyboardDismissTapGesture!)
        keyboardDismissTapGesture = nil
      }
    }
  }
  
  func dismissKeyboard() {
    canShowMenuViewOverKeyboard = false
    inputBar.textView.resignFirstResponder()
    inputBar.textView.inputView = nil
  }
}





