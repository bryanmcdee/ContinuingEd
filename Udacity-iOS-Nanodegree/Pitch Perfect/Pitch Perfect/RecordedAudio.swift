//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Bryan McDonald on 5/30/15.
//  Copyright (c) 2015 Bryan McDonald. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    let filePathUrl: NSURL!
    let title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}
