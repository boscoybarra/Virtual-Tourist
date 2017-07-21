//
//  VTConvinience.swift
//  VirtualTourist
//
//  Created by J B on 7/6/17.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

// MARK: - VTClient (Convenient Resource Methods)

extension VTClient {
    
    
    //MARK: -- Function GETs the images from Flickr
    
    static func getPhotosLocation(pin:Pin, completionHandler: @escaping PhotoURLsResponse) {
        
        let latitude = pin.latitude
        let longitude = pin.longitude
        let bbox = VTClient.bboxString(latitude, long: longitude)
        
            let methodParameters = [
                Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
                Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
                Constants.FlickrParameterKeys.BoundingBox: bbox,
                Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
                Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
                Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
                Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
            ]
    
        VTClient.taskForGETMethod(methodParameters: methodParameters as [String : AnyObject]) { (data: AnyObject?, error: NSError?) in
            func sendError(_ error: String) {
                _ = [NSLocalizedDescriptionKey : error]
                
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error.debugDescription)")
                return
            }
            
            guard let photosDictionary = data![Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                sendError("Photos dictionary could not be printed in \(String(describing: data))")
                return
            }
            
            guard let totalStrings = photosDictionary[Constants.FlickrResponseKeys.Total] as? String else {
                sendError("Photos dictionary could not be printed in \(String(describing: photosDictionary))")
                return
            }
            
            let total = Int(totalStrings)!
            
            if total > 0 {
            
            guard let photosArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [Dictionary<String, AnyObject>] else {
                sendError("Photos dictionary could not be printed in \(String(describing: photosDictionary))")
                return
            }
            
            var results = [String]()
            
            
            for photo in photosArray {
                results.append(self.convertPhotoObjectToUrl(photo as NSDictionary))
            }
            
            completionHandler(results, nil)
            
                
            } else {
                print("No data from Flickr at this place")
                completionHandler([], nil)
            }
        }
    }
    
    func checkGetRequestData(url urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        
       
        
        VTClient.taskForGETDataMethod(url: urlString) { (data: AnyObject?, error: NSError?) in
            func sendError(_ error: String) {
                _ = [NSLocalizedDescriptionKey : error]
                
            }
            
            completion(data as? Data, error)
            
             
        }
    }


}



