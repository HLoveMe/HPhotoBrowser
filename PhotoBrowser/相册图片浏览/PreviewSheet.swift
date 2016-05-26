//
//  PreviewView.swift
//  PhotoBrowser
//
//  Created by space on 16/2/2.
//  Copyright © 2016年 Space. All rights reserved.
//

import UIKit
import Photos

class PreviewSheet:NSObject{
    var maxShowNum:Int = 10
    var maxSelectedCount = 5
    private var currentViewController:UIViewController?
    private var block:Block?
    private var sheetView:UIView!
    private let sheetViewHeight:CGFloat = 320
    private let collectionViewHeight:CGFloat = 170
    private lazy var backView:UIButton = {
        let rect  =  CGRectMake(0, screenHeight, screenWidth, screenHeight)
        let backView:UIButton  = UIButton.init(frame:rect)
        backView.addTarget(self, action: #selector(PreviewSheet.backViewClick(_:)), forControlEvents: .TouchUpInside)
        let sheetView = UIView.init(frame: CGRectMake(0, screenHeight - self.sheetViewHeight, screenWidth, self.sheetViewHeight))
        backView.addSubview(sheetView)
        self.sheetView = sheetView
        return backView
    }()
    private lazy var collectionView:UICollectionView =  {
        let flow = UICollectionViewFlowLayout.init()
        flow.minimumLineSpacing = 2
        flow.minimumInteritemSpacing  = 5
        flow.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2)
        flow.scrollDirection = .Horizontal
        let coll:UICollectionView = UICollectionView.init(frame: CGRectMake(0, 0, screenWidth, self.collectionViewHeight - 10), collectionViewLayout: flow)
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = UIColor.whiteColor()
        coll.bounces = false
        coll.registerNib(UINib.init(nibName: "HPhotoCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "HPhotoCell")
        return coll
    }()
    private var  sureButton:UIButton!
    private lazy var stackView:UIStackView = {
        let rect = CGRectMake(0, self.collectionViewHeight-8, screenWidth, self.sheetViewHeight - self.collectionViewHeight + 6)
        let one:UIStackView = UIStackView.init(frame: rect)
        one.axis = .Vertical
        one.alignment = .Fill
        one.distribution = .FillEqually
        one.spacing = 2
        let takePic = UIButton.init()
        takePic.backgroundColor = UIColor.whiteColor()
        takePic.setTitleColor(UIColor.blackColor(), forState: .Normal)
        takePic.setTitle("拍照", forState: .Normal)
        takePic.addTarget(self, action: #selector(PreviewSheet.takePhoto(_:)), forControlEvents: .TouchUpInside)
        let photoButton = UIButton.init()
        photoButton.backgroundColor = UIColor.whiteColor()
        photoButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        photoButton.setTitle("相册", forState: .Normal)
        photoButton.addTarget(self, action: #selector(PreviewSheet.scanAllAlbum(_:)), forControlEvents: .TouchUpInside)
        self.sureButton = photoButton
        let cancel = UIButton.init()
        cancel.backgroundColor = UIColor.whiteColor()
        cancel.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cancel.setTitle("取消", forState: .Normal)
        cancel.addTarget(self, action: #selector(PreviewSheet.backViewClick(_:)), forControlEvents: .TouchUpInside)
        one.addArrangedSubview(takePic)
        one.addArrangedSubview(photoButton)
        one.addArrangedSubview(cancel)
        return one
    }()
    private var RecentlyAblum:photoAblum?
    private lazy var  imagePicker:UIImagePickerController = {
        let one  = UIImagePickerController.init()
        one.delegate = self
        return UIImagePickerController()
    }()
    
    typealias Block = ([UIImage])->()
    
     override init() {
       super.init()
       NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PreviewSheet.SelectImageNotifacaton(_:)), name: SelectNotifacaton, object: nil)
    }
    
    func showPreview(sender:UIViewController,block:Block)->PreviewSheet{
        selectedImages.removeAll()
        self.currentViewController = sender
        self.block = block
        if(!PhotoUtil.isauthorityForLibary()){
            self.showMessage("无法使用相册", message: "设置-隐私-相机,设置权限")
            return self
        }
        PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
        self.RecentlyAblum = PhotoUtil.sharedPhotoUtil.getCameraRollAblum()
        self.initSubViews()
        self.show()
        self.collectionView.reloadData()
        return self
    }
    func SelectImageNotifacaton(notifacation:NSNotification){
        let IDs = selectedImages.map { (one) -> String in
            return one.ID
        }
        let dic:[String:AnyObject] = notifacation.object as! [String:AnyObject]
        let one:HAsset = dic["asset"] as! HAsset
        let button:UIButton = dic["button"] as! UIButton
        if (IDs.contains(one.ID)){
            selectedImages.removeAtIndex(selectedImages.indexOf(one)!)
            button.selected = false
            if selectedImages.count == 0 {
                self.sureButton.removeTarget(self, action: #selector(PreviewSheet.sureSelected), forControlEvents:.TouchUpInside)
                sureButton.setTitle("相册", forState: .Normal)
                sureButton.addTarget(self, action: #selector(PreviewSheet.scanAllAlbum(_:)), forControlEvents: .TouchUpInside)
            }
        }else{
            if(selectedImages.count < self.maxSelectedCount){
                selectedImages.append(one)
                button.selected = true
                let content =  "确定(" + "\(selectedImages.count)" + ")"
                sureButton.setTitle(content, forState: .Normal)
                if selectedImages.count==1 {
                    sureButton.removeTarget(self, action: #selector(PreviewSheet.scanAllAlbum(_:)), forControlEvents:.TouchUpInside)
                    sureButton.addTarget(self, action: #selector(PreviewSheet.sureSelected), forControlEvents: .TouchUpInside)
                }
                
            }else{
                button.selected = false
            }
        }
    }
    func sureSelected()->(){
        if selectedImages.count==0 {return}
        var imags:[UIImage] = [UIImage]()
        for one in selectedImages{
            PhotoUtil.sharedPhotoUtil.getImageFrom(one.asset, mode: .None, quality: .medium, expectSize: nil, complement: { (oneImage, _) in
                imags.append(oneImage!)
            })
        }
        guard let _ = block else {return}
        self.backViewClick(backView)
        self.block!(imags)
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

let SelectNotifacaton:String = "SelectNotifacaton"
var selectedImages:[HAsset] = {[HAsset]()}()
extension PreviewSheet{
    func showMessage(title:String,message:String){
        let alert = UIAlertController.init(title:title, message: message, preferredStyle: .Alert)
        let one = UIAlertAction.init(title: "确定", style: .Cancel, handler: nil)
        alert.addAction(one)
        self.currentViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    func initSubViews(){
        self.currentViewController?.view.addSubview(self.backView)
        self.sheetView.addSubview(self.collectionView)
        self.sheetView.addSubview(self.stackView)
        self.sureButton.removeTarget(self, action: #selector(PreviewSheet.sureSelected), forControlEvents:.TouchUpInside)
        sureButton.setTitle("相册", forState: .Normal)
        sureButton.addTarget(self, action: #selector(PreviewSheet.scanAllAlbum(_:)), forControlEvents: .TouchUpInside)
    }
    
    func show(){
        self.currentViewController?.view.addSubview(self.backView)
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.backView.transform = CGAffineTransformMakeTranslation(0, -screenHeight)
            }) { (_) -> Void in
                self.backView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.99)
        }
        
    }
    func backViewClick(sender:UIButton){
        self.backView.backgroundColor = UIColor.clearColor()
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.backView.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                self.backView.removeFromSuperview()
        }
        
    }
    func takePhoto(sender:UIButton){
        self.imagePicker.sourceType = .Camera
        self.imagePicker.cameraDevice = .Rear
        self.currentViewController?.presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    
    func scanAllAlbum(sender:UIButton){
        self.imagePicker.sourceType = .PhotoLibrary
        let targer:UINavigationController = UINavigationController.init(rootViewController: photosViewController())
        self.currentViewController?.presentViewController(targer, animated: true, completion: nil)
    }
    
}
extension PreviewSheet:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        let assset = self.RecentlyAblum!.assets![self.RecentlyAblum!.imageCount-indexPath.row-1]
        let thumbHeight:CGFloat = self.collectionViewHeight - 14
        let thumbwidth:CGFloat=CGFloat(assset.asset.pixelWidth) / CGFloat(assset.asset.pixelHeight) * thumbHeight
        return CGSizeMake(thumbwidth,thumbHeight)
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if  self.RecentlyAblum?.imageCount > 0{
            return self.RecentlyAblum!.imageCount >= maxShowNum ?maxShowNum : self.RecentlyAblum!.imageCount
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell:HPhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier("HPhotoCell", forIndexPath: indexPath) as! HPhotoCell
//        cell.backgroundColor = randomColor()
        let assset = self.RecentlyAblum!.assets![self.RecentlyAblum!.imageCount-indexPath.row-1]
        cell.asset = assset
        return cell
    }
    
    
}
extension PreviewSheet:UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        
    }
    
}
//相册改变
extension PreviewSheet:PHPhotoLibraryChangeObserver{
    func photoLibraryDidChange(changeInstance: PHChange){
        if(PhotoUtil.isauthorityForLibary()){
            self.RecentlyAblum = PhotoUtil.sharedPhotoUtil.getRecentlyAblum()
            self.collectionView.reloadData()
        }
    }
}
