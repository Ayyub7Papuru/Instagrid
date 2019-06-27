//
//  UIImagePickerController.swift
//  instagrid
//
//  Created by SayajinPapuru on 27/06/2019.
//  Copyright © 2019 sayajin papuru. All rights reserved.
//

import UIKit

extension UIImagePickerController {
    open override var shouldAutorotate: Bool {
        return true
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
}
