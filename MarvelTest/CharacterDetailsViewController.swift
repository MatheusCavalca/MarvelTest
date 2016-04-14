//
//  CharacterDetailsViewController.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/12/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var characterName: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var character: Character!
    var comics = [Appearance]()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configContent()
        loadComics()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - Configurations
    
    func configContent() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 220.0
        
        characterName.text = character.name
    }
    
    func loadComics() {
        MarvelAPIManager.sharedInstance.getComicsWithCharacter(character.charId, success: { (operation, comics) in
            self.comics = comics
            self.tableView.reloadData()
            }) { (operation, error) in
        }
    }
    
    // MARK: - Action
    
    @IBAction func cancelDismiss(sender: AnyObject) {
        if let navController = navigationController {
            navController.popViewControllerAnimated(true)
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueCover" {
            let indexPath = sender as! NSIndexPath
            let destinationViewController = segue.destinationViewController as! CoverViewController
            destinationViewController.apperance = comics[indexPath.row]
        }
    }
    
}

extension CharacterDetailsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comics.count > 0 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = NibObjects.reuseIdentifierFor(.ComicMainCell)
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AppearanceMainTableViewCell
        
        cell.comics = comics
        cell.delegate = self
        
        return cell
    }
    
}

extension CharacterDetailsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension CharacterDetailsViewController: AppearanceCellDelegate {
    
    func collectionCellSelected(indexPath: NSIndexPath) {
        performSegueWithIdentifier("segueCover", sender: indexPath)
    }
    
}