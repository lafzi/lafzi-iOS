//
//  PopoverOptions.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 12/12/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

import UIKit

class PopoverOptions: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var popover: Popover
    let options = ["Bantuan", "Pengaturan", "Tentang Lafzi"]
    var controller = ViewController(nibName: nil, bundle: nil)
    
    init(frame: CGRect, style: UITableView.Style, popover: Popover, controller: ViewController) {
        self.popover = popover
        self.controller = controller
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.isScrollEnabled = false
        self.separatorInset = .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.popover = Popover(options: nil)
        super.init(coder: aDecoder)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        popover.dismiss()
        switch indexPath.row {
        case 0:
            let bantuanViewController = controller.storyboard?.instantiateViewController(withIdentifier: "bantuanViewController") as! BantuanViewController
            bantuanViewController.html = NSLocalizedString("HELP NOTE", comment: "")
            controller.navigationController?.pushViewController(bantuanViewController, animated: true)
        case 1:
            let settingController = SettingsViewController(style: .grouped)
            controller.reloadData = true
            controller.navigationController?.pushViewController(settingController, animated: true)
        case 2:
            let bantuanViewController = controller.storyboard?.instantiateViewController(withIdentifier: "bantuanViewController") as! BantuanViewController
            bantuanViewController.html = NSLocalizedString("ABOUT NOTE", comment: "")
            controller.navigationController?.pushViewController(bantuanViewController, animated: true)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = self.options[indexPath.row]
        cell.textLabel?.textAlignment = .right
        return cell
    }
}
