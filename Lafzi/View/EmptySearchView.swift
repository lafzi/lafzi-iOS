//
//  EmptySearchView.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 08/12/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

import UIKit

class EmptySearchView: UIView {

    @IBOutlet var mainContainer: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        Bundle.main.loadNibNamed("EmptySearchView", owner: self, options: nil)
        mainContainer.frame = self.frame
        addSubview(mainContainer)
    }
}
