//
//  AlbumViewController.swift
//  VirtualTourist
//
//  Created by J B on 07/01/16.
//  Copyright © 2017 J B. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AlbumViewController: UIViewController {
    
    // MARK: Properties
    
    var album: Album?
    var photos = [Photo]()
    var pin: Pin?
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var loadingSpiner: UIView!
    var buttonNewCollection: UIButton?
    var noImagesLabel: UILabel?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext = self.appDelegate.stack.context
    let reuseIdentifier = "photoCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self as UICollectionViewDelegate
        
        // Zoom to Pin
        if let pin = pin {
            let annotation = getAnnotationFromPin(pin: pin)
            mapView.addAnnotation(annotation)
            zoom(mapView: mapView, location: annotation.coordinate)
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        getNewPhotos()
      
    }
    

   fileprivate func getNewPhotos() {
        //loadingSpiner.isHidden = false
 
                VTClient.getPhotosLocation(pin: pin!, completionHandler: createPhotosFromURLs)
                
                UIView.transition(with: self.loadingSpiner, duration: TimeInterval(0.5), options: UIViewAnimationOptions.transitionCrossDissolve, animations: {}, completion: {(finished: Bool) -> () in })
    
                
    
                
    
}

    
    // MARK:- Core Data Function
    
    func createPhotosFromURLs(urls: [String]?, error: Error?) {
        guard error == nil else {
            self.presentErrorAlertController("There was an error when loading photo from Server", alertMessage: "There was an error dowloading the photos from selected pin.")
            return
        }
        
        let randomURLs = urls!
        
        for url in randomURLs {
            
            let photo = Photo(url: url, context: context)
            photo.album = album
            photos.append(photo)
        }
        self.loadingSpiner.isHidden = true
        collectionView.reloadData()
    }
    
    

    // MARK: IBActions
    
    @IBAction func newCollection() {
        self.removeAllPhotos()
        getNewPhotos()
    }
    

    
    
    // MARK: Remove Photos
    
    func removeAllPhotos(){
        while (photos.count > 0) {
            photos[0].album = nil
        }
    }


}
