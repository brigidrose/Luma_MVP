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
    
    var models:[Model] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0...4{
            let charmProduct = Model()
            charmProduct.name = "Charm \(i + 1)"
            charmProduct.price = 50.0 * Float(i + 1) - 0.01
            charmProduct.deliveryDays = i + 1
            models.append(charmProduct)
        }
        
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
        charmStoreVC.collectionView?.alwaysBounceVertical = true
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
        return models.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductGalleryCollectionViewCell", forIndexPath: indexPath) as! ProductGalleryCollectionViewCell
        cell.nameLabel.text = "\(models[indexPath.item].name)"
        cell.priceLabel.text = "$\(models[indexPath.item].price)"
        return cell
    }
    
    // MARK: Colllection View Delegate
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ProductGalleryCollectionViewCell
        UIView.animateWithDuration(0.15) {
            cell.backgroundColor = Colors.offWhite
        }
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ProductGalleryCollectionViewCell
        UIView.animateWithDuration(0.15) {
            cell.backgroundColor = UIColor.clearColor()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let productDetailVC = ProductDetailViewController()
        productDetailVC.product = models[indexPath.item]
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
}
