//
//  SearchHelper.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 02/12/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

import Foundation

class SearchHelper {
    private init(){}
    static func doSearch(query: String, isVocal: Bool = true, orderedByScode: Bool = true, filtered: Bool = true, threshold: Float = 0.9) {
        let trigrams = extractTrigramFP(text: query)
        for (key, doc) in  trigrams {
            print(key)
            print(doc)
        }
    }
    
    static func extractTrigramFP(text: String) -> [String : FreqAndPosition] {
        var results = [String : FreqAndPosition]()
        
        if (text.count < 3) {
            return results
        }
        if (text.count == 3) {
            results[text] = FreqAndPosition(freq: 1, positions: [1])
            return results
        }
        
        for i in 0...text.count-3 {
            let indexStart = text.index(text.startIndex, offsetBy: i)
            let indexEnd = text.index(text.startIndex, offsetBy: i + 3)
            let trigram = text[indexStart..<indexEnd]
            
            var newFp: FreqAndPosition
            if results[String(trigram)] != nil {
                let fp = results[String(trigram)]
                let freq = fp?.freq
                var positions = fp?.positions
                positions?.append(i)
                newFp = FreqAndPosition(freq: freq! + 1, positions: positions!)
            } else {
                newFp = FreqAndPosition(freq: 1, positions: [i])
            }
            results[String(trigram)] = newFp
        }
        return results
    }
}
