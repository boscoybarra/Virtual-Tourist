//
//  AlbumViewController+CollectionViewDataSource.swift
//  VirtualTourist
//
//  Created by J B on 7/19/17.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import UIKit

extension AlbumViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(album!.total)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell

        let row = indexPath.row
        
        if row < photos.count {
            let photo = photos[row]
            if photo.imageData == nil {
               cell.loadingSpiner.startAnimating()
                VTClient.sharedInstance().checkGetRequestData(url: photo.url!, completion: { data, error in
                    print("Loaded picture from url")
                    if let imageData = data {
                        
                        self.performUIUpdatesOnMain {
                            photo.imageData = imageData as NSData
                            cell.imageView.image = UIImage(data: imageData)
                            cell.loadingSpiner.stopAnimating()
                        }
                    }
                })
            } else {
                cell.imageView.image = UIImage(data: photo.imageData! as Data)
                cell.loadingSpiner.stopAnimating()
            }
            
        } else {
            cell.imageView.image = UIImage(named: "Rectangle")
            cell.loadingSpiner.startAnimating()
        }
        
        return cell
    }
        
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let newCollection = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
        
        self.buttonNewCollection = newCollection.subviews[0] as? UIButton
        self.noImagesLabel = newCollection.subviews[1] as? UILabel
        
        if album?.photos != nil && (album?.photos!.count)! > 0 {
            noImagesLabel?.isHidden = true
            buttonNewCollection?.isHidden = false
        } else {
            noImagesLabel?.isHidden = false
            buttonNewCollection?.isHidden = true
        }
        
        return newCollection
    }
    
}



extension AlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item Selected")
        
        let row = indexPath.row
        
        if row >= photos.count {
            let alertController = UIAlertController(title: "Album", message: "Image still loading", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let photo = photos[row]
            photos.remove(at: row)
            context.delete(photo)
            appDelegate.stack.save()
            album?.total -= 1
            collectionView.reloadData()
        }
        
        
    }
}

