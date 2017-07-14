//
//  VCMapView.swift
//  VirtualTourist
//
//  Created by J B on 7/11/17.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.animatesDrop = true
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .system)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedAlbum = view.annotation as? Album
        performSegue(withIdentifier: "segueToAlbum", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToAlbum") {
            let destinationController = segue.destination as? AlbumViewController
            destinationController!.album = selectedAlbum
            deselectAllAnnotations()
        }
    }
    
    func deselectAllAnnotations(){
        
        let selectedAnnotations = mapView.selectedAnnotations
        
        for annotation in selectedAnnotations {
            mapView.deselectAnnotation(annotation, animated: false)
        }
    }
    
    
}
