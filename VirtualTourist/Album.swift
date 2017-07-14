//
//  Album.swift
//  VirtualTourist
//
//  Created by J B on 7/6/17.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import MapKit
import CoreData


@objc(Album)
class Album: NSManagedObject, MKAnnotation {
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var photos: [Photo]?
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(coordinate: CLLocationCoordinate2D, context: NSManagedObjectContext){
        let entity =  NSEntityDescription.entity(forEntityName: "Album", in: context)!
        super.init(entity:entity, insertInto: context)
        self.longitude = Double(coordinate.longitude)
        self.latitude = Double(coordinate.latitude)
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        return "\(objectID)"
    }
    
    func getPhotos(_ completionHandler: @escaping (_ photos: [Photo]) -> Void){
        if(photos != nil && (photos?.count)! > 0) {
            //Return photos from the shared data
            completionHandler(photos!)
        } else {
            //Return photos from the API
            VTClient.getPhotosLocation(coordinate, completionHandler: { (urls:[String]?) in
                DispatchQueue.main.async(execute: {
                var photos = [Photo]()
                
                for url in urls! {
                    let photo = Photo(url: url, context: self.sharedContext)
                    photo.album = self
                    photos.append(photo)
                }
                    try! self.sharedContext.save()
                    completionHandler(photos)
                });
            })
        }
    }

    fileprivate var apiClient : VTClient {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.apiClient
    }
    
    fileprivate var sharedContext: NSManagedObjectContext {
        let appDeleate = UIApplication.shared.delegate as! AppDelegate
        return appDeleate.managedObjectContext!
    }
    
    func removeAllPhotos(){
        while (photos!.count > 0) {
            photos![0].album = nil
        }
    }
    

}
