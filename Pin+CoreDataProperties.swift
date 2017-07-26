//
//  Pin+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by J B on 7/26/17.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var albums: NSSet?

}

// MARK: Generated accessors for albums
extension Pin {

    @objc(addAlbumsObject:)
    @NSManaged public func addToAlbums(_ value: Album)

    @objc(removeAlbumsObject:)
    @NSManaged public func removeFromAlbums(_ value: Album)

    @objc(addAlbums:)
    @NSManaged public func addToAlbums(_ values: NSSet)

    @objc(removeAlbums:)
    @NSManaged public func removeFromAlbums(_ values: NSSet)

}
