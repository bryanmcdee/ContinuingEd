//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Bryan McDonald on 7/20/15.
//  Copyright (c) 2015 Bryan McDonald. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    @IBOutlet weak var memeImageView: UIImageView!
    var memedImage: UIImage!

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Set and scale the image
        self.memeImageView.image = memedImage
        memeImageView.contentMode = .ScaleAspectFill
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}