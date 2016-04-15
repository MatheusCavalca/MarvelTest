//
//  Appearance.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/13/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import Foundation

class Appearance {
    
    // MARK: - Properties
    
    var appearanceId: Int
    var title: String
    var thumbnailPath: String?
    var thumbnailLoaded: UIImage?
    var imagesPathes: [String]?
    var imagesLoaded: [String]?
    
    init(dict: [String: AnyObject]) {
        appearanceId = dict["id"] as! Int
        title = dict["title"] as! String
        
        if let thumbDict = dict["thumbnail"] as? [String: String] {
            thumbnailPath = thumbDict["path"]! + "." + thumbDict["extension"]!
        }
        
        if let imagesArray = dict["images"] as? [[String: String]] {
            imagesPathes = [String]()
            for imageDict in imagesArray {
                let imagePath = imageDict["path"]! + "." + imageDict["extension"]!
                imagesPathes?.append(imagePath)
            }
        }
    }
    
    // MARK: - Thumbnail Handlers
    
    func loadThumbnail(completion: ((thumbnail: UIImage?, appearance: Appearance) -> Void)) {
        if thumbnailPath == nil {
            completion(thumbnail: nil, appearance: self)
            return
        }
        
        if let thumbnailLoadedUnw = thumbnailLoaded {
            completion(thumbnail: thumbnailLoadedUnw, appearance: self)
        } else {
            getDataFromUrl(NSURL(string: thumbnailPath!)!, completion: { (data, response, error) in
                if let dataUnw = data {
                    self.thumbnailLoaded = UIImage(data: dataUnw)
                    completion(thumbnail: self.thumbnailLoaded, appearance: self)
                } else {
                    completion(thumbnail: nil, appearance: self)
                }
            })
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
}
