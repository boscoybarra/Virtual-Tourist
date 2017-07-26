//
//  Album+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by J B on 7/26/17.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import CoreData


extension Album {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Album> {
        return NSFetchRequest<Album>(entityName: "Album")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var total: Int16
    @NSManaged public var photos: NSSet?
    @NSManaged public var pin: Pin?

}

// MARK: Generated accessors for photos
extension Album {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
