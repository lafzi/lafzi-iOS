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
    var ayatQurans = [AyatQuran]()
    @IBInspectable var rowHeight = 70 {
        didSet {
            self.ayatTable.estimatedRowHeight = 70
            self.ayatTable.rowHeight = UITableView.automaticDimension
            self.ayatTable.separatorInset = UIEdgeInsets.zero
        }
    }
    @IBOutlet weak var ayatTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ayatTable.delegate = self
        self.ayatTable.dataSource = self
        
        self.searchBar.delegate = self
        loadSample()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var src = QueryHelper.normalizeQuery(src: searchBar.text!)
        SearchHelper.doSearch(query: src)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.ayatTable.estimatedRowHeight = 70
        self.ayatTable.rowHeight = UITableView.automaticDimension
        self.ayatTable.separatorInset = UIEdgeInsets.zero
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ayatQurans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "ayatTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? AyatTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let ayatQuran = ayatQurans[indexPath.row]
        cell.ayatArabic.numberOfLines = 0
        cell.ayatArabic.lineBreakMode = .byWordWrapping
        cell.ayatArabic.text = ayatQuran.ayatMuqathaat.count < 1 ? ayatQuran.ayatArabic : ayatQuran.ayatMuqathaat
        cell.ayatIndonesia.numberOfLines = 0
        cell.ayatIndonesia.lineBreakMode = .byWordWrapping
        cell.ayatIndonesia.text = ayatQuran.ayatIndonesia
        cell.noSuratAyat.text = "\(ayatQuran.id). Surat \(ayatQuran.surahName) (\(ayatQuran.surahNo)) Ayat \(ayatQuran.ayatNo)"
        
        return cell
    }
    
    private func loadSample() {
        ayatQurans = DBHelper.getInstance().loadAllAyat(isVocal: true)
    }
}

