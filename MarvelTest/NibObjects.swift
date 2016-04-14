//
//  NibObjects.swift
//  MarvelTest
//
//  Created by Matheus Cavalca on 4/12/16.
//  Copyright © 2016 Matheus Cavalca. All rights reserved.
//

import Foundation

enum NibObjects: String {
    
    case CharacterMainCell,
        CharacterSearchCell,
        ComicMainCell,
        AppearanceMainCollectionCell,
        CoverView
    
    static func reuseIdentifierFor(nibTableViewCell: NibObjects) -> String {
        switch nibTableViewCell {
        case .CharacterMainCell: return "CharacterMainCellIdentifier"
        case .CharacterSearchCell: return "CharacterSearchCellIdentifier"
        case .ComicMainCell: return "AppearanceMainCellIdentifier"
        case .AppearanceMainCollectionCell: return "AppearanceMainCollectionCellIdentifier"
        case .CoverView: return "CoverView"
        }
    }
    
}