//
//  MasterViewController.swift
//  Project1
//
//  Created by Bryan McDonald on 7/25/15.
//  Copyright (c) 2015 Bryan McDonald. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var objects = [String]()
    var images = [UIImage]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let fm = NSFileManager.defaultManager()
        let path = NSBundle.mainBundle().resourcePath!
        let items = fm.contentsOfDirectoryAtPath(path, error: nil)
        
        for item in items as! [String] {
            if item.hasPrefix("nssl") {
                objects.append(item)
                if let image = UIImage(named: item as! String) {
                    images.append(image)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object: (AnyObject) = objects[indexPath.row]
            (segue.destinationViewController as! DetailViewController).detailItem = object
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let object: (AnyObject) = objects[indexPath.row]
        cell.textLabel!.text = (object as! String)
        cell.imageView?.image = images[indexPath.row]
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
}

