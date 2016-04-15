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
        TextCell,
        LoadingCell,
        RelatedLinksCell,
        AppearanceMainCollectionCell,
        CoverView,
        CharacterDetailsHeaderView
    
    static func reuseIdentifierFor(nibTableViewCell: NibObjects) -> String {
        switch nibTableViewCell {
        case .CharacterMainCell: return "CharacterMainCellIdentifier"
        case .CharacterSearchCell: return "CharacterSearchCellIdentifier"
        case .ComicMainCell: return "AppearanceMainCellIdentifier"
        case .TextCell: return "TextCellIdentifier"
        case .AppearanceMainCollectionCell: return "AppearanceMainCollectionCellIdentifier"
        case .CoverView: return "CoverView"
        case .CharacterDetailsHeaderView: return "CharacterDetailsHeaderView"
        case .LoadingCell: return "LoadingCellIdentifier"
        case .RelatedLinksCell: return "RelatedLinksCellIdentifier"
        }
    }
    
}