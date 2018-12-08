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
    static func doSearch(query: String, isVocal: Bool = true, orderedByScore: Bool = true, filtered: Bool = true, threshold: Float = 0.9) -> [Int : FoundDocument] {
        var matchedDocs = [Int : FoundDocument]()
        let trigrams = extractTrigramFP(text: query)
        for (key, fp) in  trigrams {
            let indices = DBHelper.getInstance().getIndexByTrigram(trigram: key, isVocal: isVocal)
            for (ayatId, positions) in (indices?.post)! {
                var document = FoundDocument()
                if matchedDocs[ayatId] != nil {
                    document = matchedDocs[ayatId]!
                    var matchedTrigrams = document.matchedTrigramsCount
                    let queryTrigramFreq = fp.freq
                    let termFreq = positions.count
                    
                    matchedTrigrams += (queryTrigramFreq < termFreq) ? queryTrigramFreq : termFreq
                    document.matchedTrigramsCount = matchedTrigrams
                } else {
                    document.matchedTrigramsCount = 1
                    document.ayatQuranId = ayatId
                }
                
                var matchedTerms = document.matchedTerms.count < 1 ? [String : [Int]]() : document.matchedTerms
                matchedTerms[key] = positions
                document.matchedTerms = matchedTerms
                matchedDocs[ayatId] = document
            }
        }
        
        var filteredDocs = [Int : FoundDocument]()
        let minScore = threshold * Float((query.count - 2))
        
        if orderedByScore {
            for (key,fd) in matchedDocs {
                fd.matchedTermsCountScore = fd.matchedTrigramsCount
                let flattened = fd.matchedTerms.flatMap{_,v in
                    return v
                }
                let lis = longestContiguousSubsequence(sqc: flattened, maxGap: 7)
                fd.matchedTermsOrderScore = lis.count
                fd.lis = lis
                
                fd.matchedTermsContiguityScore = reciprocalDiffAverage(lis: lis)
                fd.score = Float(fd.matchedTermsOrderScore) * fd.matchedTermsContiguityScore
                
                if filtered && (fd.matchedTrigramsCount >= Int(minScore)) {
                    filteredDocs[key] = fd
                }
            }
        } else {
            for (key, fd) in matchedDocs {
                fd.matchedTermsCountScore = fd.matchedTrigramsCount
                fd.score = Float(fd.matchedTermsCountScore)
                if filtered && (fd.matchedTrigramsCount >= Int(minScore)) {
                    filteredDocs[key] = fd
                }
            }
        }
        
        if filtered {
            return filteredDocs
        }
        return matchedDocs
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
        
        for i in 0..<text.count-2 {
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
    
    static func highlighting(matchedDocs: [Int:FoundDocument], isVocal: Bool = true) -> [Int : FoundDocument]{
        var newDocs = [Int : FoundDocument]()
        for (key, doc) in matchedDocs {
            let ayatQuran = DBHelper.getInstance().getAyatQuran(ayatId: doc.ayatQuranId)
            var docText = ayatQuran.ayatArabic
            doc.ayatQuran = ayatQuran
            
            var posisiReal = [Int]()
            var seq = Set<Int>()
            
            for pos in doc.lis {
                seq.insert(pos)
                seq.insert(pos + 1)
                seq.insert(pos + 2)
            }
            
            for s in seq {
                posisiReal.append(ayatQuran.mappingPos[s - 1])
            }
            
            doc.highlightPosition = longestHighlightLookforward(hsq: posisiReal, minLength: 3)
            let hps = doc.highlightPosition
            let endPos = hps[hps.count - 1].end
            let chars = Array(docText.unicodeScalars)
            
            if chars[endPos + 1] == " " ||
                chars.count - 1 <= endPos + 1 {
                doc.score += 0.001
            } else if chars[endPos + 2] == " " ||
                chars.count - 1 <= endPos + 2 {
                doc.score += 0.001
            } else if chars[endPos + 3] == " " ||
                chars.count - 1 <= endPos + 3 {
                doc.score += 0.001
            }
            
            newDocs[key] = doc
        }
        return newDocs
    }
    
    private static func longestContiguousSubsequence(sqc: [Int], maxGap: Int) -> [Int] {
        var sequence = sqc.sorted()
        let size = sequence.count
        var start = 0
        var length = 0
        var maxStart = 0
        var maxLength = 0
        
        for i in 0..<size-1 {
            if (sequence[i+1] - sequence[i]) > maxGap {
                length = 0
                start = i + 1
            } else {
                length += 1
                if length > maxLength {
                    maxLength = length
                    maxStart = start
                }
            }
        }
        
        maxLength += 1
        return [Int](sequence[maxStart...maxStart+maxLength-1])
    }
    
    private static func reciprocalDiffAverage(lis: [Int]) -> Float {
        var diffs = [Float]()
        let len = lis.count
        
        if len == 1 {
            return 1
        }
        
        for i in 0..<len-1 {
            diffs.append(1.0 / Float(lis[i+1] - lis[i]))
        }
        
        var totalDiff = Float(0)
        for diff in diffs {
            totalDiff += diff
        }
        
        return totalDiff / Float(len-1)
    }
    
    private static func longestHighlightLookforward(hsq: [Int], minLength: Int) -> [HighlightPosition] {
        let len = hsq.count
        if len == 1 {
            var hp = HighlightPosition(start: hsq[0], end: hsq[0] + minLength)
            return [hp]
        }
        
        var highlightSeq = hsq.sorted()
        var results = [HighlightPosition]()
        var j = 1
        var i = 0
        while i < len {
            while highlightSeq.count - 1 >= j
            && highlightSeq[j] - highlightSeq[j-1] <= minLength + 1
                && j < len {
                    j += 1
            }
            
            let hp = HighlightPosition(start: highlightSeq[i], end: highlightSeq[j-1])
            results.append(hp)
            i = j
            j += 1
        }
        return results
    }
}
