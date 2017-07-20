//
//  Util.swift
//  VirtualTourist
//
//  Created by J B on 7/19/17.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import MapKit

func getAnnotationFromPin(pin: Pin) -> MKVirtualTouristAnnotation {
    
    let lat = CLLocationDegrees(pin.latitude)
    let long = CLLocationDegrees(pin.longitude)
    
    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    
    let annotation = MKVirtualTouristAnnotation()
    let albumCount = pin.album!.count
    annotation.title = "\(albumCount) Photo Album\(albumCount == 1 ? "":"s")"
    annotation.coordinate = coordinate
    annotation.pin = pin
    print("This are my annotations", annotation.pin as Any)

    return annotation
    }


func appHasLaunchedBefore() -> Bool {
    if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
        return true
    } else {
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        UserDefaults.standard.synchronize()
        return false
    }
}

func removeAnnotations(mapView: MKMapView) {
    for _annotation in mapView.annotations {
        mapView.removeAnnotation(_annotation)
    }
}

// Focuses a mapview onto a specific Location coordinate

func zoom(mapView: MKMapView, location: CLLocationCoordinate2D) {
    let latitude = CLLocationDegrees(location.latitude)
    let longitude = CLLocationDegrees(location.longitude)
    let latDelta: CLLocationDegrees = 0.5
    let lonDelta: CLLocationDegrees = 0.5
    let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
    let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
    let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
    mapView.setRegion(region, animated: true)
}

func getAnnotationFromCoordinate(coordinate: CLLocationCoordinate2D) -> MKPointAnnotation {
    let lat = CLLocationDegrees(coordinate.latitude)
    let long = CLLocationDegrees(coordinate.longitude)
    
    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    
    return annotation
}
