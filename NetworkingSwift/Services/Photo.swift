//
//  Photo.swift
//  NetworkingSwift
//
//  Created by Mauro Olivo on 20/06/16.
//  Copyright © 2016 Mauro Olivo. All rights reserved.
//

import UIKit

enum PhotoServiceError: String, ErrorType {
    case NotImplemented = "This feature has not been implemented yet"
    case URLParsing = "Sorry, there was an error getting the photos"
    case JSONStructure = "Sorry, the photo service returned something different than expected"
}

typealias PhotosResult = ([Photo]?, ErrorType?) -> Void

class Photo: NSObject {

    var itemId: String
    var photoUrl: NSURL
    var favorite = false
    
    static let itemIdKey = "itemId"
    static let photoUrlKey = "photoUrl"
    static let favoriteKey = "favorite"
    
    init(dictionary values: NSDictionary) {
        guard let link = values["link"] as? String else {
            fatalError("Photo item could not be created: " + values.description)
        }
        itemId = link
        
        guard let media = values["media"] as? NSDictionary,
            urlString = media["m"] as? String, url = NSURL(string: urlString) else {
                fatalError("Photo item could not be created: " + values.description)
        }
        photoUrl = url
    }
    
    
    
    class func getAllFeedPhotos(completion: PhotosResult) {
        guard let url = NSURL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1") else {
            completion(nil, PhotoServiceError.URLParsing)
            return
        }
        
        NetworkClient.sharedInstance.getURL(url) { (result, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            if let dictionary = result as? NSDictionary, items = dictionary["items"] as? [NSDictionary] {
                var photos = [Photo]()
                for item in items {
                    photos.append(Photo(dictionary: item))
                }
                completion(photos, nil)
            } else {
                completion(nil, PhotoServiceError.JSONStructure)
            }
        }
    }
    
}
