//
//  DBHelper.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 02/12/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

import SQLite

class DBHelper {
    
    private static var instance: DBHelper = DBHelper()
    private var db: Connection
    
    private let id = Expression<Int>("_id")
    private let surahNo = Expression<Int>("surah_no")
    private let surahName = Expression<String>("surah_name")
    private let ayatNo = Expression<Int>("ayat_no")
    private let ayatArabic = Expression<String>("ayat_arabic")
    private let ayatIndonesian = Expression<String>("ayat_indonesian")
    private let ayatMuqathaat = Expression<String>("ayat_muqathaat")
    private let vocalPos = Expression<String>("vocal_mapping_position")
    private let nonvocalPos = Expression<String>("nonvocal_mapping_position")
    private let termTrigram = Expression<String>("term")
    private let postTrigram = Expression<String>("post")
    
    private init(){
        let path = Bundle.main.path(forResource: "lafzi", ofType: "sqlite")
        self.db = try! Connection(path!, readonly: true)
    }
    
    static func getInstance() -> DBHelper {
        return instance
    }
    
    func loadAllAyat(isVocal: Bool) -> [AyatQuran]{
        let ayatQurans = Table("ayat_quran")
        var arr = [AyatQuran]()
        for ayatQuran in try! db.prepare(ayatQurans) {
            let aq = AyatQuran(
                id: ayatQuran[id],
                surahNo: ayatQuran[surahNo],
                surahName: ayatQuran[surahName],
                ayatNo: ayatQuran[ayatNo],
                ayatArabic: ayatQuran[ayatArabic],
                ayatIndonesia: ayatQuran[ayatIndonesian],
                ayatMuqathaat: ayatQuran[ayatMuqathaat],
                mappingPos: isVocal ? ayatQuran[vocalPos] : ayatQuran[nonvocalPos]
            )
            arr.append(aq)
        }
        return arr
    }
    
    func getIndexByTrigram(trigram: String, isVocal: Bool) -> Index? {
        let indices = isVocal ? Table("vocal_index") : Table("nonvocal_index")
        let query = indices.filter(termTrigram.like(trigram))
        
        var term: String
        var post: [Int : [Int]]
        for row in try! db.prepare(query) {
            let data = Data(base64Encoded: row[postTrigram])
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            post = json as! [Int : [Int]]
            print(post)
            
            term = row[termTrigram]
            return Index(term: term, post: post)
        }
        return nil
    }
}
