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
    
    override func viewDidLoad() {
        self.dataSource = self
        let singleAyat = storyboard?.instantiateViewController(withIdentifier: "SingleAyatController") as? SingleAyatController
        singleAyat?.currentAyat = currentAyatId
        setViewControllers([singleAyat!], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextCtrl = viewController as? SingleAyatController
        let nextAyatId = (nextCtrl?.currentAyat)! + 1
        if nextAyatId >= 6236 {
            return nil
        }
        let singleAyat = storyboard?.instantiateViewController(withIdentifier: "SingleAyatController") as? SingleAyatController
        singleAyat?.currentAyat = nextAyatId
        return singleAyat
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let prevCtrl = viewController as? SingleAyatController
        let prevAyatId = (prevCtrl?.currentAyat)! - 1
        if prevAyatId <= 0 {
            return nil
        }
        let singleAyat = storyboard?.instantiateViewController(withIdentifier: "SingleAyatController") as? SingleAyatController
        singleAyat?.currentAyat = prevAyatId
        return singleAyat
    }
    
}
