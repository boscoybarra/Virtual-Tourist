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
    var albums: [Album]?
    let annotation = MKPointAnnotation()
    let coordinate = CLLocationCoordinate2D()
   
    
    var sharedContext: NSManagedObjectContext {
        let appDeleate = UIApplication.shared.delegate as! AppDelegate
        return appDeleate.managedObjectContext!
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        annotation.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        mapView.addAnnotation(annotation)
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialLongPressDetector()
    }
    
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }


    func initialLongPressDetector(){
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(_:)))
        
        longPressRecogniser.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecogniser)
    }
    
    func handleLongPress(_ getstureRecognizer : UIGestureRecognizer){
        if getstureRecognizer.state != .began { return }
        
        let touchPoint = getstureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let album = Album(coordinate: touchMapCoordinate, context: sharedContext)
        
        mapView.addAnnotation(album)
    }
    

 

    
    
    
}

