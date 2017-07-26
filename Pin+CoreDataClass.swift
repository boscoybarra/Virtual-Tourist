//
//  Pin+CoreDataClass.swift
//  VirtualTourist
//
//  Created by J B on 7/26/17.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import CoreData

@objc(Pin)
public class Pin: NSManagedObject {
    
    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        
        if let entity = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
            self.init(entity: entity, insertInto: context)
            self.latitude = latitude
            self.longitude = longitude
        } else {
            fatalError("Unable to find Entity name")
        }
        
    }

}
