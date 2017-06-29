//
//  FacebookPhotoPickerVC.swift
//  PhotoPicker
//
//  Created by myung gi son on 2017. 6. 28..
//  Copyright © 2017년 grutech. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import RxCocoa
import EasyMakePhotoPicker

protocol FacebookPhotoPickerOutput {
  var output: FacebookPhotoPickerOutput { get }
  var cancel: Observable<Void> { get }
  var selectionDidComplete: Observable<[PhotoAsset]> { get }
  var photoDidTake: Observable<PhotoAsset> { get }
}

class FacebookPhotoPickerVC: UIViewController, FacebookPhotoPickerOutput {
  var output: FacebookPhotoPickerOutput { return self }
  
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
  
  fileprivate var photosViewConfigure = PhotosViewConfigure().then {
    $0.allowsPlayTypes = [.video, .livePhoto]
    $0.layout = FacebookPhotosLayout()
    $0.cameraCellClass = FacebookCameraCell.self
    $0.photoCellClass = FacebookPhotoCell.self
    $0.livePhotoCellClass = FacebookLivePhotoCell.self
    $0.videoCellClass = FacebookVideoCell.self
  }
  
  fileprivate var photoCollectionsViewConfigure = PhotoCollectionsViewConfigure().then {
    $0.showsCollectionTypes = [
      .smartAlbumUserLibrary,
      .smartAlbumGeneric,
      .smartAlbumFavorites,
      .smartAlbumRecentlyAdded,
      .smartAlbumSelfPortraits,
      .smartAlbumBursts,
      .smartAlbumScreenshots
    ]
    $0.layout = FacebookPhotoCollectionsLayout()
    $0.photoCollectionCellClass = FacebookCollectionCell.self
    $0.photoCollectionThumbnailSize = CGSize(
      width: 54 * UIScreen.main.scale,
      height: 54 * UIScreen.main.scale)
  }

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
  
  var coverView = UIView().then {
    $0.backgroundColor = UIColor(
      red: 0,
      green: 0,
      blue: 0,
      alpha: 0.6)
    $0.alpha = 0
  }
  
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
    
    if let navigationBar = navigationController?.navigationBar {
      titleView
        .fs_centerXAnchor(equalTo: navigationBar.centerXAnchor)
        .fs_centerYAnchor(equalTo: navigationBar.centerYAnchor)
        .fs_endSetup()
    }
    
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
        self.setup(with: photoAssetCollection)
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - Bind

extension FacebookPhotoPickerVC {
  fileprivate func setup(with photoAssetCollection: PhotoAssetCollection) {
    titleView.text = photoAssetCollection.title + "▾"
    
    photosView = PhotosView(
      configure: photosViewConfigure,
      photoAssetCollection: photoAssetCollection)
    
    photoCollectionsView = PhotoCollectionsView(
      configure: photoCollectionsViewConfigure).then {
        $0.alpha = 0
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
    }
    
    view.addSubview(photosView)
    view.addSubview(coverView)
    view.addSubview(photoCollectionsView)
    
    photosView
      .fs_leftAnchor(equalTo: view.leftAnchor)
      .fs_topAnchor(equalTo: view.topAnchor)
      .fs_rightAnchor(equalTo: view.rightAnchor)
      .fs_bottomAnchor(equalTo: view.bottomAnchor)
      .fs_endSetup()
    
    coverView
      .fs_leftAnchor(equalTo: view.leftAnchor)
      .fs_topAnchor(equalTo: view.topAnchor)
      .fs_rightAnchor(equalTo: view.rightAnchor)
      .fs_bottomAnchor(equalTo: view.bottomAnchor)
      .fs_endSetup()
    
    photoCollectionsView
      .fs_topAnchor(
        equalTo: topLayoutGuide.bottomAnchor,
        constant: 10)
      .fs_widthAnchor(equalToConstant: view.frame.width)
      .fs_heightAnchor(equalToConstant: view.frame.height * 0.45)
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
        self.photosView.selectionDidComplete.onNext()
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
      .subscribe(onNext: { [weak self] (selectedIndexPath, selectedPhotoAssetCollection) in
        guard let `self` = self else { return }
        self.isTitleViewSelected = false
        self.titleView.text =
          selectedPhotoAssetCollection.title + (self.isTitleViewSelected ? "▴" : "▾")
        self.photosView.change(photoAssetCollection: selectedPhotoAssetCollection)
        self.animatePhotoCollectionsView()
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
extension FacebookPhotoPickerVC {
  fileprivate func animatePhotoCollectionsView() {
    photoCollectionsView.layer.removeAllAnimations()
    if coverView.alpha == 0 {
      UIView.SpringAnimator(duration: 0.4)
        .options(.curveEaseOut)
        .velocity(0.0)
        .damping(0.6)
        .beforeAnimations { [weak self] in
          guard let `self` = self else { return }
          self.photoCollectionsView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        .animations { [weak self] in
          guard let `self` = self else { return }
          self.photoCollectionsView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
          self.coverView.alpha = 1
          self.photoCollectionsView.alpha = 1
        }
        .animate()
    }
    else {
      UIView.Animator(duration: 0.25)
        .animations { [weak self] in
          guard let `self` = self else { return }
          self.photoCollectionsView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
          self.coverView.alpha = 0
        }
        .completion { [weak self] _ in
          guard let `self` = self else { return }
          self.photoCollectionsView.alpha = 0
        }
        .animate()
    }
  }
}

// MARK: - UIImagePickerControllerDelegate

extension FacebookPhotoPickerVC:
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
    didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) {
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





