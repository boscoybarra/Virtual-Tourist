//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by J B on 07/01/16.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    // MARK: Properties
    var selectedAlbum : Album?

    let annotation = MKPointAnnotation()
    let coordinate = CLLocationCoordinate2D()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext = self.appDelegate.stack.context
   
    var selectedAnnotation: MKAnnotation?
    var tempAnnotation: MKPointAnnotation?
    
    var deleting = false
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        initialLongPressDetector()
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }


    func initialLongPressDetector() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap(gestureRecognizer:)))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func handleLongTap(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        if gestureRecognizer.state == .began {
            tempAnnotation = getAnnotationFromCoordinate(coordinate: coordinate)
            
            mapView.addAnnotation(tempAnnotation!)
            
        } else if gestureRecognizer.state == .changed {
            tempAnnotation!.coordinate = coordinate
            
        } else if gestureRecognizer.state == .ended {
            mapView.removeAnnotation(tempAnnotation!)
            
            savePin(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
    
    // MARK: Core Data Functions
    
    
    func savePin(latitude: Double, longitude: Double) {
        let albumPin = Album(latitude: latitude, longitude: longitude, context: context)
        print("Latitude in da house",latitude, "Longitude in da house", longitude)
        
        self.mapView.addAnnotation(getAnnotationFromPin(album: albumPin))
    }
    
    // MARK: View User Defaults
    
    func checkMapDefaults() {
        if appHasLaunchedBefore() {
            let coordinate = getCenter()
            mapView.setCenter(coordinate, animated: false)
            zoom(mapView: mapView, location: coordinate)
        } else {
            saveCenter(coordinate: mapView.centerCoordinate)
        }
    }
    
    func getCenter() -> CLLocationCoordinate2D {
        let latitude = UserDefaults.standard.double(forKey: "latitude")
        let longitude = UserDefaults.standard.double(forKey: "longitude")
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func saveCenter(coordinate: CLLocationCoordinate2D) {
        UserDefaults.standard.set(coordinate.latitude, forKey: "latitude")
        UserDefaults.standard.set(coordinate.longitude, forKey: "longitude")
    }
    
    
    func deselectAllAnnotations(){
        
        let selectedAnnotations = mapView.selectedAnnotations
        
        for annotation in selectedAnnotations {
            mapView.deselectAnnotation(annotation, animated: false)
        }
    }
    
}

