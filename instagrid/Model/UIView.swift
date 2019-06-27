//
//  UIView.swift
//  instagrid
//
//  Created by SayajinPapuru on 20/06/2019.
//  Copyright © 2019 sayajin papuru. All rights reserved.
//

import UIKit

extension UIView {
    func convertToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}
