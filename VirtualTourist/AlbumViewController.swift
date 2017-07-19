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
import CoreData

class AlbumViewController: UIViewController, UICollectionViewDelegate {
    
    // MARK: Properties
    
    var album: Album!
    var photos: [Photo]?
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var loadingSpiner: UIView!
    var buttonNewCollection: UIButton?
    var noImagesLabel: UILabel?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context: NSManagedObjectContext = self.appDelegate.stack.context
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Add annotation to the map and focus on it
        if let album = album {
            let annotation = getAnnotationFromPin(album: album)
            mapView.addAnnotation(annotation)
            focus(mapView: mapView, location: annotation.coordinate)
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        navigationController?.isNavigationBarHidden = false
        
        retrieveNewImages()
      
    }
    
    fileprivate func retrieveNewImages() {
        loadingSpiner.isHidden = false
        
        self.getPhotos({
            (photos:[Photo]) in
            
            UIView.transition(with: self.loadingSpiner, duration: TimeInterval(0.5), options: UIViewAnimationOptions.transitionCrossDissolve, animations: {}, completion: {(finished: Bool) -> () in })
            
            self.loadingSpiner.isHidden = true
            self.collectionView.reloadData()
        });
    }

    fileprivate func getPhotos(_ completionHandler: @escaping (_ photos: [Photo]) -> Void){
        if(photos != nil && (photos?.count)! > 0) {
            completionHandler(photos!)
        } else {
            //TODO: Get coordinates from Album dictionary
            VTClient.getPhotosLocation(album: album, completionHandler: { (urls:[String]?) in
                DispatchQueue.main.async(execute: {
                    var photos = [Photo]()
                    
                    for url in urls! {
                        let photo = Photo(url: url, context: self.context)
                        photo.album = self.album
                        photos.append(photo)
                    }
                    try! self.context.save()
                    completionHandler(photos)
                });
            })
        }
    }
    

    
    // MARK: Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if album.photos == nil {
            return 0
        } else {
            return album.photos!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        
        let imageUrl = URL(string: self.photos![indexPath.item].url!)
        
        
        self.executeOnMain {
            let image = UIImage(data: try! Data(contentsOf: imageUrl!))
    
            self.executeOnMain {
                if let updateCell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
                    updateCell.imageView.image = image
                
                    UIView.transition(with: cell.loadingSpiner, duration: TimeInterval(0.4), options: UIViewAnimationOptions.transitionCrossDissolve, animations: {}, completion: {(finished: Bool) -> () in })
                    updateCell.loadingSpiner.isHidden = true
                    
                    if self.buttonNewCollection != nil {
                        self.buttonNewCollection!.isEnabled = self.allImagesLoaded
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let newCollection = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
        
        self.buttonNewCollection = newCollection.subviews[0] as? UIButton
        self.noImagesLabel = newCollection.subviews[1] as? UILabel
        
        if album.photos != nil && album.photos!.count > 0 {
            noImagesLabel?.isHidden = true
            buttonNewCollection?.isHidden = false
        } else {
            noImagesLabel?.isHidden = false
            buttonNewCollection?.isHidden = true
        }
        
        return newCollection
    }
    
    // MARK: Helper Methods
    
    fileprivate var allImagesLoaded: Bool {
        var loaded = true
        
        for photo in album.photos! {
            let imageId = (photo as AnyObject).objectID.uriRepresentation().lastPathComponent
            
        }
        
        return loaded
    }
    

    
    // MARK: IBActions
    
    @IBAction func newCollection() {
        self.removeAllPhotos()
        retrieveNewImages()
    }
    

    
    
    // MARK: Remove Photos
    
    func removeAllPhotos(){
        while (photos!.count > 0) {
            photos![0].album = nil
        }
    }


}
