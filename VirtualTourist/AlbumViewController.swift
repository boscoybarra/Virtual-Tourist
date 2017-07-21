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
    @IBOutlet weak var loadingSpiner: UIView!
    var buttonNewCollection: UIButton?
    var noImagesLabel: UILabel?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext = self.appDelegate.stack.context
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Zoom to Pin
        if let pin = pin {
            let annotation = getAnnotationFromPin(pin: pin)
            mapView.addAnnotation(annotation)
            zoom(mapView: mapView, location: annotation.coordinate)
        }
    }
    
    
    func setupPhotoAlbum() {
        // Setup Button and TextField
            let photoAlbums = pin?.album?.allObjects as! [Album]
            album = photoAlbums[0]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingSpiner.isHidden = false
        
        setupPhotoAlbum()
        
        let photoCount = Int((album?.total)!)
        
        guard photoCount > 0 else {
            self.presentErrorAlertController("No Photos!", alertMessage: "Sorry we have no photos for this area")
            return
        }
 
        getNewPhotos()
      
    }
    

    fileprivate func getNewPhotos() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        
        do {
            photos = try context.fetch(fetchRequest)
            
            if album!.photos!.count != Int((album?.total)!) {
                VTClient.getPhotosLocation(pin: pin!, completionHandler: createPhotosFromURLs)
            }
            collectionView.reloadData()
        } catch {
            DispatchQueue.main.async(){
            print("Failed to get Photos")
            print(error.localizedDescription)
            self.presentErrorAlertController("Oops!", alertMessage: "There was an error loading your photos")
            }
        }
    }

    
    // MARK:- Core Data Function
    
    
    
    func createPhotosFromURLs(urls: [String]?, error: Error?) {
        guard error == nil else {
            self.presentErrorAlertController("There was an error when loading photo from Server", alertMessage: "There was an error dowloading the photos from selected pin.")
            return
        }
        
        let minNumberOfPhotos = min(20, urls!.count)
        let randomURLs = urls!.choose(Int(minNumberOfPhotos))
        
        
        for url in randomURLs {
            
            album!.total = Int16(minNumberOfPhotos)
            
            let photo = Photo(url: url, context: context)
            photo.album = album
            photos.append(photo)
        }
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        UIView.transition(with: self.loadingSpiner, duration: TimeInterval(0.4), options: UIViewAnimationOptions.transitionCrossDissolve, animations: {}, completion: {(finished: Bool) -> () in })
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
