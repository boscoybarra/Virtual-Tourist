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

class AlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Properties
    
    var album: Album!
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var loadingSpiner: UIView!
    var buttonNewCollection: UIButton?
    var noImagesLabel: UILabel?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.addAnnotation(album)
        mapView.showAnnotations([album], animated: true)
        
        navigationController?.isNavigationBarHidden = false
        
        retrieveNewImages()
      
    }
    
    fileprivate func retrieveNewImages() {
        loadingSpiner.isHidden = false
        
        album.getPhotos({
            (photos:[Photo]) in
            
            UIView.transition(with: self.loadingSpiner, duration: TimeInterval(0.5), options: UIViewAnimationOptions.transitionCrossDissolve, animations: {}, completion: {(finished: Bool) -> () in })
            
            self.loadingSpiner.isHidden = true
            self.collectionView.reloadData()
        });
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
        
        let imageUrl = URL(string: album.photos![indexPath.item].url)
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
            let imageId = photo.objectID.uriRepresentation().lastPathComponent
            
            if AppDelegate.Cache.imageCache.imageWithIdentifier(imageId) == nil {
                loaded = false
            }
        }
        
        return loaded
    }
    

    
    // MARK: IBActions
    
    @IBAction func newCollection() {
        album.removeAllPhotos()
        retrieveNewImages()
    }
    
    // MARK: Shared Context
    
    fileprivate var sharedContext: NSManagedObjectContext {
        let appDeleate = UIApplication.shared.delegate as! AppDelegate
        return appDeleate.managedObjectContext!
    }


}
