//
//  Album+CoreDataClass.swift
//  VirtualTourist
//
//  Created by J B on 7/28/17.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import CoreData

@objc(Album)
public class Album: NSManagedObject {
    
    convenience init(name: String, context: NSManagedObjectContext) {
        
        if let entity = NSEntityDescription.entity(forEntityName: "Album", in: context) {
            self.init(entity: entity, insertInto: context)
            self.name = name
            self.creationDate = Date() as NSDate
        } else {
            fatalError("Unable to find Entity name")
        }
        
    }

}
