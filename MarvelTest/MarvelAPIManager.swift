//
//  MarvelAPIManager.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/12/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import UIKit
import AFNetworking

typealias AppearancesSuccesHandler = (operation: AFHTTPRequestOperation!, appearances: [Appearance]) -> Void
typealias ErrorHandler = (operation: AFHTTPRequestOperation!, error: NSError!) -> Void

class MarvelAPIManager {
    
    // MARK: - Properties
    
    let operationManager = AFHTTPRequestOperationManager()
    var isOperationManagerConfigured = false
    
    let defaultPageSize = 12
    
    
    private lazy var publicKey: String = {
        let path = NSBundle.mainBundle().pathForResource("MarvelAPIKeys", ofType: "plist")
        let keys = NSDictionary(contentsOfFile: path!)
        return keys!.objectForKey("PUBLIC_API_KEY") as! String
    }()
    
    private lazy var privateKey: String = {
        let path = NSBundle.mainBundle().pathForResource("MarvelAPIKeys", ofType: "plist")
        let keys = NSDictionary(contentsOfFile: path!)
        return keys!.objectForKey("PRIVATE_API_KEY") as! String
    }()
    
    private lazy var getCharactersURL: String = {
        return self.urlForRequest(requestKey:"GET_CHARACTERS")
    }()
    
    private lazy var getComicsURL: String = {
        return self.urlForRequest(requestKey:"GET_COMICS")
    }()
    
    private lazy var getSeriesURL: String = {
        return self.urlForRequest(requestKey:"GET_SERIES")
    }()
    
    private lazy var getStoriesURL: String = {
        return self.urlForRequest(requestKey:"GET_STORIES")
    }()
    
    private lazy var getEventsURL: String = {
        return self.urlForRequest(requestKey:"GET_EVENTS")
    }()
    
    // MARK: -- Singleton
    
    class var sharedInstance: MarvelAPIManager {
        struct Static {
            static var instance: MarvelAPIManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = MarvelAPIManager()
        }
        
        return Static.instance!
    }
    
    private init() {}
    
    // MARK: - Comics
    
    func getComicsWithCharacter(characterId: Int, success: AppearancesSuccesHandler, failure: ErrorHandler) {
        let comicFinalURL = String(format: getComicsURL)
        let ts = NSDate().timeIntervalSince1970.description
        let hash = md5(string:"\(ts)\(privateKey)\(publicKey)")
        
        operationManager.GET(comicFinalURL, parameters: ["apikey": publicKey, "ts" : ts, "hash": hash, "characters": characterId, "limit": defaultPageSize], success: { (operation, response) -> Void in
            let data = response["data"]
            let results = data!!["results"]

            var comicsList = [Appearance]()
            if let comicReturned = results as? [[String: AnyObject]] {
                for comic in comicReturned {
                    let comicToAppend = Appearance(dict: comic)
                    comicsList.append(comicToAppend)
                }
            }
            success(operation: operation, appearances: comicsList)
            
            }, failure: { (operation, error) -> Void in
                failure(operation: operation, error: error)
        })
    }
    
    // MARK: - Series
    
    func getSeriesWithCharacter(characterId: Int, success: AppearancesSuccesHandler, failure: ErrorHandler) {
        let seriesFinalURL = String(format: getSeriesURL)
        let ts = NSDate().timeIntervalSince1970.description
        let hash = md5(string:"\(ts)\(privateKey)\(publicKey)")
        
        operationManager.GET(seriesFinalURL, parameters: ["apikey": publicKey, "ts" : ts, "hash": hash, "characters": characterId, "limit": defaultPageSize], success: { (operation, response) -> Void in
            let data = response["data"]
            let results = data!!["results"]
            
            var seriesList = [Appearance]()
            if let serieReturned = results as? [[String: AnyObject]] {
                for serie in serieReturned {
                    let serieToAppend = Appearance(dict: serie)
                    seriesList.append(serieToAppend)
                }
            }
            success(operation: operation, appearances: seriesList)
            
            }, failure: { (operation, error) -> Void in
                failure(operation: operation, error: error)
        })
    }
    
    // MARK: - Stories
    
