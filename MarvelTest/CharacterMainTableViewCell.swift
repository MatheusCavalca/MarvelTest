//
//  CharacterMainTableViewCell.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/12/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import UIKit

class CharacterMainTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var charName: UILabel!
    
    var characterLinked: Character!
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        thumbnail.image = nil
        characterLinked = nil
    }
    
    // MARK: - Configuration
    
    func configWithChar(character: Character) {
        charName.text = character.name
        characterLinked = character
        
        character.loadThumbnail { (thumbnail, characterReturned) in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if self.characterLinked.charId == characterReturned.charId {
                    if let thumbnailReturned = thumbnail {
                        self.thumbnail.image = thumbnailReturned
                    }
                }
            })
        }
    }
    
}
