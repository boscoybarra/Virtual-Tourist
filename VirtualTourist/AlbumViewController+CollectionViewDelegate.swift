//
//  AlbumViewController+CollectionViewDelegate.swift
//  VirtualTourist
//
//  Created by J B on 7/19/17.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import UIKit

extension AlbumViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if album.photos == nil {
            return 0
        } else {
            return album.photos!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(photoAlbum!.total)
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
}

extension PhotoAlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item Selected")
        
        let row = indexPath.row
        
        if row >= photos.count {
            let alertController = UIAlertController(title: photoAlbum!.name, message: "Image still loading", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let photo = photos[row]
            photos.remove(at: row)
            context.delete(photo)
            appDelegate.coreDataStack.save()
            photoAlbum?.total -= 1
            collectionView.reloadData()
        }
        
        
    }
}

