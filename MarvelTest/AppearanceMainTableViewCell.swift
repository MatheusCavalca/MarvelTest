//
//  AppearanceMainTableViewCell.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/13/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import UIKit

protocol AppearanceCellDelegate: class {
    
    func collectionCellSelected(appearance: Appearance) -> Void
    
}

class AppearanceMainTableViewCell: UITableViewCell {

    // MARK: Properties
    
    weak var delegate:AppearanceCellDelegate?
    
    var appearances = [Appearance]()
    @IBOutlet var collectionView: UICollectionView!
    
}

extension AppearanceMainTableViewCell: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appearances.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NibObjects.reuseIdentifierFor(.AppearanceMainCollectionCell), forIndexPath: indexPath) as! AppearanceMainCollectionViewCell
        cell.configWithAppearance(appearances[indexPath.row])
        
        return cell
    }
    
}

extension AppearanceMainTableViewCell: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.collectionCellSelected(appearances[indexPath.row])
    }
    
}