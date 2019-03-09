//
//  ViewController.swift
//  FlickFinder
//
//  Created by Bryan McDonald on 7/30/15.
//  Copyright (c) 2015 Bryan McDonald. All rights reserved.
//

import UIKit
import Foundation

let BASE_URL: String = "https://api.flickr.com/services/rest/"
var METHOD_NAME = "flickr.photos.search";
let API_KEY = "";
let SAFE_SEARCH = "1";
let EXTRAS = "url_m";
let FORMAT = "json";
let NO_JSON_CALLBACK = "1";

let BOUNDING_BOX_HALF_WIDTH = 1.0
let BOUNDING_BOX_HALF_HEIGHT = 1.0
let LAT_MIN = -90.0
let LAT_MAX = 90.0
let LON_MIN = -180.0
let LON_MAX = 180.0

let FLICKR_MAX_NUM_IMAGES = 4000
let FLICKR_IMAGES_PER_PAGE = 100
let FLICKR_MAX_NUM_PAGES = 40

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtSearchPhrase: UITextField!
    @IBOutlet weak var txtLatitude: UITextField!
    @IBOutlet weak var txtLongitude: UITextField!
    @IBOutlet weak var btnSearchPhrase: UIButton!
    @IBOutlet weak var btnLatLong: UIButton!
    @IBOutlet weak var lblImageDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    @IBAction func searchByPhrase(){
        lblImageDescription.text = ""
        self.dismissAnyVisibleKeyboards()
        
        if !self.txtSearchPhrase.text.isEmpty {
            self.lblImageDescription.text = "Searching..."
            
        var methodArguments = [
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "text": self.txtSearchPhrase.text,
            "safe_search": SAFE_SEARCH,
            "extras": EXTRAS,
            "format": FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK
        ]
        
        getImageFromFlickrBySearch(methodArguments)
        } else {
            self.lblImageDescription.text = "Please enter a search phrase."
        }
    }
    
    @IBAction func searchByLatLong(){
        lblImageDescription.text = ""
        self.dismissAnyVisibleKeyboards()
        
        
        if !self.txtLatitude.text.isEmpty && !self.txtLongitude.text.isEmpty {
            if validLatitude() && validLongitude() {
                self.lblImageDescription.text = "Searching..."
                
                var BBOX = getBboxString()
        
                var methodArguments = [
                    "method": METHOD_NAME,
                    "api_key": API_KEY,
                    "bbox": BBOX,
                    "safe_search": SAFE_SEARCH,
                    "extras": EXTRAS,
                    "format": FORMAT,
                    "nojsoncallback": NO_JSON_CALLBACK
                ]
        
                getImageFromFlickrBySearch(methodArguments)
            }else {
                if !validLatitude() && !validLongitude() {
                    self.lblImageDescription.text = "Lat/Lon Invalid.\nLat should be [-90, 90].\nLon should be [-180, 180]."
                } else if !validLatitude() {
                    self.lblImageDescription.text = "Lat Invalid.\nLat should be [-90, 90]."
                } else {
                    self.lblImageDescription.text = "Lon Invalid.\nLon should be [-180, 180]."
                }
            }
        } else {
            if self.txtLatitude.text.isEmpty && self.txtLongitude.text.isEmpty {
                self.lblImageDescription.text = "Please enter a lat and long."
            } else if self.txtLatitude.text.isEmpty {
                self.lblImageDescription.text = "Please enter a latitude."
            } else {
                self.lblImageDescription.text = "Please enter a longitude."
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "flickfinder")

        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* ============================================================ */
    
    /* 1 - Dismissing the keyboard */
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    /* 2 - Shifting the keyboard so it does not hide controls */
    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:" , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        lblTitle.text = ""
        imageView.image = nil
        self.view.frame.origin.y -= self.getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        lblTitle.text = "Flick Finder"
        self.view.frame.origin.y += self.getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        if let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue{ // of CGRect
            return keyboardSize.CGRectValue().height
        } else {
            return 0.0
        }
    }
    
    /* ============================================================ */
        /* Check to make sure the latitude falls within [-90, 90] */
        func validLatitude() -> Bool {
            if let latitude : Double? = NSNumberFormatter().numberFromString(self.txtLatitude.text as String)?.doubleValue {
                if latitude < LAT_MIN || latitude > LAT_MAX {
                    return false
                }
            } else {
                return false
            }
            return true
        }
        
        /* Check to make sure the longitude falls within [-180, 180] */
        func validLongitude() -> Bool {
            if let longitude : Double? = NSNumberFormatter().numberFromString(self.txtLongitude.text as String)?.doubleValue {
                if longitude < LON_MIN || longitude > LON_MAX {
                    return false
                }
            } else {
                return false
            }
            return true
        }
        
        func getLatLonString() -> String {
            let latitude = (self.txtLatitude.text as NSString).doubleValue
            let longitude = (self.txtLongitude.text as NSString).doubleValue
            
            return "(\(latitude), \(longitude))"
        }
        
    func getImageFromFlickrBySearch(methodArguments: [String : AnyObject]) {
        /*Initialize session and url */
        /*The session object facilitates the downloading or sending/receiving of data over the network*/
        let session = NSURLSession.sharedSession()
        let urlString = BASE_URL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        /* 4 - Initialize task for getting data */
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                println("Could not complete the request \(error)")
            } else {
                /* 5 - Success! Parse the data */
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                if let photosDictionary = parsedResult.valueForKey("photos") as? [String: AnyObject] {
                    
                    var totalPhotosValue = 0
                    if let totalPhotos = photosDictionary["total"] as? String {
                        totalPhotosValue = (totalPhotos as NSString).integerValue
                    }
                    
                    if totalPhotosValue > 0 {
                        if let photosArray = photosDictionary["photo"] as? [[String: AnyObject]] {
                            let photoIndex = Int(arc4random_uniform(UInt32(photosArray.count)))
                            let photoDictionary = photosArray[photoIndex] as [String: AnyObject]
                            let imageUrlString = photoDictionary["url_m"] as? String
                            let imageTitle = photoDictionary["title"] as? String
                            let imageUrl = NSURL(string: imageUrlString!)
                            
                            if let imageData = NSData(contentsOfURL: imageUrl!){
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.imageView.image = UIImage(data: imageData)
                                    if let title = imageTitle {
                                        self.lblImageDescription.text = title
                                    }
                                })
                            } else {
                                self.lblImageDescription.text = "Image does not exist."
                            }
                        } else {
                            self.lblImageDescription.text = "Can't find photo in the dictionary."
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.imageView.image = nil
                            self.lblImageDescription.text = "No photos found."
                        })
                    }
                } else {
                    self.lblImageDescription.text = "Can't find photo in the returned results."
                }
            }
        }
        
        /* 6 - Execute the task */
        task.resume()
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
    
    func getBboxString() -> String{
        //Flickr api Defaults to -180, -90, 180, 90 if not specified.
        //TODO verify Lat is within -90 to 90 and long is within -180 and 180
        
        let latitude = (self.txtLatitude.text as NSString).doubleValue
        let longitude = (self.txtLongitude.text as NSString).doubleValue
        
        /* Fix added to ensure box is bounded by minimum and maximums */
        let bottom_left_lon = max(longitude - BOUNDING_BOX_HALF_WIDTH, LON_MIN)
        let bottom_left_lat = max(latitude - BOUNDING_BOX_HALF_HEIGHT, LAT_MIN)
        let top_right_lon = min(longitude + BOUNDING_BOX_HALF_HEIGHT, LON_MAX)
        let top_right_lat = min(latitude + BOUNDING_BOX_HALF_HEIGHT, LAT_MAX)
        
        return "\(bottom_left_lon),\(bottom_left_lat),\(top_right_lon),\(top_right_lat)"
    }

}

extension ViewController {
    func dismissAnyVisibleKeyboards() {
        if txtSearchPhrase.isFirstResponder() || txtLatitude.isFirstResponder() || txtLongitude.isFirstResponder() {
            self.view.endEditing(true)
        }
    }
}

