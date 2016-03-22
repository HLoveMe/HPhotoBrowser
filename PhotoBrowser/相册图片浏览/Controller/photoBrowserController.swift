//
//  photoBrowserController.swift
//  PhotoBrowser
//
//  Created by space on 16/2/3.
//  Copyright © 2016年 Space. All rights reserved.
//

/**单个相片查看*/

import UIKit

class photoBrowserController: UIViewController {
    var indexPath:NSIndexPath?
    var currentAblum:photoAblum?
    lazy var collectionView:UICollectionView = {
        let flow = UICollectionViewFlowLayout.init()
        flow.itemSize = CGSizeMake(self.view.width, self.view.height-64)
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        flow.sectionInset =  UIEdgeInsetsMake(0, 0,0, 0)
        flow.scrollDirection = .Horizontal
        let coll:UICollectionView = UICollectionView.init(frame:CGRectMake(0,0, self.view.width, self.view.height-64), collectionViewLayout: flow)
        coll.delegate = self
        coll.dataSource = self
        coll.pagingEnabled = true
        coll.backgroundColor = UIColor.whiteColor()
        coll.registerClass(PhotoBigCell.self, forCellWithReuseIdentifier: "PhotoBigCell")
        return coll
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collectionView)
    }
   override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        guard let _ = self.indexPath else{return}
        self.collectionView.scrollToItemAtIndexPath(self.indexPath!, atScrollPosition: .None, animated: false)
    }
}
extension photoBrowserController:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        guard let _ = self.currentAblum else{return selectedImages.count}
        return (currentAblum?.imageCount)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell:PhotoBigCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoBigCell", forIndexPath: indexPath) as! PhotoBigCell
        cell.backgroundColor = randomColor()
        if let _ = self.currentAblum{
            PhotoUtil.sharedPhotoUtil.getImageFrom(self.currentAblum!.assets![indexPath.row].asset, mode: .None, quality: .hight, expectSize:nil, complement: { (image,_) -> () in
                cell.image = image
            })
        }else{
            PhotoUtil.sharedPhotoUtil.getImageFrom(selectedImages[indexPath.row].asset, mode: .None, quality: .hight, expectSize:nil, complement: { (image,_) -> () in
                cell.image = image
            })
            
        }
        return cell
    }
}