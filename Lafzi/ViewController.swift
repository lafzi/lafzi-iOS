//
//  ViewController.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 28/11/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    //MARK: Properties
    var ayatGlobalQurans = [AyatQuran]()
    @IBInspectable var rowHeight = 70 {
        didSet {
            self.ayatTable.estimatedRowHeight = 70
            self.ayatTable.rowHeight = UITableView.automaticDimension
            self.ayatTable.separatorInset = UIEdgeInsets.zero
        }
    }
    @IBOutlet weak var ayatTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var labelCounter: UILabel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ayatTable.delegate = self
        self.ayatTable.dataSource = self
        
        self.searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let src = QueryHelper.normalizeQuery(src: searchBar.text!)
        let maxScore = src.count - 2
        
        var matchedDocs = [Int : FoundDocument]()
        var threshold = Float(0.9)
        repeat {
            print(threshold)
            matchedDocs = SearchHelper.doSearch(query: src, threshold: threshold)
            threshold -= 0.1
        } while (matchedDocs.count < 1) && (threshold >= 0.7)
        
        var matchedDocsValue = [FoundDocument]()
        var ayatQurans = [AyatQuran]()
        if matchedDocs.count > 0 {
            matchedDocs = SearchHelper.highlighting(matchedDocs: matchedDocs)
            matchedDocsValue = matchedDocs.map{ _, v in
                return v
            }
            matchedDocsValue.sort {left,right  in
                if (left.score - right.score) < 0.01 {
                    return left.ayatQuranId < right.ayatQuranId ? true : false
                }
                return left.score < right.score ? true : false
            }
            
            for doc in matchedDocsValue {
                let relevance = min(floor(doc.score / Float(maxScore * 100)), 100)
                let ayatQuran = doc.ayatQuran
                ayatQuran.relevance = relevance
                ayatQuran.highlightPos = doc.highlightPosition
                ayatQurans.append(ayatQuran)
            }
        }
        
        labelCounter.text = "Ditemukan \(ayatQurans.count) hasil."
        ayatGlobalQurans = ayatQurans
        self.view.endEditing(true)
        ayatTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.ayatTable.estimatedRowHeight = 70
        self.ayatTable.rowHeight = UITableView.automaticDimension
        self.ayatTable.separatorInset = UIEdgeInsets.zero
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ayatGlobalQurans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "ayatTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? AyatTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let ayatQuran = ayatGlobalQurans[indexPath.row]
        cell.ayatArabic.numberOfLines = 0
        cell.ayatArabic.lineBreakMode = .byWordWrapping
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
        cell.ayatArabic.attributedText = arabic
        
        cell.ayatIndonesia.numberOfLines = 0
        cell.ayatIndonesia.lineBreakMode = .byWordWrapping
        cell.ayatIndonesia.text = ayatQuran.ayatIndonesia
        cell.noSuratAyat.text = "\(ayatQuran.id). Surat \(ayatQuran.surahName) (\(ayatQuran.surahNo)) Ayat \(ayatQuran.ayatNo)"
        
        return cell
    }
}

