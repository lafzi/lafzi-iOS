//
//  File.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 16/12/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

import UIKit

class SingleAyatController: UIViewController {
    
    @IBOutlet weak var noSuratAyat: UILabel!
    @IBOutlet weak var ayatArabic: UILabel!
    @IBOutlet weak var ayatIndonesia: UILabel!
    
    var currentAyat = 1
    
    override func viewDidLoad() {
        print(currentAyat)
        let ayatQuran = DBHelper.getInstance().getAyatQuran(ayatId: currentAyat, isVocal: UserDefaults.standard.bool(forKey: SettingsViewController.IS_VOCAL))
        
        self.noSuratAyat.text = "Surat \(ayatQuran.surahName) (\(ayatQuran.surahNo)) Ayat \(ayatQuran.ayatNo)"
        
        self.ayatArabic.lineBreakMode = .byWordWrapping
        self.ayatArabic.numberOfLines = 0
        
        let ayat = ayatQuran.ayatMuqathaat.count < 1 ? ayatQuran.ayatArabic : ayatQuran.ayatMuqathaat
        let arabic = NSMutableAttributedString(string: ayat)
        for pos in ayatQuran.highlightPos {
            var start = pos.start
            var end = pos.end
            if start > arabic.length {
                start = arabic.length - 1
            }
            if end > arabic.length {
                end = arabic.length - 1
            }
            let range = NSRange(location: start, length: end - start + 1)
            arabic.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.yellow, range: range)
        }
        
        self.ayatArabic.attributedText = arabic
        ayatArabic.font = UIFont(name: "me_quran", size: 22)
        
        self.ayatIndonesia.numberOfLines = 0
        self.ayatIndonesia.lineBreakMode = .byWordWrapping
        self.ayatIndonesia.text = ayatQuran.ayatIndonesia
    }
}
