//
//  SlideController.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 16/12/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

import UIKit

class SlideController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var currentAyatId = 1
    var lastPendingAyatId = 1
    var singleAyat = SingleAyatController()
    
    override func viewDidLoad() {
        self.dataSource = self
        self.delegate = self
        setupFloatButton()

        self.singleAyat = (storyboard?.instantiateViewController(withIdentifier: "SingleAyatController") as? SingleAyatController)!
        singleAyat.currentAyat = currentAyatId
        setViewControllers([singleAyat], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextAyatId = self.currentAyatId + 1
        if nextAyatId > 6236 {
            return nil
        }
        
        let singleAyatNext = (storyboard?.instantiateViewController(withIdentifier: "SingleAyatController") as? SingleAyatController)!
        singleAyatNext.currentAyat = nextAyatId
        return singleAyatNext
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let prevAyatId = self.currentAyatId - 1
        if prevAyatId < 1 {
            return nil
        }
        
        let singleAyatPrev = (storyboard?.instantiateViewController(withIdentifier: "SingleAyatController") as? SingleAyatController)!
        singleAyatPrev.currentAyat = prevAyatId
        return singleAyatPrev
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let vc = pendingViewControllers[0] as? SingleAyatController {
            self.lastPendingAyatId = vc.currentAyat
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            self.currentAyatId = self.lastPendingAyatId
        }
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
            if self.currentAyatId + 1 > 6236 {
                return
            }
            self.currentAyatId += 1
            self.setViewControllers([ctrl!], direction: .forward, animated: true, completion: nil)
        })
        floaty.addItem(icon: UIImage(imageLiteralResourceName: "left-arrow"), handler: {item in
            let ctrl = self.pageViewController(self, viewControllerBefore: self.singleAyat)
            if self.currentAyatId - 1 < 1 {
                return
            }
            self.currentAyatId -= 1
            self.setViewControllers([ctrl!], direction: .reverse, animated: true, completion: nil)
        })
        floaty.addItem(icon: UIImage(imageLiteralResourceName: "share"), handler: {item in
            let alert = UIAlertController(title: "Bagikan Ayat", message: "Pilih jenis yang dibagikan", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Teks", style: .default, handler: {but in
                let ctrl = self.viewControllers![0] as? SingleAyatController
                let texts = "\(ctrl?.noSuratAyat.text ?? "")\n\n\(ctrl?.ayatArabic.text ?? "")\n\n\(ctrl?.ayatIndonesia.text ?? "")\n\n(Dibagikan dari aplikasi Lafzi)"
                self.share(objects: [texts], source: ctrl?.view)
            }))
            alert.addAction(UIAlertAction(title: "Gambar", style: .default, handler: {but in
                let ayatQuran = DBHelper.getInstance().getAyatQuran(ayatId: self.currentAyatId)
                let ssView = SharedScreenView(frame: self.view.bounds, ayatQuran: ayatQuran)
                let ss = ssView.asImage()
                let ctrl = self.viewControllers![0] as? SingleAyatController
                self.share(objects: [ss], source: ctrl?.view)
            }))
            self.present(alert, animated: true, completion: nil)
        })
        
        self.view.addSubview(floaty)
    }
    
    private func share(objects: [Any], source: UIView?) {
        let activityVC = UIActivityViewController(activityItems: objects, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = source
        self.present(activityVC, animated: true, completion: nil)
    }
}
