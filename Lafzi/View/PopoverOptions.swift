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
    var handler: (_: UITableView, _: IndexPath) -> Void
    
    init(frame: CGRect, style: UITableView.Style, popover: Popover, handler: @escaping (_ tableView: UITableView, _ indexPath: IndexPath) -> Void) {
        self.popover = popover
        self.handler = handler
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.isScrollEnabled = false
        self.separatorInset = .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.popover = Popover(options: nil)
        self.handler = {(tableView: UITableView, didSelectRowAt: IndexPath) in
            
        }
        super.init(coder: aDecoder)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handler(tableView, indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = self.options[indexPath.row]
        cell.textLabel?.textAlignment = .right
        return cell
    }
}