    func getStoriesWithCharacter(characterId: Int, success: AppearancesSuccesHandler, failure: ErrorHandler) {
        let storiesFinalURL = String(format: getStoriesURL)
        let ts = NSDate().timeIntervalSince1970.description
        let hash = md5(string:"\(ts)\(privateKey)\(publicKey)")
        
        operationManager.GET(storiesFinalURL, parameters: ["apikey": publicKey, "ts" : ts, "hash": hash, "characters": characterId, "limit": defaultPageSize], success: { (operation, response) -> Void in
            let data = response["data"]
            let results = data!!["results"]
            
            var storiesList = [Appearance]()
            if let storyReturned = results as? [[String: AnyObject]] {
                for story in storyReturned {
                    let storyToAppend = Appearance(dict: story)
                    storiesList.append(storyToAppend)
                }
            }
            success(operation: operation, appearances: storiesList)
            
            }, failure: { (operation, error) -> Void in
                failure(operation: operation, error: error)
        })
    }
    
    // MARK: - Events
    
    func getEventsWithCharacter(characterId: Int, success: AppearancesSuccesHandler, failure: ErrorHandler) {
        let eventsFinalURL = String(format: getEventsURL)
        let ts = NSDate().timeIntervalSince1970.description
        let hash = md5(string:"\(ts)\(privateKey)\(publicKey)")
        
        operationManager.GET(eventsFinalURL, parameters: ["apikey": publicKey, "ts" : ts, "hash": hash, "characters": characterId, "limit": defaultPageSize], success: { (operation, response) -> Void in
            let data = response["data"]
            let results = data!!["results"]
            
            var eventsList = [Appearance]()
            if let eventReturned = results as? [[String: AnyObject]] {
                for event in eventReturned {
                    let eventToAppend = Appearance(dict: event)
                    eventsList.append(eventToAppend)
                }
            }
            success(operation: operation, appearances: eventsList)
            
            }, failure: { (operation, error) -> Void in
                failure(operation: operation, error: error)
        })
    }
    
    // MARK: - Characters
    
    func getCharacters(page: Int, success: (operation: AFHTTPRequestOperation!, characters: [Character]) -> Void, failure: ErrorHandler) {

        let eventFinalURL = String(format: getCharactersURL)
        let ts = NSDate().timeIntervalSince1970.description
        let hash = md5(string:"\(ts)\(privateKey)\(publicKey)")
        let offset = page * defaultPageSize
        
        operationManager.GET(eventFinalURL, parameters: ["apikey": publicKey, "ts" : ts, "hash": hash, "limit": defaultPageSize, "offset": offset], success: { (operation, response) -> Void in
            let data = response["data"]
            let results = data!!["results"]
            
            var charList = [Character]()
            if let charsReturned = results as? [[String: AnyObject]] {
                for char in charsReturned {
                    let charToAppend = Character(dict: char)
                    charList.append(charToAppend)
                }
            }
            success(operation: operation, characters: charList)
            
            }, failure: { (operation, error) -> Void in
                failure(operation: operation, error: error)
        })
    }
    
    func getCharactersWithNameStartingWith(name: String, page: Int, success: (operation: AFHTTPRequestOperation!, characters: [Character]) -> Void, failure: ErrorHandler) {
        
        let eventFinalURL = String(format: getCharactersURL)
        let ts = NSDate().timeIntervalSince1970.description
        let hash = md5(string:"\(ts)\(privateKey)\(publicKey)")
        let offset = page * defaultPageSize
        
        operationManager.GET(eventFinalURL, parameters: ["apikey": publicKey, "ts" : ts, "hash": hash, "limit": defaultPageSize, "offset": offset, "nameStartsWith": name], success: { (operation, response) -> Void in
            let data = response["data"]
            let results = data!!["results"]
            
            var charList = [Character]()
            if let charsReturned = results as? [[String: AnyObject]] {
                for char in charsReturned {
                    let charToAppend = Character(dict: char)
                    charList.append(charToAppend)
                }
            }
            success(operation: operation, characters: charList)
            
            }, failure: { (operation, error) -> Void in
                failure(operation: operation, error: error)
        })
    }
    
    // MARK: - URL Building & Managers
    
    private func urlForRequest(requestKey requestKey: String) -> String {
        let path = NSBundle.mainBundle().pathForResource("URLs", ofType: "plist")
        let urls = NSDictionary(contentsOfFile: path!)
        
        let baseURL = urls?.objectForKey("BASE_URL") as! String!
        let relativeURL = urls?.objectForKey(requestKey) as! String!
        
        return baseURL + relativeURL
    }
    
    func md5(string string: String) -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
}

