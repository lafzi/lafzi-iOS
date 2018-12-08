//
//  File.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 30/11/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

class AyatQuran {
    var id: Int = 0
    var surahNo: Int = 0
    var surahName: String = ""
    var ayatNo: Int = 0
    var ayatArabic: String = ""
    var ayatIndonesia: String = ""
    var ayatMuqathaat: String = ""
    var mappingPos: [Int] = [Int]()
    
    var highlightPos = [HighlightPosition]()
    var relevance = Float(0)
    
    init() {}
    
    init(id: Int, surahNo: Int, surahName: String, ayatNo: Int, ayatArabic: String, ayatIndonesia: String, ayatMuqathaat: String, mappingPos: String) {
        self.id = id
        self.surahNo = surahNo
        self.surahName = surahName
        self.ayatNo = ayatNo
        self.ayatArabic = ayatArabic
        self.ayatIndonesia = ayatIndonesia
        self.ayatMuqathaat = ayatMuqathaat
        self.mappingPos = [Int]()
        for mp in mappingPos.split(separator: ",") {
            let intStr = Int(mp)
            self.mappingPos.append(intStr!)
        }
    }
    
}
