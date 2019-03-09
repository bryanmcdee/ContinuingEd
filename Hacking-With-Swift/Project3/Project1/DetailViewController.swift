//
//  DetailViewController.swift
//  Project1
//
//  Created by Bryan McDonald on 7/25/15.
//  Copyright (c) 2015 Bryan McDonald. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let imageView = self.imageView {
                imageView.image = UIImage(named: detail as! String)
            }
        }
    }
    
    //Hide the nav bar to show the image full screen
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    //Show the nav bar
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        //Add a share button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareTapped")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func shareTapped() {
        let vc = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: [])
        presentViewController(vc, animated: true, completion: nil)
    }

}

