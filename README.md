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
- [x] Performance optimization - Automatically cache and destroy photos.
- [x] Multiple selection.
- [x] Automatically update the UI When PhotoLibrary changes.

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
