//
//  UIImage+Extensions.swift
//  DailyGit
//
//  Created by Vlad Munteanu on 8/12/19.
//  Copyright © 2019 Vlad Munteanu. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    class func roundedRectImageFromImage(image:UIImage,imageSize:CGSize,cornerRadius:CGFloat)->UIImage{
        UIGraphicsBeginImageContextWithOptions(imageSize,false,0.0)
        let bounds=CGRect(origin: CGPoint.zero, size: imageSize)
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
        image.draw(in: bounds)
        let finalImage=UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return finalImage
    }
}
