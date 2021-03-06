//
//  Photo+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by J B on 7/28/17.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var url: String?
    @NSManaged public var creationDate: NSDate?
    @NSManaged public var album: Album?

}
