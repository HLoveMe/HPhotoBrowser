//
//  constant.swift
//  PhotoBrowser
//
//  Created by space on 16/2/2.
//  Copyright © 2016年 Space. All rights reserved.
//

import UIKit


/**得到屏幕宽*/
let  screenWidth:CGFloat = UIScreen.mainScreen().bounds.width
/**得到屏幕高*/
let  screenHeight:CGFloat = UIScreen.mainScreen().bounds.height

/**得到随机颜色*/
func  randomColor() ->UIColor {
    let red = Float(arc4random_uniform(256)) / 255.0
    let green = Float(arc4random_uniform(256)) / 255.0
    let blue = Float(arc4random_uniform(256)) / 255.0
    return UIColor.init(colorLiteralRed: red, green: green, blue: blue, alpha: 1.0)
}

extension CGRect{
    func X() ->CGFloat{
        return self.origin.x
    }
    func getX() ->CGFloat{
        return self.origin.x
    }
    mutating func setX(x:CGFloat){
        self = CGRectMake(x,self.origin.y, width, height)
    }
    
    func Y() ->CGFloat{
        return self.origin.y
    }
    func getY() ->CGFloat{
        return self.origin.y
    }
    mutating func setY(Y:CGFloat){
        self = CGRectMake(self.origin.x,Y, width, height)
    }
}

/**为UIView做扩展*/
extension UIView{
    /**size*/
    var size:CGSize {
        get{
            return self.frame.size
        }
        set{
            var rect:CGRect = self.frame
            rect.size = newValue
            self.frame = rect
        }
        
    }
    /**width*/
    var width:CGFloat {
        get{
            return  self.bounds.size.width
        }
        set{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newValue, self.frame.size.height)
        }
    }
    /**height*/
    var height:CGFloat {
        get{
            return  self.bounds.size.height
        }
        set{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,self.frame.size.width,newValue)
        }
    }
    /**center*/
    var centerH:CGPoint{
        get{
            return self.center
        }
        set{
            self.frame = CGRectMake(newValue.x - self.width * 0.5, newValue.y - self.height * 0.5 ,self.width,self.height)
        }
    }
    /**origin*/
    var origin:CGPoint{
        get{
            return self.frame.origin
        }
        set{
            var rect:CGRect = self.frame
            rect.origin = newValue
            self.frame = rect
        }
        
    }
    /** x */
    var x:CGFloat{
        get{
            return self.origin.x
        }
        set{
            var rect:CGRect = self.frame
            rect.origin = CGPointMake(newValue, rect.origin.y)
            self.frame = rect
        }
    }
    /** y */
    var y:CGFloat{
        get{
            return self.origin.y
        }
        set{
            var rect:CGRect = self.frame
            rect.origin = CGPointMake(rect.origin.x,newValue)
            self.frame = rect
        }
    }
    
    /**MaxX*/
    var MaxX:CGFloat {
        get{
            return CGRectGetMaxX(self.frame)
        }
        set{
            var rect:CGRect = self.frame
            rect.origin = CGPointMake(newValue - self.width, rect.origin.y)
            self.frame = rect
        }
    }
    /**MaxY*/
    var MaxY:CGFloat{
        get{
            return CGRectGetMaxY(self.frame)
        }
        set{
            var rect:CGRect = self.frame
            rect.origin = CGPointMake(rect.origin.x,newValue - self.height)
            self.frame = rect
        }
    }
    /**下标*/
    subscript(des:String) ->CGFloat{
        get{
            let str = des.lowercaseString
            switch str{
            case "x":
                return self.x
            case "y":
                return self.y
            case "w","wid","width","宽":
                return self.width
            case "h","hei","height","高":
                return self.height
            default:
                return 0
            }
        }
        set{
            let str = des.lowercaseString
            switch str{
            case "x":
                self.x =  newValue
            case "y":
                self.y = newValue
            case "w","wid","width","宽":
                self.width = newValue
            case "h","hei","height","高":
                self.height = newValue
            default:
                break
            }
        }
    }
}
extension UIImage{
    static func getImageByColor(color:UIColor)->UIImage{
        UIGraphicsBeginImageContext(CGSizeMake(1, 1))
        color.setFill()
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, 1, 1))
        let temp = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return temp
    }
}