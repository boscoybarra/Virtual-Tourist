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
    var albums = [Album]()
    var pins = [Pin]()
  
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var collectionView: UICollectionView!
    var buttonNewCollection: UIButton?
    var noImagesLabel: UILabel?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext = self.appDelegate.stack.context
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Zoom to Pin
        if let pin = pin {
            let annotation = getAnnotationFromPin(pin: pin)
            mapView.addAnnotation(annotation)
            zoom(mapView: mapView, location: annotation.coordinate)
        }
        
       //  Create a fetchrequest
            let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
            fr.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false),
                                          NSSortDescriptor(key: "creationDate", ascending: false)]
        
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        setupPhotoAlbum()
        
        let photoCount = Int((album?.total)!)
        
        guard photoCount > 0 else {
            self.presentErrorAlertController("No Photos!", alertMessage: "Sorry we have no photos for this area")
            return
        }
        
        getNewPhotos()
            
    }
    
    func setupPhotoAlbum() {

        
        let photoAlbums = pin?.albums?.allObjects as! [Album]
        album = photoAlbums[0]
    }
    

    fileprivate func getNewPhotos() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Photo.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let predicate = NSPredicate(format: "album = %@", argumentArray: [album!])
        fetchRequest.predicate = predicate
        
        do {
            photos = try context.fetch(fetchRequest) as! [Photo]
            
            if (album?.photos!.count)! != Int((album?.total)!) {
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
            
            album?.total = Int16(minNumberOfPhotos)
            
            let photo = Photo(url: url, context: context)
            photo.album = album
            photos.append(photo)
        }
        
        appDelegate.stack.save()
        
        collectionView.reloadData()
    }
    
    

    // MARK: IBActions
    
    @IBAction func newCollection() {
//        defer {
            removeAllPhotos()
//        }
        getNewPhotos()
    }
    
    
    // MARK: Remove Photos
    
    func removeAllPhotos(){
        for photo in photos {
            context.delete(photo)
        }

        photos = []
    }


}
