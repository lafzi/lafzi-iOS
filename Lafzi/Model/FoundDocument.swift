//
//  FoundDocument.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 02/12/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

class FoundDocument {
    var ayatQuranId: Int = 0
    var matchedTrigramsCount: Int = 0
    var matchedTermsOrderScore: Int = 0
    var matchedTermsCountScore: Int = 0
    var matchedTermsContiguityScore: Float = 0
    var score: Float = 0
    var matchedTerms: [String : [Int]] = [String:[Int]]()
    var lis: [Int] = [Int]()
    var highlightPosition: [HighlightPosition] = [HighlightPosition]()
    var ayatQuran: AyatQuran = AyatQuran()
}
