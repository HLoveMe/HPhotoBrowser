//
//  PhotoUtil.swift
//  PhotoBrowser
//
//  Created by space on 16/2/2.
//  Copyright © 2016年 Space. All rights reserved.
//

import UIKit
import Photos
/**单个asset*/
class HAsset:NSObject{
    var asset:PHAsset
    var ID:String
    init(asset:PHAsset){
        self.asset = asset
        self.ID = asset.localIdentifier
    }
}

/**相册*/
class photoAblum {
    var ablumName:String?
    var imageCount:Int = 0
    var thumbImage:UIImage?
    var assets:[HAsset]?{
        didSet{
            imageCount = assets!.count
            guard assets?.count>0 else{return}
            PhotoUtil.sharedPhotoUtil.getImageFrom((assets?.last!.asset)!, mode: .Fast, quality:Quality.low, expectSize: CGSizeMake(60, 80)) { (image,_) -> () in
                self.thumbImage = image
            }
        }
    }
}
/**整个手机的所相册*/
class phoneAblum {
    var ablumCount:Int!
    var ablumCollection:[photoAblum]?{
        didSet{
            ablumCount = ablumCollection?.count
        }
    }
    /**打印所有相册的名称*/
    static func printAllAblum()->(){
        let phone = PhotoUtil.sharedPhotoUtil.getPhonePhotoAblum()
        for one in phone.ablumCollection! {
            print("\(one.ablumName)")
        }
    }
}



class PhotoUtil: NSObject {
    private override init() {}
    static var sharedPhotoUtil:PhotoUtil = PhotoUtil.init()
    static var phone:phoneAblum?
    /**得到手机所有相册*/
    func getPhonePhotoAblum()->phoneAblum{
        if let _ = PhotoUtil.phone{
            return PhotoUtil.phone!
        }
        var dataArray:[photoAblum] = [photoAblum]()
        /**系统相册*/
        let smartAlbums:PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .AlbumRegular, options: nil)
        smartAlbums.enumerateObjectsUsingBlock { (one, index, _) -> Void in
            let collection:PHAssetCollection = one as! PHAssetCollection
            let  temp = self.getAssetsFrom(collection)
            if temp.count > 0 {
                print("\(collection.localizedTitle)")
                let one = photoAblum.init()
                one.ablumName = collection.localizedTitle
                one.assets = self.getAssetsFrom(collection)
                dataArray.append(one)
            }
        }
        /**得到用户自己创建的相册 应用程序啊 啥的*/
        let userAlbums:PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .SmartAlbumUserLibrary, options: nil)
        userAlbums.enumerateObjectsUsingBlock { (one, index, _) -> Void in
            let collection:PHAssetCollection = one as! PHAssetCollection
            let  temp = self.getAssetsFrom(collection)
            if temp.count > 0 {
                print("\(collection.localizedTitle)")
                let one = photoAblum.init()
                one.ablumName = collection.localizedTitle
                one.assets = self.getAssetsFrom(collection)
                dataArray.append(one)
            }
        }
        let phone = phoneAblum.init()
        phone.ablumCollection = dataArray
        PhotoUtil.phone = phone
        return PhotoUtil.phone!
    }
    /**通过名字得到相册*/
    func getAblum(name:String)->photoAblum{
        let ablum = photoAblum.init()
        let smartAlbums:PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .AlbumRegular, options: nil)
        smartAlbums.enumerateObjectsUsingBlock { (one, index, _bool) -> Void in
            let collection:PHAssetCollection = one as! PHAssetCollection
            if (name == collection.localizedTitle!){
                ablum.ablumName = collection.localizedTitle
                ablum.assets = self.getAssetsFrom(collection)
                _bool.memory = true
            }
        }
        return ablum
    }
    
    /**得到最近的相册*/
    func getRecentlyAblum()->photoAblum{
        return getAblum("Recently Added")
    }
    /**最近添加*/
    func getCameraRollAblum()->photoAblum{
        return getAblum("Camera Roll")
    }
    

    /**得到不同质量的图片*/
     /** 得到对应的图片
     - parameter asset:      PHAsset
     - parameter mode:       None 默认加载尺寸 Fast快速 Exact 提供精准的尺寸
     - parameter quality:    得到的图片质量
     - parameter expectSize: 期望的大小 nil 为默认
     - parameter complement: 得到图片
     */
    func getImageFrom(asset:PHAsset,mode:PHImageRequestOptionsResizeMode,quality:Quality,expectSize:CGSize?,complement:(UIImage?,imageStatus)->()){
       let imageOPtion = PHImageRequestOptions.init()
        imageOPtion.resizeMode = mode
        imageOPtion.synchronous = true
        imageOPtion.networkAccessAllowed = true
        switch quality{
        case .low:
            imageOPtion.deliveryMode = .FastFormat
            break
        case .medium:
            imageOPtion.deliveryMode = .Opportunistic
            break
        case .hight:
            imageOPtion.deliveryMode = .HighQualityFormat
            break
        }
        let size = expectSize ?? PHImageManagerMaximumSize
        PHCachingImageManager.defaultManager().requestImageForAsset(asset, targetSize: size, contentMode:PHImageContentMode.AspectFit, options: imageOPtion) { (image, _) -> Void in
            let one = image?.size
            let status = (one!.width>=one!.height) ? imageStatus.Horizontal : imageStatus.Vertical
            complement(image,status)
        }
    }
    private func getAssetsFrom(collection:PHAssetCollection)->[HAsset]{
        //        let option = PHFetchOptions.init()
        //        option.sortDescriptors = []
        var assets:[HAsset] = [HAsset]()
        let result:PHFetchResult =  PHAsset.fetchAssetsInAssetCollection(collection, options: nil)
        result.enumerateObjectsUsingBlock { (one, index, _) -> Void in
            assets.append(HAsset.init(asset: one as! PHAsset))
        }
        return assets
    }
    /**清除缓存*/
    static func clearCache(){
        PhotoUtil.phone = nil;
    }
    /**当前是否有访问的权限*/
    static func isauthorityForLibary()->Bool{
       let status = PHPhotoLibrary.authorizationStatus()
        switch status{
        case .Denied:
            return false
        case .Restricted:
            return false
        case .NotDetermined:
            return false
        default:
            return true
        }
    }
    /**请求访问权限*/
    static func requestAuthority(){
        PHPhotoLibrary.requestAuthorization { (_) -> Void in}
    }
}
enum Quality{
    case low,medium,hight
}

enum imageStatus{
   case Horizontal,Vertical
}
    