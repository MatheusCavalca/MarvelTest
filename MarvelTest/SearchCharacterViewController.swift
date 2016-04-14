//
//  SearchCharacterViewController.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/12/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import UIKit

class SearchCharacterViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchField: UITextField!
    
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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - API Helpers
    
    func loadCharactersWithStartName(name: String) {
        MarvelAPIManager.sharedInstance.getCharactersWithNameStartingWith(name, page: page, success: { (operation, characters) in
            if name == self.searchField.text {
                self.didRetrievedCharacters(characters)
            }
        }) { (operation, error) in
            self.didRetrievedCharactersError([Character]())
        }
        
        page += 1
    }
    
    func didRetrievedCharacters(charList: [Character]) {
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
            tableView.insertRowsAtIndexPaths(indexPathes, withRowAnimation: .Automatic)
            
            if charList.count == apiManager.defaultPageSize {
                hasMoreCharacters = true
            } else {
                hasMoreCharacters = false
                stopLoadingOnFooterOfTableView(tableView)
            }
        }
        
        isLoading = false
    }
    
    func didRetrievedCharactersError(charList: [Character]) {
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
            if let searchText = searchField.text {
                loadCharactersWithStartName(searchText)
            }
        }
    }
    
    func loadCharactersWithNewSearch(name: String) {
        page = 0
        characters = [Character]()
        tableView.reloadData()
        stopLoadingOnFooterOfTableView(tableView)
        loadCharactersWithStartName(name)
    }
    
    // MARK: - Action
    
    @IBAction func cancelDismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueSearchCharacterDetails" {
            let indexPath = sender as! NSIndexPath
            let destinationViewController = segue.destinationViewController as! CharacterDetailsViewController
            destinationViewController.character = characters[indexPath.row]
            
        }
    }
    
}

extension SearchCharacterViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var txtAfterUpdate:NSString = searchField.text! as NSString
        txtAfterUpdate = txtAfterUpdate.stringByReplacingCharactersInRange(range, withString: string)
        
        self.loadCharactersWithNewSearch(txtAfterUpdate as String)
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension SearchCharacterViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == characters.count - 1 {
            loadMoreCharacters()
        }
        
        let cellIdentifier = NibObjects.reuseIdentifierFor(.CharacterSearchCell)
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CharacterMainTableViewCell
        
        cell.configWithChar(characters[indexPath.row])
        
        return cell
    }
    
}

extension SearchCharacterViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("segueSearchCharacterDetails", sender: indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
