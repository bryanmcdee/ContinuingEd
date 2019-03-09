//
//  ViewController.swift
//  Project2-Guess-the-Flag
//
//  Created by Bryan McDonald on 7/25/15.
//  Copyright (c) 2015 Bryan McDonald. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnFlat1: UIButton!
    @IBOutlet weak var btnFlag2: UIButton!
    @IBOutlet weak var btnFlag3: UIButton!
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAttributes()
        addCountiesToArray()
        askQuestion(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setButtonAttributes(){
        btnFlat1.layer.borderWidth = 1
        btnFlag2.layer.borderWidth = 1
        btnFlag3.layer.borderWidth = 1
        btnFlat1.layer.borderColor = UIColor.lightGrayColor().CGColor
        btnFlag2.layer.borderColor = UIColor.lightGrayColor().CGColor
        btnFlag3.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    
    func addCountiesToArray(){
        self.countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    }
    
    func askQuestion(action: UIAlertAction!) {
        countries.shuffle()
        
        //Set button images
        btnFlat1.setImage(UIImage(named: countries[0]), forState: .Normal)
        btnFlag2.setImage(UIImage(named: countries[1]), forState: .Normal)
        btnFlag3.setImage(UIImage(named: countries[2]), forState: .Normal)
        
        //Set the correct answer to 0, 1, or 2
        var correctAnswer = Int(arc4random_uniform(3))
        
        title = countries[correctAnswer].uppercaseString
    }

    @IBAction func btnFlagTapped(sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            ++score
        } else {
            title = "Wrong"
            --score
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .Default, handler: askQuestion))
            presentViewController(ac, animated: true, completion: nil)
        
    }
}

