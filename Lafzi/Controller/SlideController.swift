//
//  SlideController.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 16/12/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

import UIKit

class SlideController: UIPageViewController, UIPageViewControllerDataSource {
    
    var currentAyatId = 1
    var singleAyat = SingleAyatController()
    
    override func viewDidLoad() {
        self.dataSource = self
        setupFloatButton()

        self.singleAyat = (storyboard?.instantiateViewController(withIdentifier: "SingleAyatController") as? SingleAyatController)!
        singleAyat.currentAyat = currentAyatId
        setViewControllers([singleAyat], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextCtrl = viewController as? SingleAyatController
        let nextAyatId = (nextCtrl?.currentAyat)! + 1
        if nextAyatId >= 6236 {
            return nil
        }
        
        let singleAyatNext = (storyboard?.instantiateViewController(withIdentifier: "SingleAyatController") as? SingleAyatController)!
        singleAyatNext.currentAyat = nextAyatId
        return singleAyatNext
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let prevCtrl = viewController as? SingleAyatController
        let prevAyatId = (prevCtrl?.currentAyat)! - 1
        if prevAyatId <= 0 {
            return nil
        }
        
        let singleAyatPrev = (storyboard?.instantiateViewController(withIdentifier: "SingleAyatController") as? SingleAyatController)!
        singleAyatPrev.currentAyat = prevAyatId
        return singleAyatPrev
    }
    
    
    func setupFloatButton() {
        let floaty = Floaty()
        //floaty.open()
        let accentColor = Util.hexStringToUIColor(hex: "#005500", alpha: 0.2)
        
        floaty.buttonColor = accentColor
        floaty.itemButtonColor = accentColor
        floaty.plusColor = UIColor.black
        floaty.itemImageColor = UIColor.black
        floaty.autoCloseOnTap = false
        floaty.itemSize = floaty.size
        floaty.buttonImage = UIImage(named: "three-dots")
        
        floaty.addItem(icon: UIImage(imageLiteralResourceName: "right-arrow"), handler: {item in
            let ctrl = self.pageViewController(self, viewControllerAfter: self.singleAyat)
            self.singleAyat.currentAyat += 1
            self.setViewControllers([ctrl!], direction: .forward, animated: true, completion: nil)
        })
        floaty.addItem(icon: UIImage(imageLiteralResourceName: "left-arrow"), handler: {item in
            let ctrl = self.pageViewController(self, viewControllerBefore: self.singleAyat)
            self.singleAyat.currentAyat -= 1
            self.setViewControllers([ctrl!], direction: .reverse, animated: true, completion: nil)
        })
        floaty.addItem(icon: UIImage(imageLiteralResourceName: "share"), handler: {item in
            print("SHARE")

        })
        
        self.view.addSubview(floaty)
    }
}
