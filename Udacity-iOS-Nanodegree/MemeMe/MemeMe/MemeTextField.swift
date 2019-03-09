//
//  TextFieldAttributes.swift
//  MemeMe
//
//  Created by Bryan McDonald on 7/18/15.
//  Copyright (c) 2015 Bryan McDonald. All rights reserved.
//

import Foundation
import UIKit

struct MemeTextField {
    static let topDefaultText = "TOP"
    static let bottomDefaultText = "BOTTOM"
    
    static let attributes = [
        NSStrokeWidthAttributeName: -3.0,
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
    ]
}