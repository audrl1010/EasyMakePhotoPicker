//
//  KaKaPhotoPickerVC.swift
//  EasyMakePhotoPicker
//
//  Created by myung gi son on 2017. 7. 3..
//  Copyright © 2017년 CocoaPods. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import RxCocoa
import EasyMakePhotoPicker

protocol KaKaoPhotoPickerOutput {
  var output: KaKaoPhotoPickerOutput { get }
  var cancel: Observable<Void> { get }
  var selectionDidComplete: Observable<[PhotoAsset]> { get }
  var photoDidTake: Observable<PhotoAsset> { get }
}

class KaKaoPhotoPickerVC: UIViewController, KaKaoPhotoPickerOutput {
  var output: KaKaoPhotoPickerOutput { return self }
  
  var cancel: Observable<Void> {
    return cancelButton.rx.tap.asObservable()
  }
  
  var selectionDidComplete: Observable<[PhotoAsset]> {
    return selectedPhotoAssetsDidComplete.asObservable()
  }
  
  var photoDidTake: Observable<PhotoAsset> {
    return photoAssetDidTakeFromCamera.asObservable()
  }
  
  fileprivate var selectedPhotoAssetsDidComplete = PublishSubject<[PhotoAsset]>()
  
  fileprivate var photoAssetDidTakeFromCamera = PublishSubject<PhotoAsset>()
  
  fileprivate var disposeBag = DisposeBag()
  
  fileprivate var photosViewConfigure = KaKaoPhotosViewConfigure()
  
  fileprivate var photoCollectionsViewConfigure = KaKaoPhotoCollectionsViewConfigure()
  
  fileprivate var currentPhotoAssetCollection: PhotoAssetCollection?
  
  fileprivate var hasCollectionCellBeenForcedToBeSelected = false
  
  fileprivate var isTitleViewSelected: Bool = false
  
  var photosView: PhotosView!
  
  var photoCollectionsView: PhotoCollectionsView!
  
  var cancelButton = UIBarButtonItem(
    barButtonSystemItem: .cancel,
    target: nil, action: nil)
  
  var doneButton = UIBarButtonItem(
    barButtonSystemItem: .done,
    target: nil,
    action: nil)
  
  var titleView = UILabel().then {
    $0.font = UIFont.boldSystemFont(ofSize: 16)
    $0.isUserInteractionEnabled = true
    $0.numberOfLines = 0;
  }
  
  fileprivate var photoCollectionsViewTopConstraint: NSLayoutConstraint?
  
  // MARK: - Orientation
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.leftBarButtonItem = cancelButton
    navigationItem.rightBarButtonItem = doneButton
    navigationItem.titleView = titleView
    
//    if let navigationBar = navigationController?.navigationBar {
//      titleView
//        .fs_centerXAnchor(equalTo: navigationBar.centerXAnchor)
//        .fs_centerYAnchor(equalTo: navigationBar.centerYAnchor)
//        .fs_endSetup()
//    }
    
    // load photoCollection to show initially.
    PhotoManager.shared
      .fetchCollections(
        assetCollectionTypes: [.smartAlbumUserLibrary],
        thumbnailImageSize: self.photoCollectionsViewConfigure.photoCollectionThumbnailSize,
        options: self.photosViewConfigure.fetchOptions)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] photoAssetCollections in
        guard let `self` = self,
          let photoAssetCollection = photoAssetCollections.first else { return }
        self.currentPhotoAssetCollection = photoAssetCollection
        self.setup(with: photoAssetCollection)
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - Bind

extension KaKaoPhotoPickerVC {
  fileprivate func setup(with photoAssetCollection: PhotoAssetCollection) {
    titleView.text = photoAssetCollection.title + "▾"
    
    photosView = PhotosView(
      configure: photosViewConfigure,
      photoAssetCollection: photoAssetCollection)
    
    photoCollectionsView = PhotoCollectionsView(
      configure: photoCollectionsViewConfigure).then {
        $0.isHidden = true
    }
    
    view.addSubview(photosView)
    view.addSubview(photoCollectionsView)
    
    photosView
      .fs_leftAnchor(equalTo: view.leftAnchor)
      .fs_topAnchor(equalTo: view.topAnchor)
      .fs_rightAnchor(equalTo: view.rightAnchor)
      .fs_bottomAnchor(equalTo: view.bottomAnchor)
      .fs_endSetup()
    
    photoCollectionsView
      .fs_widthAnchor(equalTo: self.view.widthAnchor)
      .fs_heightAnchor(equalTo: self.view.heightAnchor)
      .fs_topAnchor(
        equalTo: self.topLayoutGuide.bottomAnchor,
        constant: -self.view.frame.height,
        constraint: &self.photoCollectionsViewTopConstraint)
      .fs_endSetup()
    
    bind()
  }
  
