//
//  AppearanceMainTableViewCell.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/13/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import UIKit

class AppearanceMainTableViewCell: UITableViewCell {

    // MARK: Properties
    
    var comics = [Appearance]()
    @IBOutlet var collectionView: UICollectionView!
    
}

extension AppearanceMainTableViewCell: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AppearanceMainCollectionCellIdentifier", forIndexPath: indexPath) as! AppearanceMainCollectionViewCell
        cell.configWithComic(comics[indexPath.row])
        
        return cell
    }
    
}
