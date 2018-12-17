//
//  SettingsViewController.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 14/12/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

import UIKit
import QuickTableViewController

class SettingsViewController: QuickTableViewController {

    let defaults = UserDefaults.standard
    static let IS_VOCAL = "isVocal"
    static let SHOW_TRANSLATION = "showTranslation"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableContents = [
            Section(title: "Pengaturan", rows: [
                SwitchRow(title: "Perhitungkan huruf vokal", switchValue: defaults.bool(forKey: SettingsViewController.IS_VOCAL), action: { _ in
                    self.defaults.set(!self.defaults.bool(forKey: SettingsViewController.IS_VOCAL), forKey: SettingsViewController.IS_VOCAL)
                }),
                SwitchRow(title: "Tampilkan terjemahan", switchValue: defaults.bool(forKey: SettingsViewController.SHOW_TRANSLATION), action: { _ in
                    self.defaults.set(!self.defaults.bool(forKey: SettingsViewController.SHOW_TRANSLATION), forKey: SettingsViewController.SHOW_TRANSLATION)
                })
            ])
        ]
    }

}
