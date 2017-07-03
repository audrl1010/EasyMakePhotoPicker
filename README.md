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

a

# PhotoCollectionsView

a

# PhotoManager

a

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
