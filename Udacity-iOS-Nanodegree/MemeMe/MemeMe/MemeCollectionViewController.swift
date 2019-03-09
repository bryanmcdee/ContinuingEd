//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Bryan McDonald on 7/19/15.
//  Copyright (c) 2015 Bryan McDonald. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var memeCollectionView: UIImageView!
    
    var memes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.memes = appDelegate.memes
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //deque a cell and prepare it fora new cell.
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        let currentMeme = self.memes[indexPath.row]
        cell.memeImageView?.image = currentMeme.memedImage
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("memeDetailViewController") as! MemeDetailViewController
        let meme = self.memes[indexPath.row]
        detailController.memedImage = meme.memedImage
        detailController.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    @IBAction func createNewMeme(sender: AnyObject) {
        let createMemeViewController:CreateMemeViewController
        createMemeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("createMemeViewController") as! CreateMemeViewController
        self.presentViewController(createMemeViewController, animated: true, completion: nil)
    }
    
}