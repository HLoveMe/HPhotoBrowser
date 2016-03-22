//
//  photoNavigationController.swift
//  PhotoBrowser
//
//  Created by space on 16/2/2.
//  Copyright © 2016年 Space. All rights reserved.
//

import UIKit
/**相册*/
class photosViewController:UIViewController {
    lazy  var tableView:UITableView = {
        var tableView = UITableView.init(frame:CGRectMake(0,0, self.view.width, self.view.height-64), style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib.init(nibName: "HTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "HTableViewCell")
        return tableView
    }()
    lazy var browser:photoThumbBrowserController = photoThumbBrowserController()
    let phone:phoneAblum =  PhotoUtil.sharedPhotoUtil.getPhonePhotoAblum()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
    }
    deinit{
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
    }
}
extension photosViewController{
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "相册"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消", style: .Plain, target: self, action: "cancel")
         self.navigationController?.navigationBar.setBackgroundImage(UIImage.getImageByColor(UIColor(red: 19/255.0 , green: 153/255.0, blue: 231/255.0, alpha: 1)), forBarMetrics: UIBarMetrics.Default)
    }
    func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension photosViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return  self.phone.ablumCount!
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("HTableViewCell")
        let imageV = cell?.viewWithTag(100) as! UIImageView
        let label = cell?.viewWithTag(200) as! UILabel
        let ablum = self.phone.ablumCollection![indexPath.row]
        label.text = ablum.ablumName! + " (" + "\(ablum.imageCount)" + ")"
        imageV.image = ablum.thumbImage
        imageV.layer.masksToBounds = true
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.browser.currentAblum = self.phone.ablumCollection![indexPath.row]
        self.navigationController?.pushViewController(self.browser, animated: true)
    }
}