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

## Initializer
```
init(configure: PhotosViewConfigure, photoAssetCollection: PhotoAssetCollection)
init(configure: PhotosViewConfigure, collectionType: PHAssetCollectionSubtype)
```

## PhotosViewConfigure
```
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
```
// Note: 'selectedPhotosDidComplete' reacts when the signal come from selectionDidComplete.
var selectionDidComplete: PublishSubject<Void>
```

## Outputs
```
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
```
func change(photoAssetCollection: PhotoAssetCollection)
```

# PhotoCollectionsView

## Initializer
```
init(frame: CGRect, configure: PhotoCollectionsViewConfigure)
init(configure: PhotoCollectionsViewConfigure)
```

## Inputs
```
// force cell selection.
var cellDidSelect: PublishSubject<IndexPath>
```
## Outputs
```
var selectedPhotoCollectionWhenCellDidSelect: PublishSubject<(IndexPath, PhotoAssetCollection)>
```


# PhotoManager
```
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


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

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
