//
//  Place.swift
//  Places
//
//  Created by James Rochabrun on 1/9/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit
import Foundation


class Place: NSObject {

    var name = ""
    var type = ""
    var location = ""
    var image: UIImage!
    var telephone = ""
    var web = ""
    var rating = "rating"

    
    init(name: String, type: String, location: String, image: UIImage, telephone: String, web: String ) {
    
        self.name = name
        self.type = type
        self.location = location
        self.image = image
        self.telephone = telephone
        self.web = web
    }
    
}