  fileprivate func bind() {
    cancelButton.rx.tap
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { _ in
        self.dismiss(animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    doneButton.rx.tap
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { _ in
        self.photosView.selectionDidComplete.onNext(())
        self.dismiss(animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    photosView.selectedPhotosDidComplete
      .subscribe(onNext: { [weak self] photoAssets in
        guard let `self` = self else { return }
        self.selectedPhotoAssetsDidComplete.onNext(photoAssets)
      })
      .disposed(by: disposeBag)
    
    photosView.outputs.cameraDidClick
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] in
        guard let `self` = self else { return }
        self.showCamera()
      })
      .disposed(by: disposeBag)
    
    photoCollectionsView.selectedPhotoCollectionWhenCellDidSelect
      .observeOn(MainScheduler.instance)
      .skip(1) // because first force collectionCell selection
      .do(onNext: { [weak self] (_, _) in
        guard let `self` = self else { return }
        self.animatePhotoCollectionsView()
      })
      .filter { [weak self] (_, photoAssetCollection) in
        guard let `self` = self,
          let currentPhotoAssetCollection = self.currentPhotoAssetCollection else {
            return true
        }
        return currentPhotoAssetCollection.localIdentifier != photoAssetCollection.localIdentifier
      }
      .do(onNext: { [weak self] (selectedIndexPath, selectedPhotoAssetCollection) in
        guard let `self` = self else { return }
        self.currentPhotoAssetCollection = selectedPhotoAssetCollection
      })
      .subscribe(onNext: { [weak self] (selectedIndexPath, selectedPhotoAssetCollection) in
        guard let `self` = self else { return }
        self.isTitleViewSelected = false
        self.titleView.text =
          selectedPhotoAssetCollection.title + (self.isTitleViewSelected ? "▴" : "▾")
        self.photosView.change(photoAssetCollection: selectedPhotoAssetCollection)
      })
      .disposed(by: disposeBag)
    
    let tap = UITapGestureRecognizer()
    tap.rx.event
      .observeOn(MainScheduler.instance)
      .debounce(0.15, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] recognizer in
        guard let `self` = self else { return }
        if !self.hasCollectionCellBeenForcedToBeSelected {
          self.hasCollectionCellBeenForcedToBeSelected = true
          self.photoCollectionsView.cellDidSelect.onNext(IndexPath(item: 0, section: 0))
        }
        self.isTitleViewSelected = !self.isTitleViewSelected
        var title = self.titleView.text ?? ""
        title = (title.characters.count > 0 ? String(title.characters.dropLast(1)) : "")
        self.titleView.text = title + (self.isTitleViewSelected ? "▴" : "▾")
        self.animatePhotoCollectionsView()
      })
      .disposed(by: disposeBag)
    titleView.addGestureRecognizer(tap)
  }
}

// MARK: - Animation
extension KaKaoPhotoPickerVC {
  fileprivate func animatePhotoCollectionsView() {
    photoCollectionsView.layer.removeAllAnimations()
    
    if photoCollectionsView.isHidden {
      UIView.Animator(duration: 0.25)
        .options(.curveEaseOut)
        .beforeAnimations { [weak self] in
          guard let `self` = self else { return }
          self.photoCollectionsViewTopConstraint?.constant = 0
          self.photoCollectionsView.isHidden = false
        }
        .animations { [weak self] in
          guard let `self` = self else { return }
          self.view.layoutIfNeeded()
        }
        .animate()
    }
    else {
      UIView.Animator(duration: 0.25)
        .beforeAnimations { [weak self] in
          guard let `self` = self else { return }
          self.photoCollectionsViewTopConstraint?.constant = -self.view.frame.height
        }
        .animations { [weak self] in
          guard let `self` = self else { return }
          self.view.layoutIfNeeded()
        }
        .completion { [weak self] _ in
          guard let `self` = self else { return }
          self.photoCollectionsView.isHidden = true
        }
        .animate()
    }
  }
}

// MARK: - UIImagePickerControllerDelegate

extension KaKaoPhotoPickerVC:
  UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
  
  fileprivate func showCamera() {
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.delegate = self
    self.present(picker, animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

    if let image = (info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage) {
      var placeholderAsset: PHObjectPlaceholder? = nil
      PhotoManager.shared
        .performChanges(changeBlock: {
          let newAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
          placeholderAsset = newAssetRequest.placeholderForCreatedAsset
        })
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] performChangesEvent in
          switch performChangesEvent {
          case .completion(let success):
            if let `self` = self,
              success,
              let identifier = placeholderAsset?.localIdentifier {
              guard let asset =
                PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil).firstObject else {
                  return
              }
              let photoAsset = PhotoAsset(asset: asset)
              self.photoAssetDidTakeFromCamera.onNext(photoAsset)
              self.dismiss(animated: true, completion: nil)
            }
          }
        })
        .disposed(by: disposeBag)
    }
    picker.dismiss(animated: true, completion: nil)
  }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
