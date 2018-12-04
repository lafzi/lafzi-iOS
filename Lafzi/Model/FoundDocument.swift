//
//  FoundDocument.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 02/12/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

struct FoundDocument {
    var ayatQuranId: Int
    var matchedTrigramsCount: Int
    var matchedTermsOrderScore: Int
    var matchedTermsCountScore: Int
    var matchedTermsContiguityScore: Float
    var score: Float
    var matchedTerms: [String : [Int]]
    var lis: [Int]
    var highlightPosition: [HighlightPosition]
    var ayatQuran: AyatQuran
}
