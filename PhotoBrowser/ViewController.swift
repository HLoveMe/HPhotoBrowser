//
//  ViewController.swift
//  PhotoBrowser
//
//  Created by space on 16/2/2.
//  Copyright © 2016年 Space. All rights reserved.
//

import UIKit
import Photos
class ViewController: UIViewController {
    var sheet:PreviewSheet?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sheet = PreviewSheet()
        /**程序启动时      不要和 func showPreview 一起调用  提前请求权限*/
        PhotoUtil.requestAuthority()
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       self.sheet!.showPreview(self) { (_: [UIImage]) -> () in
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

