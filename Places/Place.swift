//
//  Place.swift
//  Places
//
//  Created by James Rochabrun on 1/9/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class Place: NSManagedObject {

    @NSManaged var name : String
    @NSManaged var type : String
    @NSManaged var location : String
    @NSManaged var image: NSData?
    @NSManaged var phone : String?
    @NSManaged var web : String?
    @NSManaged var rating : String?
    
}
