//
//  SharedScreenView.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 23/12/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

import UIKit

class SharedScreenView: UIView {

    @IBOutlet var mainContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var suratAyat: UILabel!
    @IBOutlet weak var ayatArabic: UILabel!
    @IBOutlet weak var ayatIndonesia: UILabel!
    
    var ayatQuran: AyatQuran = AyatQuran()
    
    init(frame: CGRect, ayatQuran: AyatQuran) {
        self.ayatQuran = ayatQuran
        super.init(frame: frame)
        Bundle.main.loadNibNamed("SharedScreenView", owner: self, options: nil)
        self.ayatArabic.lineBreakMode = .byWordWrapping
        self.ayatArabic.numberOfLines = 0
        self.ayatIndonesia.numberOfLines = 0
        self.ayatIndonesia.lineBreakMode = .byWordWrapping
        setupAyat()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupAyat() {
        self.suratAyat.text = "Surat \(self.ayatQuran.surahName) (\(self.ayatQuran.surahNo)) Ayat \(self.ayatQuran.ayatNo)"
        
        let ayat = ayatQuran.ayatMuqathaat.count < 1 ? ayatQuran.ayatArabic : ayatQuran.ayatMuqathaat
        let arabic = NSMutableAttributedString(string: ayat)
        
        
        self.ayatArabic.attributedText = arabic
        self.ayatArabic.font = UIFont(name: "me_quran", size: 22)
        
        
        self.ayatIndonesia.text = ayatQuran.ayatIndonesia
        
        self.mainContainer.frame = self.frame
        self.addSubview(self.mainContainer)
        self.layoutIfNeeded()
    }
    
    func asImage() -> UIImage {
        let savedContentOffset = scrollView.contentOffset
        let savedFrame = scrollView.frame
        
        //self.scrollView.contentOffset = CGPoint.zero
        self.scrollView.frame = CGRect(x: self.scrollView.frame.origin.x, y: self.scrollView.frame.origin.x, width: self.scrollView.frame.width, height: self.scrollView.contentSize.height)
        
        defer {
            scrollView.contentOffset = savedContentOffset
            scrollView.frame = savedFrame
        }
        
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: self.frame.width, height: self.scrollView.contentSize.height + 10))
            return renderer.image { rendererContext in
                self.layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(CGSize(width: self.frame.width, height: self.scrollView.contentSize.height + 10))
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }

}
