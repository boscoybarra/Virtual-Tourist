//
//  VTClient.swift
//  VirtualTourist
//
//  Created by J B on 7/6/17.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import MapKit

class VTClient: NSObject {
    
    // MARK: Properties
    
    var photos = [Photo]()
    
    static var session = URLSession.shared
    
    
    // MARK: GET
    
    @discardableResult static func taskForGETMethod(methodParameters: [String:AnyObject], completionHandler: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        /* 1. Set the parameters */
        
        let url = self.flickrURLFromParameters(methodParameters)
        
        let request = NSMutableURLRequest(url: url)
        
        /* 2/3. Build the UrL and configure the request */
        
        print("esta es la URL",request)
        
        //make request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
                return
            }
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse and use the data */
            
            self.parseJSONWithCompletionHandler(data: data as NSData, completionHandler: completionHandler)
            
            
            
        }
        
        task.resume()
        return task
        
    }
    

    private static func parseJSONWithCompletionHandler(data: NSData, completionHandler: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
            return
        }
        
        /* GUARD: Did Flickr return an error (stat != ok)? */
        guard let stat = parsedResult[Constants.FlickrResponseKeys.Status] as? String, stat == Constants.FlickrResponseValues.OKStatus else {
            completionHandler(nil, NSError(domain: "Data did not return as OK", code: 1, userInfo: nil))
            return
        }
        
        completionHandler(parsedResult, nil)
        
    }
    
    
    private static func flickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
    
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    static func bboxString(_ lat: Double, long: Double) -> String {
        
            let minimumLon = max(long - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.0)
            let minimumLat = max(lat - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
            let maximumLon = min(long + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
            let maximumLat = min(lat + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.1)
            return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
        
    }
    
    static func convertPhotoObjectToUrl(_ object: NSDictionary) -> String{
        //URL format = https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
        let farmId = object["farm"] as! Int
        let serverId = object["server"] as! NSString
        let photoId = object["id"] as! NSString
        let secret = object["secret"] as! NSString
        
        
        return "https://farm\(farmId).staticflickr.com/\(serverId)/\(photoId)_\(secret).jpg"
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> VTClient {
        struct Singleton {
            static var sharedInstance = VTClient()
        }
        return Singleton.sharedInstance
    }

}
