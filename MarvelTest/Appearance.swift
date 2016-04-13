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
    var thumbnail: String
    var thumbnailLoaded: UIImage?
    
    init(dict: [String: AnyObject]) {
        appearanceId = dict["id"] as! Int
        title = dict["title"] as! String
        
        let thumbDict = dict["thumbnail"] as! [String: String]
        thumbnail = thumbDict["path"]! + "." + thumbDict["extension"]!
    }
    
    // MARK: - Thumbnail Handlers
    
    func loadThumbnail(completion: ((thumbnail: UIImage?, appearance: Appearance) -> Void)) {
        if let thumbnailLoadedUnw = thumbnailLoaded {
            completion(thumbnail: thumbnailLoadedUnw, appearance: self)
        } else {
            getDataFromUrl(NSURL(string: thumbnail)!, completion: { (data, response, error) in
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
