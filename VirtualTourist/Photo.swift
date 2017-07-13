//
//  Photo.swift
//  VirtualTourist
//
//  Created by J B on 7/6/17.
//  Copyright © 2017 J B. All rights reserved.
//


import Foundation
import CoreData

@objc(Photo)
class Photo: NSManagedObject {
    @NSManaged var url: String
    @NSManaged var album: Album?
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(url: String, context: NSManagedObjectContext){
        let entity =  NSEntityDescription.entity(forEntityName: "Photo", in: context)!
        super.init(entity:entity, insertInto: context)
        self.url = url
    }
}


