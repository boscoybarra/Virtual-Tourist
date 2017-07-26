//
//  Photo+CoreDataClass.swift
//  VirtualTourist
//
//  Created by J B on 7/26/17.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    
    convenience init (url: String, context: NSManagedObjectContext){
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context){
            self.init(entity:ent, insertInto: context)
            self.url = url
        } else {
            fatalError("Unable to find Entity name")
        }
        
    }

}
