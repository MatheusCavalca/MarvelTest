//
//  CharacterDetailsViewController.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/12/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import UIKit
import SafariServices

enum CharacterDetailsRow: Int {
    
    case Name = 0,
        Description,
        Comics,
        Series,
        Stories,
        Events,
        RelatedLinks
    
    func relatedSectionTitle() -> String {
        switch self {
        case .Name:
            return "NAME"
        case .Description:
            return "DESCRIPTION"
        case .Comics:
            return "COMICS"
        case .Series:
            return "SERIES"
        case .Stories:
            return "STORIES"
        case .Events:
            return "EVENTS"
        case .RelatedLinks:
            return "RELATED LINKS"
        }
    }

}

class CharacterDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var characterName: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var characterImage: UIImageView!
    
    var character: Character!
    var comics: [Appearance]!
    var series: [Appearance]!
    var stories: [Appearance]!
    var events: [Appearance]!

    let tvOffsetHeaderStart: CGFloat = 220.0
    let tvOffsetHeaderAmount: CGFloat = 100.0
    
    let labelTag = 100
    let heightForHeader: CGFloat = 30.0
    let nSections = 7
    let headerTitles: [CharacterDetailsRow] = [.Name, .Description, .Comics, .Series, .Stories, .Events, .RelatedLinks]
    let nRowsInSection = [1, 1, 1, 1, 1, 1, 3]
    
    let relatedLinksTitles = ["Detail", "Wiki", "Comiclink"]
    
    let nothingToDisplay = "Nothing to display"
    let noDescription = "No description to display"
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configContent()
        loadComics()
        loadSeries()
        loadStories()
        loadEvents()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - Configurations
    
    func configContent() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 220.0
        
        characterName.text = character.name
        
        if let image = character.thumbnailLoaded {
            characterImage.image = image
        } else {
            character.loadThumbnail({ (thumbnail, character) in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.characterImage.image = thumbnail
                });
            })
        }
    
        if (!UIAccessibilityIsReduceTransparencyEnabled()) {
            viewHeader.backgroundColor = UIColor.clearColor()
            let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
            blurEffectView.frame = viewHeader.bounds
            viewHeader.addSubview(blurEffectView)
            viewHeader.sendSubviewToBack(blurEffectView)
        }
    }
    
    // MARK: - API Helpers

    func loadComics() {
        MarvelAPIManager.sharedInstance.getComicsWithCharacter(character.charId, success: { (operation, comics) in
            self.comics = comics
            self.tableView.reloadData()
            }) { (operation, error) in
        }
    }
    
    func loadSeries() {
        MarvelAPIManager.sharedInstance.getSeriesWithCharacter(character.charId, success: { (operation, series) in
            self.series = series
            self.tableView.reloadData()
        }) { (operation, error) in
        }
    }
    
    func loadStories() {
        MarvelAPIManager.sharedInstance.getStoriesWithCharacter(character.charId, success: { (operation, stories) in
            self.stories = stories
            self.tableView.reloadData()
        }) { (operation, error) in
        }
    }
    
    func loadEvents() {
        MarvelAPIManager.sharedInstance.getEventsWithCharacter(character.charId, success: { (operation, events) in
            self.events = events
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
            let destinationViewController = segue.destinationViewController as! CoverViewController
            destinationViewController.appearance = sender as! Appearance
        }
    }
    
}

