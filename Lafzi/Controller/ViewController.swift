//
//  ViewController.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 28/11/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

import UIKit

class ViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    //MARK: Properties
    var ayatGlobalQurans = [AyatQuran]()
    var grayStripeColor = Util.hexStringToUIColor(hex: "#f4f4f4")
    var reloadData = false
    let defaults = UserDefaults.standard
    
    @IBInspectable var rowHeight = 70 {
        didSet {
            self.ayatTable.rowHeight = UITableView.automaticDimension
            self.ayatTable.separatorInset = UIEdgeInsets.zero
        }
    }
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var ayatTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var labelCounterContainer: UIStackView!
    @IBOutlet weak var labelCounter: UILabel!
    
    // MARK: handle lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.register(defaults: [SettingsViewController.IS_VOCAL : true, SettingsViewController.SHOW_TRANSLATION : true])
        
        ayatTable.delegate = self
        ayatTable.dataSource = self
        
        searchBar.delegate = self
        ayatTable.separatorStyle = .none
        
        let searchHelperView = SearchHelperView(controller: self)
        ayatTable.backgroundView = searchHelperView
        setupOptionsMenu()
        self.searchBar.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if reloadData && !searchBar.text!.isEmpty {
            searchBarSearchButtonClicked(searchBar)
            self.reloadData = false
        }
    }
    
    // MARK: Searchbar delegate method
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        self.view.endEditing(true)
        let sv = ViewController.displaySpinner(onView: self.ayatTable)
        DispatchQueue.global(qos: .background).async {
            self.search(txt: text!)
            DispatchQueue.main.async {
                self.labelCounter.text = "Ditemukan \(self.ayatGlobalQurans.count) hasil."
                self.ayatTable.reloadData()
                if self.ayatGlobalQurans.count < 1 {
                    self.showEmptyMessage()
                } else {
                    self.ayatTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                    self.hideEmptyMessage()
                }
            }
            ViewController.removeSpinner(spinner: sv)
        }
    }

    
    // MARK: Table View Delegate method
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ayatGlobalQurans.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PageViewControllerSegue", sender: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "ayatTableViewCell"
        let showTrans = defaults.bool(forKey: SettingsViewController.SHOW_TRANSLATION)
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
        cell.ayatArabic.font = UIFont(name: "me_quran", size: 22)
        if showTrans {
            cell.ayatIndonesia.numberOfLines = 0
            cell.ayatIndonesia.lineBreakMode = .byWordWrapping
            cell.ayatIndonesia.text = ayatQuran.ayatIndonesia
            cell.ayatIndonesia.isHidden = false
        } else {
            cell.ayatIndonesia.isHidden = true
        }
        cell.noSuratAyat.text = "\(indexPath.row + 1). Surat \(ayatQuran.surahName) (\(ayatQuran.surahNo)) Ayat \(ayatQuran.ayatNo)"
        if indexPath.row % 2 != 0 {
            cell.backgroundColor = grayStripeColor
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    // MARK: Private functions
    
    private func showEmptyMessage() {
        ayatTable.backgroundView = EmptySearchView()
        ayatTable.separatorStyle = .none
        labelCounterContainer.isHidden = true
    }
    
    private func hideEmptyMessage() {
        ayatTable.backgroundView = nil
        ayatTable.estimatedRowHeight = 70
        ayatTable.rowHeight = UITableView.automaticDimension
        labelCounterContainer.isHidden = false
    }
    
    private func search(txt: String) {
        let isVocal = defaults.bool(forKey: SettingsViewController.IS_VOCAL)
        let src = QueryHelper.normalizeQuery(src: txt, isVocal: isVocal)
        let maxScore = src.count - 2
        
        var matchedDocs = [Int : FoundDocument]()
        var threshold = Float(0.9)
        repeat {
            matchedDocs = SearchHelper.doSearch(query: src, isVocal: isVocal, threshold: threshold)
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
                if abs(left.score - right.score) < 0.001 {
                    return left.ayatQuranId < right.ayatQuranId
                }
                return left.score > right.score
            }
            
            for doc in matchedDocsValue {
                let relevance = min(floor(doc.score / Float(maxScore * 100)), 100)
                let ayatQuran = doc.ayatQuran
                ayatQuran.relevance = relevance
                ayatQuran.highlightPos = doc.highlightPosition
                ayatQurans.append(ayatQuran)
            }
        }
        ayatGlobalQurans = ayatQurans
    }
    
    private func setupOptionsMenu() {
        let button = UIBarButtonItem(image: UIImage(named: "three-dots"), style: .plain, target: self, action: #selector(openPopover(sender:)))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func openPopover(sender: UIBarButtonItem) {
        let startPoint = CGPoint(x: self.view.frame.width - 30, y: self.navigationController?.navigationBar.frame.size.height ?? 55)
        let popover = Popover(options: [.type(.auto)])
        let popoverOptions = PopoverOptions(frame: CGRect(x: 100, y: 0, width: 135, height: 150), style: UITableView.Style.plain, popover: popover, controller: self)
        popover.show(popoverOptions, point: startPoint)
    }
    
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        DispatchQueue.main.async {
            spinnerView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)
            let ai = UIActivityIndicatorView.init(style: .whiteLarge)
            ai.color = UIColor.black
            ai.startAnimating()
            ai.center = spinnerView.center
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PageViewControllerSegue" {
            let slideController = segue.destination as! SlideController
            let ayatId = self.ayatGlobalQurans[(self.ayatTable.indexPathForSelectedRow?.row)!].id

            slideController.currentAyatId = ayatId
        }
    }
}

