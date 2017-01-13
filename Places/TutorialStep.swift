//
//  TutorialStep.swift
//  Places
//
//  Created by James Rochabrun on 1/13/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit

class TutorialStep: NSObject {
    
    var index = 0
    var heading = ""
    var content = ""
    var image :UIImage!
    
    init(index: Int, heading: String, content: String, image: UIImage) {
        self.index = index
        self.heading = heading
        self.content = content
        self.image = image
    }

}
