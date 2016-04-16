//
//  AppearanceMainCollectionViewCell.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/13/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import UIKit

class AppearanceMainCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var title: UILabel!
    
    var appearanceLinked: Appearance!
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        thumbnail.image = nil
        appearanceLinked = nil
    }
    
    // MARK: - Configuration
    
    func configWithAppearance(appearance: Appearance) {
        title.text = appearance.title
        appearanceLinked = appearance
        
        appearance.loadThumbnail { (thumbnail, appearanceReturned) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if self.appearanceLinked.title == appearanceReturned.title {
                    if let thumbnailReturned = thumbnail {
                        self.thumbnail.image = thumbnailReturned
                    } else {
                        self.thumbnail.image = UIImage(named:"icn-cell-image-not-available")
                    }
                }
            })
        }
    }
    
}
