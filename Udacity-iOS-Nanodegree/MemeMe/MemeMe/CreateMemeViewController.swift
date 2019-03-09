//
//  ViewController.swift
//  MemeMe
//
//  Created by Bryan McDonald on 7/18/15.
//  Copyright (c) 2015 Bryan McDonald. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var buttonShare: UIBarButtonItem!
    @IBOutlet weak var buttonCancel: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        //Enable the camera button if the device has a camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        //Set the textfield attributes
        setDefaultTextFieldAttributes()
        //Subscribe to keyboard notifcations so the view can slide out of the way of the keyboard
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //Unsubscribe from keyboard notifications so the view will slide back into place after 
        //the keyboard is dismissed
        self.unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableShareButton()
        //Set the text in the textfields
        setDefaultTextFieldText()
        //Set the textfields delegates
        self.textTop.delegate = self
        self.textBottom.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Sets the default text in the textfields
    func setDefaultTextFieldText(){
        textTop.text = MemeTextField.topDefaultText
        textBottom.text = MemeTextField.bottomDefaultText
    }
    
    //Sets the textfield attributes
    func setDefaultTextFieldAttributes(){
        textTop.defaultTextAttributes = MemeTextField.attributes
        textTop.textAlignment = NSTextAlignment.Center
        textBottom.defaultTextAttributes = MemeTextField.attributes
        textBottom.textAlignment = NSTextAlignment.Center
    }
    
    //Presents the image picker
    @IBAction func pickAnImageFromAlbum(sender: AnyObject){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Launch the camera
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = newImage
            enableShareButton()
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // TextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == MemeTextField.topDefaultText || textField.text == MemeTextField.bottomDefaultText) {
            textField.text = ""
        }
    }
    
    //Dismis the keyboard on return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Dismis the keyboard on touch outside the keyboard
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    //Shift the view so the keyboard does not cover the text
    func keyboardWillShow(notification: NSNotification) {
        if textBottom.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //Shift the view down after the keyboard is hidden
    func keyboardWillHide(notification: NSNotification) {
        if textBottom.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    //Get keyboard height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        if let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue{ // of CGRect
            return keyboardSize.CGRectValue().height
        } else {
            return 0
        }
    }
    
    //subscribe to keyboard notification
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:" , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Unsubscribe to keyboard notification
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Activity View Controller
    @IBAction func showActivityViewer(){
        let image = UIImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(){
        //Generate a memed image
        var newMemeImage: UIImage = generateMemedImage()
        
        //Define an instance of the ActivityViewController
        //Pass the ActivityViewController a memedImage as an activity item
        var activityViewController = UIActivityViewController(activityItems: [newMemeImage], applicationActivities: nil)
        
        
        //Save the meme when the ActivityViewController is finished
        activityViewController.completionWithItemsHandler = {(actvityType, completed, returnedItems, activityError) in
            //Don't proceed if the user cancels
            if (!completed){
                return
            }

            self.save()
            
            //dismiss the acitivityViewController
            activityViewController.dismissViewControllerAnimated(true, completion: nil)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        //Present the ActivityViewController
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func save(){
        //Create the meme
        if let newImage = imageView.image {
            var meme = Meme(topText: textTop.text, bottomText: textBottom.text, originalImage: newImage, memedImage: getNewMemeImage())
            
            //Add the new meme to the array of memes
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.memes.append(meme)
        }
    }
    
    func getNewMemeImage() -> UIImage {
        hideToolbars()
        var memedImage: UIImage = generateMemedImage()
        showToolbars()
        return memedImage
    }
    
    //Generate a Meme image from the image and text fields from the view
    func generateMemedImage() -> UIImage
    {
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    func hideToolbars(){
        navBar.hidden = true
        toolBar.hidden = true
    }
    
    func showToolbars(){
        navBar.hidden = false
        toolBar.hidden = false
    }
    
    func enableShareButton(){
        if imageView.image != nil {
            buttonShare.enabled = true
        } else {
            buttonShare.enabled = false
        }
    }
    
    //Dismisses the activty view controller when cancel is pressed
    @IBAction func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

