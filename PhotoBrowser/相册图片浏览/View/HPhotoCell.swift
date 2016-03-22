//
//  HPhotoCell.swift
//  PhotoBrowser
//
//  Created by space on 16/2/2.
//  Copyright © 2016年 Space. All rights reserved.
//

import UIKit
import Photos

class HPhotoCell:UICollectionViewCell {
    var  asset:HAsset?{
        didSet{
            guard let _ = asset else {return}
            self.cell_But.selected = selectedImages.map({ (one) -> String in
                one.ID
            }).contains(asset!.ID)
            PhotoUtil.sharedPhotoUtil.getImageFrom(asset!.asset, mode: .None, quality:Quality.medium, expectSize: CGSizeMake(self.size.width * 1.5, self.size.height * 1.5)) { (image,_) -> () in
                    self.imageV.image = image
            }
        }
    }
    @IBOutlet var cell_But: UIButton!{
        didSet{
            cell_But.setImage(UIImage(named: "btn_selected"), forState: .Selected)
            cell_But.setImage(UIImage(named: "btn_unselected"), forState: .Normal)
            cell_But.addTarget(self, action: "buttonClick:", forControlEvents: .TouchUpInside)
        }
    }
    @IBOutlet var imageV: UIImageView!{
        didSet{
           imageV.contentMode = UIViewContentMode.ScaleAspectFill
        }
    
    }

    
}
extension HPhotoCell{
    func buttonClick(button:UIButton){
        let one:[String:AnyObject] = ["button":button,"asset":self.asset!]
        NSNotificationCenter.defaultCenter().postNotificationName(SelectNotifacaton, object: one)
    }

}