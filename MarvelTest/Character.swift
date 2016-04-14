//
//  Character.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/12/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import Foundation

class Character {
    
    // MARK: - Properties
    
    var charId: Int
    var name: String
    var description: String
    var thumbnailPath: String
    var thumbnailLoaded: UIImage?
    
    // MARK: - Initialization
    
    init(dict: [String: AnyObject]) {
        charId = dict["id"] as! Int
        name = dict["name"] as! String
        description = dict["description"] as! String
        
        let thumbDict = dict["thumbnail"] as! [String: String]
        thumbnailPath = thumbDict["path"]! + "." + thumbDict["extension"]!
    }
    
    // MARK: - Thumbnail Handlers
    
    func loadThumbnail(completion: ((thumbnail: UIImage?, character: Character) -> Void)) {
        if let thumbnailLoadedUnw = thumbnailLoaded {
            completion(thumbnail: thumbnailLoadedUnw, character: self)
        } else {
            getDataFromUrl(NSURL(string: thumbnailPath)!, completion: { (data, response, error) in
                if let dataUnw = data {
                    self.thumbnailLoaded = UIImage(data: dataUnw)
                    completion(thumbnail: self.thumbnailLoaded, character: self)
                } else {
                    completion(thumbnail: nil, character: self)
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