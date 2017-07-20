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
        fetchPins()
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
        
        print("Latitude in da house",latitude, "Longitude in da house", longitude)
        let albumPin = Pin(latitude: latitude, longitude: longitude, context: context)
        let album = Album(name: "Photo Album 0", context: context)
        album.pin = albumPin
        self.addPinToMap(pin: albumPin)
    }
    
    func fetchPins() {
        let pinsFetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        
        do {
            let pins = try context.fetch(pinsFetchRequest)
            loadPinsOntoMap(pins: pins)
        } catch {
            print("Failed to get Pins")
            print(error.localizedDescription)
            self.presentErrorAlertController("Oops!", alertMessage: "There was an error loading your existing pins")
        }
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
    
    func addPinToMap(pin: Pin) {
        print("Lat:\(pin.latitude) - lon:\(pin.longitude)")
        self.mapView.addAnnotation(getAnnotationFromPin(pin: pin))
    }
    
    func loadPinsOntoMap(pins: [Pin]) {
        removeAnnotations(mapView: mapView)
        
        let _ = pins.map { addPinToMap(pin: $0) }
    }
    
    
    func deselectAllAnnotations(){
        
        let selectedAnnotations = mapView.selectedAnnotations
        
        for annotation in selectedAnnotations {
            mapView.deselectAnnotation(annotation, animated: false)
        }
    }
    
    // MARK:- Segue preparation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAlbum" {
            let vc = segue.destination as! AlbumViewController
            if let annotation = selectedAnnotation as? MKVirtualTouristAnnotation {
                vc.pin = annotation.pin
            }
        }
    }
    
}

