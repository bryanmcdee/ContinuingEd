//
//  DetailViewController.swift
//  Project1
//
//  Created by Bryan McDonald on 7/25/15.
//  Copyright (c) 2015 Bryan McDonald. All rights reserved.
//

import UIKit
import Social

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
        
        var facebookIcon: UIImage = UIImage(named: "Facebook")!
        var twitterIcon: UIImage = UIImage(named: "Twitter")!
        
        var facebookButton : UIBarButtonItem = UIBarButtonItem(image: facebookIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "shareToFacebook")
        
        var twitterButton: UIBarButtonItem = UIBarButtonItem(image: twitterIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "shareToTwitter")
        
        var buttons : NSArray = [facebookButton, twitterButton]
        
        navigationItem.rightBarButtonItems = buttons as [AnyObject]
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func shareToFacebook() {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        share(vc)
    }
    
    @IBAction func shareToTwitter() {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        share(vc)
    }
    
    func share(vc: SLComposeViewController){
        vc.setInitialText("Look at this great picture!")
        vc.addImage(imageView.image!)
        vc.addURL(NSURL(string: "http://www.photolib.noaa.gov/nssl"))
        presentViewController(vc, animated: true, completion: nil)
    }

}

