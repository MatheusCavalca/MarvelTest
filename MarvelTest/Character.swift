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
    var description: String?
    var thumbnailPath: String?
    var thumbnailLoaded: UIImage?
    var detailURL: String?
    var wikiURL: String?
    var comicLinkURL: String?
    
    var hasPhoto: Bool {
        get {
            return !(thumbnailPath!.containsString("image_not_available"))
        }
    }
    
    // MARK: - Initialization
    
    init(dict: [String: AnyObject]) {
        charId = dict["id"] as! Int
        name = dict["name"] as! String
        description = dict["description"] as? String
        
        let thumbDict = dict["thumbnail"] as! [String: String]
        thumbnailPath = thumbDict["path"]! + "." + thumbDict["extension"]!
        
        if let urlsArray = dict["urls"] as? [[String: AnyObject]] {
            for url in urlsArray {
                if url["type"] as? String == "detail" {
                    detailURL = url["url"] as? String
                } else if url["type"] as? String == "wiki" {
                    wikiURL = url["wiki"] as? String
                } else if url["type"] as? String == "comiclink" {
                    comicLinkURL = url["comiclink"] as? String
                }
            }
        }
        
    }
    
    // MARK: - Thumbnail Handlers
    
    func loadThumbnail(completion: ((thumbnail: UIImage?, character: Character) -> Void)) {
        if thumbnailPath == nil {
            completion(thumbnail: nil, character: self)
            return
        }
        
        if let thumbnailLoadedUnw = thumbnailLoaded {
            completion(thumbnail: thumbnailLoadedUnw, character: self)
        } else {
            getDataFromUrl(NSURL(string: thumbnailPath!)!, completion: { (data, response, error) in
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