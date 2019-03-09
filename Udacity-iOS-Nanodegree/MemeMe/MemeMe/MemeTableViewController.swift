//
//  SentMemesColloctionViewController.swift
//  MemeMe
//
//  Created by Bryan McDonald on 7/19/15.
//  Copyright (c) 2015 Bryan McDonald. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme]!
     @IBOutlet var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.memes = appDelegate.memes
        //Reaload the table so new memes will appear
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createNewMeme(sender: AnyObject) {
        let createMemeViewController:CreateMemeViewController
        createMemeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("createMemeViewController") as! CreateMemeViewController
        self.presentViewController(createMemeViewController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell") as! UITableViewCell
        let meme = self.memes[indexPath.row]
        var memeText = ""
        // Set the name and image
        if let topText = meme.topText {
            memeText += topText
        }
        if let bottomText = meme.bottomText {
            memeText += " " + bottomText
        }
        
        cell.textLabel?.text = memeText
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 60.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("memeDetailViewController") as! MemeDetailViewController
        let meme = self.memes[indexPath.row]
        detailController.memedImage = meme.memedImage
        detailController.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}