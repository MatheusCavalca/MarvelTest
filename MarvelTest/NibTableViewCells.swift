//
//  NibTableViewCells.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/12/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import Foundation

enum NibTableViewCell: String {
    
    case CharacterMainCell,
        CharacterSearchCell,
        ComicMainCell
    
    static func reuseIdentifierFor(nibTableViewCell: NibTableViewCell) -> String {
        switch nibTableViewCell {
        case .CharacterMainCell: return "CharacterMainCellIdentifier"
        case .CharacterSearchCell: return "CharacterSearchCellIdentifier"
        case .ComicMainCell: return "AppearanceMainCellIdentifier"
        }
    }
    
}