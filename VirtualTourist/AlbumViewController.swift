//
//  AlbumViewController.swift
//  VirtualTourist
//
//  Created by J B on 07/01/16.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AlbumViewController: UIViewController {
    
    // MARK: Properties
    
    var album: Album!
    var photos: [Photo]?
    
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var loadingSpiner: UIView!
    var btnNewCollection: UIButton?
    var lblNoImages: UILabel?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.addAnnotation(album)
        mapView.showAnnotations([album], animated: true)
        
        navigationController?.isNavigationBarHidden = false
        
        retrieveNewImages()
      
    }
    
    fileprivate func retrieveNewImages() {
        loadingSpiner.isHidden = false
        
        VTClient.getPhotosLocation(album.coordinate) { (photos) in
            if let photos = photos {
                //self.photos = photos
//                self.executeOnMain {
//                    //self.moviesTableView.reloadData()
//                }
            } else {
                //print(error ?? "empty error")
            }
        }
        
    
    }


}
