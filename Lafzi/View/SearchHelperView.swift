//
//  SearchHelperView.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 14/12/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

import UIKit

class SearchHelperView: UIView {
    
    @IBOutlet var mainContainer: UIView!
    @IBOutlet weak var label: UILabel!
    
    var texts = ["bismillaah", "wal qur'anil hakim", "alif lam ro", "iqro' bismirobbika", "kun fayakun",
                 "fabiayyi aala'i robbikumaa", "fir'aun", "wamallam yahkum bima anzala"]
    
    var loop = true
    var controller = ViewController()
    var currentExample = ""
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SearchHelperView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    init(controller: ViewController) {
        self.controller = controller
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    func setupView() {
        Bundle.main.loadNibNamed("SearchHelperView", owner: self, options: nil)
        setupLabelTapRecognizer()
        
        texts.shuffle()
        let labelAttr = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        var str = NSAttributedString(string: texts[7] + " \u{25B6}", attributes: labelAttr)
        
        self.currentExample = self.texts[7]
        self.label.attributedText = str
        
        
        DispatchQueue.global(qos: .background).async {
            var i = 0
            while self.loop {
                sleep(4)
                let animation = CATransition()
                
                animation.type = CATransitionType.fade
                animation.subtype = CATransitionSubtype.fromTop
                animation.duration = 1
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

                DispatchQueue.main.async {
                    if i >= self.texts.count {
                        i = 0
                    }
                    self.currentExample = self.texts[i]
                    str = NSAttributedString(string: self.currentExample + " \u{25B6}", attributes: labelAttr)
                    self.label.attributedText = str
                    i += 1
                    self.label.layer.add(animation, forKey: "animation")
                }
            }
        }
        mainContainer.frame = self.frame
        self.addSubview(mainContainer)
    }
    
    func setupLabelTapRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.label.isUserInteractionEnabled = true
        self.label.addGestureRecognizer(gesture)
    }
    
    @objc func tapAction() {
        self.loop = false
        self.controller.searchBar.text = currentExample
        self.controller.searchBarSearchButtonClicked(self.controller.searchBar)
    }
}
