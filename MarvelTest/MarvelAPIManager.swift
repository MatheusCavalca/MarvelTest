//
//  MarvelAPIManager.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/12/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import UIKit
import AFNetworking

class MarvelAPIManager {
    
    let publicKey = "14555c551bd677c5aa887abcdfbe68b6"
    let privateKey = "31b59cce5304fb3b1c81686dcfcf15bdf48b4841"
    
    let operationManager = AFHTTPRequestOperationManager()
    var isOperationManagerConfigured = false
    
    let defaultPageSize = 12
    
    private lazy var getCharactersURL: String = {
        return self.urlForRequest(requestKey:"GET_CHARACTERS")
    }()
    
    private lazy var getComicsURL: String = {
        return self.urlForRequest(requestKey:"GET_COMICS")
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
    
    func getComicsWithCharacter(characterId: Int, success: (operation: AFHTTPRequestOperation!, comics: [Appearance]) -> Void, failure: (operation: AFHTTPRequestOperation!, error: NSError!) -> Void) {
        
        let comicFinalURL = String(format: getComicsURL)
        let ts = NSDate().timeIntervalSince1970.description
        let hash = md5(string:"\(ts)\(privateKey)\(publicKey)")
        
        operationManager.GET(comicFinalURL, parameters: ["apikey": publicKey, "ts" : ts, "hash": hash, "characters": characterId, "limit": defaultPageSize], success: { (operation, response) -> Void in
            let data = response["data"]
            let results = data!!["results"]

            var comicList = [Appearance]()
            if let comicReturned = results as? [[String: AnyObject]] {
                for comic in comicReturned {
                    let comicToAppend = Appearance(dict: comic)
                    comicList.append(comicToAppend)
                }
            }
            success(operation: operation, comics: comicList)
            
            }, failure: { (operation, error) -> Void in
                failure(operation: operation, error: error)
        })
    }
    
    // MARK: - Characters
    
    func getCharacters(page: Int, success: (operation: AFHTTPRequestOperation!, characters: [Character]) -> Void, failure: (operation: AFHTTPRequestOperation!, error: NSError!) -> Void) {

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
    
    func getCharactersWithNameStartingWith(name: String, page: Int, success: (operation: AFHTTPRequestOperation!, characters: [Character]) -> Void, failure: (operation: AFHTTPRequestOperation!, error: NSError!) -> Void) {
        
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
    
    
    private func includeParametersAndCustomHeadersIfNeeded() {
        if !isOperationManagerConfigured {
            let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
            
            operationManager.responseSerializer = AFJSONResponseSerializer()
            operationManager.responseSerializer.acceptableContentTypes = NSSet(objects: "text/plain", "application/json") as Set<NSObject>
            operationManager.requestSerializer = AFJSONRequestSerializer(writingOptions: NSJSONWritingOptions(rawValue: 0))
            operationManager.requestSerializer.setValue("ios", forHTTPHeaderField: "X-Platform")
            operationManager.requestSerializer.setValue(version, forHTTPHeaderField: "X-App-Version")
            operationManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
            operationManager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        }
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

