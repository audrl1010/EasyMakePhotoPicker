# EasyMakePhotoPicker

[![CI Status](http://img.shields.io/travis/audrl1010/EasyMakePhotoPicker.svg?style=flat)](https://travis-ci.org/audrl1010/EasyMakePhotoPicker)
[![Version](https://img.shields.io/cocoapods/v/EasyMakePhotoPicker.svg?style=flat)](http://cocoapods.org/pods/EasyMakePhotoPicker)
[![License](https://img.shields.io/cocoapods/l/EasyMakePhotoPicker.svg?style=flat)](http://cocoapods.org/pods/EasyMakePhotoPicker)
[![Platform](https://img.shields.io/cocoapods/p/EasyMakePhotoPicker.svg?style=flat)](http://cocoapods.org/pods/EasyMakePhotoPicker)

EasyMakePhotoPicker allows you to easily create your own PhotoPicker by providing the `PhotoListView` and `AlbumListView` into separate independent components.
The GIF below shows that EasyMakePhotoPicker makes it easy to create something like Facebook`s PhotoPicker.


## Why I created it

The core function of most PhotoPicker is a `PhotoListView` showing photos in grid form, and `AlbumListView` showing albums.

However, most of the PhotoPicker libraries are tightly bound between the `PhotoListView` object and `AlbumListView` object, so Custom has many limitations.

So I created EasyMakePhotoPicker so that you can easily create your own PhotoPicker by separating the `PhotoListView` and `AlbumListView` into separate independent components.

## Providing three components(PhotosView, PhotoCollectionsView, PhotoManager)

EasyMakePhotoPicker provides three components (PhotosView, PhotoCollectionsView, PhotoManager).

PhotosView is a grid-like view of photos from photoLibrary.

PhotoCollectionsView is a view that show a list of albums taken form photoLibrary.

PhotoManager is a wrapper class for PhotoCacheImageManager, it provides the functions of `PhotoCacheImageManager`(fetch photos, fetch albums, cache...etc) as Observable.


# PhotosView

- [x] Photo, Live Photo, and Video can be displayed in grid form.
- [x] Custom Layout
- [x] Custom Cell(Camera, Photo, LivePhoto, Video)
- [x] Like Facebook`s PhotoPicker, When you stop scrolling, it runs livePhoto, video. and When LivePhotoCell or VideCell is selected, play.
- [x] Scrolling performance optimization - Automatically cache and destroy photos.
- [x] Selected Order index.
- [x] Multiple selection.
- [x] Camera selection.
- [x] Automatically update the UI When PhotoLibrary changes(such as inserting, deleteing, updating, moving photos).


## Initializer
```swift
init(configure: PhotosViewConfigure, photoAssetCollection: PhotoAssetCollection)
init(configure: PhotosViewConfigure, collectionType: PHAssetCollectionSubtype)
```

## PhotosViewConfigure
```swift
class PhotosViewConfigure {
  var fetchOptions = PHFetchOptions().then {
    $0.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
  }

  var allowsMultipleSelection: Bool = true

  var allowsCameraSelection: Bool = true

  var allowsPlayTypes: [AssetType] = [
    .video, .livePhoto
  ]

  var messageWhenMaxCountSelectedPhotosIsExceeded: String = "max count that can select photos is exceeded !!!!"

  var maxCountSelectedPhotos: Int = 30

  // get item image from PHCachingImageManager
  // based on the UICollectionViewFlowLayout`s itemSize,
  // therefore must set well itemSize in UICollectionViewFlowLayout.
  var layout: UICollectionViewFlowLayout = PhotosLayout()

  var cameraCellClass: CameraCell.Type = CameraCell.self

  var photoCellClass: PhotoCell.Type = PhotoCell.self

  var livePhotoCellClass: LivePhotoCell.Type = LivePhotoCell.self

  var videoCellClass: VideoCell.Type = VideoCell.self
}
```

## Inputs
```swift
// Note: 'selectedPhotosDidComplete' reacts when the signal come from selectionDidComplete.
var selectionDidComplete: PublishSubject<Void>
```

## Outputs
```swift
var photoDidSelected: PublishSubject<PhotoAsset>

// Note: 'selectedPhotosDidComplete' reacts when the signal come from selectionDidComplete.
// only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true.
var selectedPhotosDidComplete: PublishSubject<[PhotoAsset]>

// only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true.
var selectedPhotosCount: PublishSubject<Int>

// only support when PhotosViewConfigure`s 'allowsMultipleSelection' property is true.
var photoDidDeselected: PublishSubject<PhotoAsset>

// only support when PhotosViewConfigure`s 'allowsCameraSelection' property is true.
var cameraDidClick: PublishSubject<Void>
```

## Public Methods
```swift
func change(photoAssetCollection: PhotoAssetCollection)
```

## Supported Cells in PhotosView(PhotoCell, LivePhotoCell, VideoCell, CameraCell)



### PhotoCell
```swift
class PhotoCell: UICollectionViewCell {

  var checkView: UIView

  var selectedView: UIView

  var orderLabel: UILabel

  var imageView: UIImageView

  ...
}
```

### CameraCell
```swift
class CameraCell: PhotoCell {

  var cameraIcon: UIImage

  var bgColor: UIColor
}

```

### LivePhotoCell
```swift
class LivePhotoCell: PhotoCell {

  var livePhotoView: PHLivePhotoView

  var livePhotoBadgeImageView: UIImageView

  ...
}
```

### VideoCell
```swift
class VideoCell: PhotoCell {

  var playerView: PlayerView

  var durationLabel: DurationLabel

  ...
}
```

## Usage
```swift
class ChatVC: UIViewController {

  var photosViewConfigure: PhotosViewConfigure = {
    let pvc = PhotosViewConfigure()
    pvc.allowsCameraSelection = false
    pvc.allowsMultipleSelection = true
    pvc.allowsPlayTypes = [.livePhoto]
    pvc.maxCountSelectedPhotos = 9
    pvc.messageWhenMaxCountSelectedPhotosIsExceeded = "over!!!!!!"
    pvc.layout = ...``can put your custom layout here.``
    pvc.cameraCellClass = ...``can put your custom cameraCell here.``
    pvc.photoCellClass = ...``can put your custom photoCellClass here.``
    pvc.livePhotoCellClass = ...``can put your custom livePhotoCell here.``
    pvc.videoCellClass = ...``can put your custom videoCellClass here.``
    ...
    return pvc
  }()
  
  lazy var photosView: PhotosView = { [unowned] self
    let pv = PhotosView(
      configure: self.photosViewConfigure,
      collectionType: .smartAlbumUserLibrary)
    pv.autoresizingMask = .flexibleHeight
    return pv
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    ...
    // MARK: - add view
    inputBar.textView.inputView = photosView

    // MARK: - bind
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
    ...
  }

  ....
}

##Tip

### Custom Layout
```swift

```
### Custom Cell
```swift

```
### Custom Cell

# PhotoCollectionsView
- [x] Custom Cell(PhotoCollection)
- [x] Custom Layout
- [x] Automatically update the UI When PhotoLibrary changes.

## Initializer
```swift
init(frame: CGRect, configure: PhotoCollectionsViewConfigure)
init(configure: PhotoCollectionsViewConfigure)
```

### PhotoCollectionsViewConfigure
```swift
class PhotoCollectionsViewConfigure {

  var fetchOptions = PHFetchOptions().then {
    $0.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
  }

  // to show collection types.
  var showsCollectionTypes: [PHAssetCollectionSubtype] = [
    .smartAlbumUserLibrary,
    .smartAlbumGeneric,
    .smartAlbumFavorites,
    .smartAlbumRecentlyAdded,
    .smartAlbumSelfPortraits,
    .smartAlbumVideos,
    .smartAlbumPanoramas,
    .smartAlbumBursts,
    .smartAlbumScreenshots
  ]

  // If you create a custom PhotoCollectionCell, size of thumbnailImageView in PhotoCollectionCell and
  // photoCollectionThumbnailSize must be the same
  // because get photo collection thumbnail image from PHCachingImageManager
  // based on the 'photoCollectionThumbnailSize'
  var photoCollectionThumbnailSize = CGSize(width: 54, height: 54)

  var layout: UICollectionViewFlowLayout = PhotoCollectionsLayout()

  var photoCollectionCellClass: PhotoCollectionCell.Type = PhotoCollectionCell.self
}
```


## Inputs
```swift
// force cell selection.
var cellDidSelect: PublishSubject<IndexPath>
```

## Outputs
```swift
var selectedPhotoCollectionWhenCellDidSelect: PublishSubject<(IndexPath, PhotoAssetCollection)>
```

# PhotoManager
```swift
func startCaching(assets: [PHAsset], targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?)

func stopCaching(assets: [PHAsset], targetSize: CGSize, contentMode: PHImageContentMode, options: PHImageRequestOptions?)

func stopCachingForAllAssets()

func cancel(imageRequest requestID: PHImageRequestID)

func photoLibraryDidChange(_ changeInstance: PHChange)

func performChanges(changeBlock: @escaping () -> Void) -> Observable<PerformChangesEvent>

func fetchCollections(assetCollectionTypes: [PHAssetCollectionSubtype], thumbnailImageSize: CGSize, options: PHFetchOptions? = nil) -> Observable<[PhotoAssetCollection]>

func image(for asset: PHAsset, size: CGSize = CGSize(width: 720, height: 1280), options: PHImageRequestOptions? = nil) -> Observable<UIImage>

func livePhoto(for asset: PHAsset, size: CGSize = CGSize(width: 720, height: 1280)) -> Observable<LivePhotoDownloadEvent>

func video(for asset: PHAsset, size: CGSize = CGSize(width: 720, height: 1280)) -> Observable<VideoDownloadEvent>

func cloudImage(for asset: PHAsset, size: CGSize = PHImageManagerMaximumSize) -> Observable<CloudPhotoDownLoadEvent>

func fullResolutionImage(for asset: PHAsset) -> Observable<UIImage>

func checkPhotoLibraryPermission() -> Observable<Bool>

func checkCameraPermission() -> Observable<Bool>
```

# Example making your own PhotoPicker.


## Requirements
iOS 9.1

## Installation

EasyMakePhotoPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "EasyMakePhotoPicker"
```

## Author

Myung gi son, audrl1010@naver.com

## License

EasyMakePhotoPicker is available under the MIT license. See the LICENSE file for more info.
