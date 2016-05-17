//
//  CharmStoreViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/16/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import KRLCollectionViewGridLayout

class CharmStoreViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var charmStoreVC:UICollectionViewController!
    
    var charmProducts:[CharmProduct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        charmStoreVC = UICollectionViewController()
        
        let layout = KRLCollectionViewGridLayout()
        layout.numberOfItemsPerLine = 2
        layout.aspectRatio = 1
        layout.interitemSpacing = 0
        layout.lineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        charmStoreVC.collectionView = TPKeyboardAvoidingCollectionView(frame: view.frame, collectionViewLayout: layout)
        charmStoreVC.collectionView?.frame = view.frame
        charmStoreVC.collectionView?.backgroundColor = UIColor.whiteColor()
        charmStoreVC.collectionView?.registerClass(ProductGalleryCollectionViewCell.self, forCellWithReuseIdentifier: "ProductGalleryCollectionViewCell")
        charmStoreVC.collectionView?.delegate = self
        charmStoreVC.collectionView?.dataSource = self
        charmStoreVC.collectionView?.contentInset.top = 44
        view.addSubview(charmStoreVC.collectionView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Collection View Data Source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductGalleryCollectionViewCell", forIndexPath: indexPath) as! ProductGalleryCollectionViewCell
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = Colors.separatorGray.CGColor
        return cell
    }
    
    // MARK: Colllection View Delegate
    

    
}
