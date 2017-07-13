//
//  Album.swift
//  VirtualTourist
//
//  Created by J B on 7/6/17.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Album: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    var photos: [Photo]?
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
    
//    class func fromJSON(json: [JSONValue]) -> Album? {
//        // 1
//        var title: String
//        if let titleOrNil = json[16].string {
//            title = titleOrNil
//        } else {
//            title = ""
//        }
//        let locationName = json[12].string
//        
//        // 2
//        let latitude = (json[18].string! as NSString).doubleValue
//        let longitude = (json[19].string! as NSString).doubleValue
//        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        
//        // 3
//        return Album(title: title, coordinate: coordinate)
//    }
    

}