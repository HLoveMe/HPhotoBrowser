//
//  PhotoBigCell.swift
//  PhotoBrowser
//
//  Created by space on 16/2/4.
//  Copyright © 2016年 Space. All rights reserved.
//

import UIKit

var Mar:CGFloat = 12


class PhotoBigCell: UICollectionViewCell {
    lazy var imageV:UIImageView = {UIImageView()}()
    var image:UIImage?{
        didSet{
            guard let _ = image else {return}
            imageV.image = image
            self.setNeedsLayout()
        }
    }
   override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.imageV)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let rect:CGRect = self.bounds
        self.imageV.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.width-Mar, rect.height)
    }
   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
}
