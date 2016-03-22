//
//  HToolView.swift
//  PhotoBrowser
//
//  Created by space on 16/2/3.
//  Copyright © 2016年 Space. All rights reserved.
//

import UIKit
@objc protocol ToolViewDelegate:NSObjectProtocol{
   optional func previewClick(toolView:HToolView,button:UIButton);
   optional func sureClick(toolView:HToolView,button:UIButton);
}
class HToolView: UIView {
    @IBOutlet var previewButton: UIButton!
    @IBOutlet var imageCountLab: UILabel!
    @IBOutlet var sureButton: UIButton!
    weak var delegate:ToolViewDelegate?
    static func toolView()->HToolView{
        let one = NSBundle.mainBundle().loadNibNamed("HToolView", owner: nil, options: nil).last as! HToolView
        one.sureButton.layer.cornerRadius = 5 
        one.sureButton.layer.masksToBounds = true
        return one
    }
    @IBAction func previewClick(sender: UIButton) {
        if let _ = delegate{
            if self.delegate!.respondsToSelector("previewClick:button:"){
                self.delegate!.previewClick!(self, button: sender)
            }
        }
    }
    @IBAction func sureClick(sender: UIButton) {
        if let _ = delegate{
            if self.delegate!.respondsToSelector("sureClick:button:"){
            self.delegate!.sureClick!(self, button: sender)
            }
        }
    }
}
