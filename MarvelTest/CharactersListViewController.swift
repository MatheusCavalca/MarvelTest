//
//  CharactersListViewController.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/12/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import UIKit
import AFNetworking

class CharactersListViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var tableView: UITableView!
    
    var characters = [Character]()
    
    var apiManager = MarvelAPIManager.sharedInstance
    
    var isLoading = false
    var hasMoreCharacters = true
    var page = 0
    
    let footerPlaceholderView = UIView()
    lazy var loadingIndicator: UIView = {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40.0))
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        
        activityIndicator.startAnimating()
        activityIndicator.center = footerView.center
        
        footerView.addSubview(activityIndicator)
        
        return footerView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLoading = true
        loadCharacters()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // MARK: - API Helpers

    func loadCharacters() {
        MarvelAPIManager.sharedInstance.getCharacters(page, success: { (operation, characters) in
            self.didRetrievedChars(characters)
        }) { (operation, error) in
            self.didRetrievedCharsError([Character]())
        }
        
        page += 1
    }
    
    func didRetrievedChars(charList: [Character]) {
        if charList.isEmpty {
            hasMoreCharacters = false
            stopLoadingOnFooterOfTableView(tableView)
        } else {
            self.characters.appendContentsOf(charList)
            
            let startIndex = characters.count - charList.count
            var indexPathes = [NSIndexPath]()
            for i in startIndex ..< characters.count {
                indexPathes.append(NSIndexPath(forRow: i, inSection: 0))
            }
            self.tableView.insertRowsAtIndexPaths(indexPathes, withRowAnimation: .Automatic)
            
            if charList.count == apiManager.defaultPageSize {
                hasMoreCharacters = true
            } else {
                hasMoreCharacters = false
                stopLoadingOnFooterOfTableView(tableView)
            }
        }
        
        isLoading = false
    }
    
    func didRetrievedCharsError(charList: [Character]) {
        isLoading = false
    }
    
    // MARK: - Endless Scrolling  Helpers
    
    func startLoadingOnFooterOfTableView(tableView: UITableView) {
        tableView.tableFooterView = loadingIndicator
    }
    
    func stopLoadingOnFooterOfTableView(tableView: UITableView) {
        tableView.tableFooterView = footerPlaceholderView
    }
    
    func loadMoreCharacters() {
        startLoadingOnFooterOfTableView(tableView)
        if !hasMoreCharacters {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.stopLoadingOnFooterOfTableView(self.tableView)
            })
        } else {
            isLoading = true
            loadCharacters()
        }
    }
    
    // MARK: - Action
    
    @IBAction func searchCharacter(sender: AnyObject) {
        performSegueWithIdentifier("segueSearchCharacter", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueCharacterDetails" {
            let indexPath = sender as! NSIndexPath
            let destinationViewController = segue.destinationViewController as! CharacterDetailsViewController
            destinationViewController.character = characters[indexPath.row]
        }
    }
    
}

extension CharactersListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == characters.count - 1 {
            loadMoreCharacters()
        }
        
        let cellIdentifier = NibObjects.reuseIdentifierFor(.CharacterMainCell)
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CharacterMainTableViewCell
        
        cell.configWithChar(characters[indexPath.row])
        
        return cell
    }
    
}

extension CharactersListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("segueCharacterDetails", sender: indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

