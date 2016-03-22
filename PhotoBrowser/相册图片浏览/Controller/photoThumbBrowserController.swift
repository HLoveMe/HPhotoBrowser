//
//  photoBrowserController.swift
//  PhotoBrowser
//
//  Created by space on 16/2/3.
//  Copyright © 2016年 Space. All rights reserved.
//

import UIKit
/// 单个相册
class photoThumbBrowserController: UIViewController {
    var currentAblum:photoAblum?{
        didSet{
            self.title = currentAblum?.ablumName
        }
    }
     let one:photoBrowserController = photoBrowserController()
    lazy var collectionView:UICollectionView = {
        let flow = UICollectionViewFlowLayout.init()
        flow.itemSize = CGSizeMake((screenWidth - 2 * 3)/4,(screenWidth - 2 * 3)/4)
        flow.minimumInteritemSpacing = 2
        flow.minimumLineSpacing = 2
        flow.sectionInset =  UIEdgeInsetsMake(10, 0, 2, 0)
        let coll:UICollectionView = UICollectionView.init(frame:CGRectMake(0,0, self.view.width, self.view.height-64-44), collectionViewLayout: flow)
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = UIColor.whiteColor()
        coll.registerNib(UINib.init(nibName: "HPhotoCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: "HPhotoCell")
        return coll
    }()
    var toolView:HToolView?
    lazy var temp:UIView = {
        let one:UIView = UIView.init(frame: CGRectMake(0,self.collectionView.MaxY,screenWidth,44))
        one.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        let toolView = HToolView.toolView()
        toolView.frame = CGRectMake(0,1,screenWidth,43)
        toolView.delegate = self
        self.toolView = toolView
        one.addSubview(toolView)
        return one
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.temp)
        
        
        let image = UIImage(named: "navBackBtn")
        let temp = image?.imageWithRenderingMode(.AlwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: temp, style: .Plain, target: self, action: "back")
    
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        self.collectionView.scrollToItemAtIndexPath(NSIndexPath.init(forRow:self.currentAblum!.imageCount-1, inSection: 0), atScrollPosition: .None, animated: false)
       
        self.toolView!.imageCountLab.text = "共有" + (self.currentAblum?.imageCount.toString())! + "张相片"
    }
    func back(){
        self.navigationController?.popViewControllerAnimated(true)
    }
}
extension photoThumbBrowserController:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.currentAblum!.imageCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell:HPhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier("HPhotoCell", forIndexPath: indexPath) as! HPhotoCell
        cell.backgroundColor = randomColor()
        if let ablum = self.currentAblum{
            cell.asset = ablum.assets![indexPath.row]
        }
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        one.indexPath = indexPath
        one.currentAblum =  self.currentAblum
        self.navigationController?.pushViewController(one, animated: true)
    }
}
extension photoThumbBrowserController:ToolViewDelegate{
    func previewClick(toolView:HToolView,button:UIButton){
        self.navigationController?.pushViewController(photoBrowserController(), animated: true)
    }
    func sureClick(toolView:HToolView,button:UIButton){
    
    }
}


extension Int{
    func toString()->String{
        var one  = "\(self)"
        one = one.stringByReplacingOccurrencesOfString("Optional(", withString: "")
        one = one.stringByReplacingOccurrencesOfString(")", withString: "")
        return one
    }
}