extension CharacterDetailsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return nSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nRowsInSection[section]
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let nibName = NibObjects.reuseIdentifierFor(.CharacterDetailsHeaderView)
        let nib = UINib(nibName: nibName, bundle: NSBundle.mainBundle())
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        let labelTitle = view.viewWithTag(labelTag) as! UILabel
        labelTitle.text = headerTitles[section].relatedSectionTitle()
        
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        switch section {
        case CharacterDetailsRow.Name.rawValue:
            let cellIdentifier = NibObjects.reuseIdentifierFor(.TextCell)
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            
            let label = cell.viewWithTag(labelTag) as! UILabel
            label.text = character.name
            
            return cell
            
        case CharacterDetailsRow.Description.rawValue:
            let cellIdentifier = NibObjects.reuseIdentifierFor(.TextCell)
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            
            let label = cell.viewWithTag(labelTag) as! UILabel
            
            if let description = character.description where description != "" {
                label.text = description
            } else {
                label.text = noDescription
            }
            
            return cell
            
        case CharacterDetailsRow.Comics.rawValue where comics == nil,
        CharacterDetailsRow.Series.rawValue where series == nil,
        CharacterDetailsRow.Stories.rawValue where stories == nil,
        CharacterDetailsRow.Events.rawValue where events == nil:
            let cellIdentifier = NibObjects.reuseIdentifierFor(.LoadingCell)
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            
            return cell
            
        case CharacterDetailsRow.Comics.rawValue where comics.count > 0:
            let cellIdentifier = NibObjects.reuseIdentifierFor(.ComicMainCell)
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AppearanceMainTableViewCell
            
            cell.appearances = comics
            cell.delegate = self
            
            return cell
            
        case CharacterDetailsRow.Series.rawValue where series.count > 0:
            let cellIdentifier = NibObjects.reuseIdentifierFor(.ComicMainCell)
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AppearanceMainTableViewCell
            
            cell.appearances = series
            cell.delegate = self
            
            return cell
            
        case CharacterDetailsRow.Stories.rawValue where stories.count > 0:
            let cellIdentifier = NibObjects.reuseIdentifierFor(.ComicMainCell)
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AppearanceMainTableViewCell
            
            cell.appearances = stories
            cell.delegate = self
            
            return cell
            
        case CharacterDetailsRow.Events.rawValue where events.count > 0:
            let cellIdentifier = NibObjects.reuseIdentifierFor(.ComicMainCell)
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AppearanceMainTableViewCell
            
            cell.appearances = events
            cell.delegate = self
            
            return cell
            
        case CharacterDetailsRow.RelatedLinks.rawValue:
            let cellIdentifier = NibObjects.reuseIdentifierFor(.RelatedLinksCell)
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            
            let label = cell.viewWithTag(labelTag) as! UILabel
            label.text = relatedLinksTitles[row]
            
            return cell
            
        default:
            let cellIdentifier = NibObjects.reuseIdentifierFor(.LoadingCell)
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            
            let label = cell.viewWithTag(labelTag) as! UILabel
            label.text = nothingToDisplay
            
            return cell
        }
    }
    
}

extension CharacterDetailsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeader
    }
    
}

extension CharacterDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if tableView.contentOffset.y >= tvOffsetHeaderStart + tvOffsetHeaderAmount {
            viewHeader.alpha = 1.0
        } else if tableView.contentOffset.y >= tvOffsetHeaderStart {
            let difference = tableView.contentOffset.y - tvOffsetHeaderStart
            let alpha = difference / tvOffsetHeaderAmount
            viewHeader.alpha = alpha
        } else {
            viewHeader.alpha = 0.0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 6 {
            var URL: NSURL!
            switch indexPath.row {
            case 0:
                if let detailURL = character.detailURL {
                    URL = NSURL(string: detailURL)
                } else {
                    return
                }
                break;
            case 1:
                if let wikiURL = character.wikiURL {
                    URL = NSURL(string: wikiURL)
                } else {
                    return
                }
                break;
            default:
                if let comicLinkURL = character.comicLinkURL {
                    URL = NSURL(string: comicLinkURL)
                } else {
                    return
                }
                break;
            }

            let svc = SFSafariViewController(URL: URL)
            svc.view.tintColor = UIColor.blackColor()
            svc.delegate = self
            self.presentViewController(svc, animated: true, completion: nil)
        }
    }
}

extension CharacterDetailsViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
extension CharacterDetailsViewController: AppearanceCellDelegate {
    
    func collectionCellSelected(appearance: Appearance) {
        performSegueWithIdentifier("segueCover", sender: appearance)
    }
    
}