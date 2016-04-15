//
//  AppearanceMainCollectionViewCell.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/13/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import UIKit

class AppearanceMainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var title: UILabel!
    
    var appearanceLinked: Appearance!
    
    override func prepareForReuse() {
        thumbnail.image = UIImage(named: "icn-cell-image-not-available")
        appearanceLinked = nil
    }
    
    func configWithAppearance(appearance: Appearance) {
        title.text = appearance.title
        thumbnail.image = UIImage(named: "icn-cell-image-not-available")
        appearanceLinked = appearance
        
        appearance.loadThumbnail { (thumbnail, comicReturned) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if self.appearanceLinked.title == comicReturned.title {
                    if let thumbnailReturned = thumbnail {
                        self.thumbnail.image = thumbnailReturned
                    }
                }
            })
        }
    }
    
}
