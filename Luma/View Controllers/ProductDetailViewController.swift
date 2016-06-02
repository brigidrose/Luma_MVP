//
//  ProductDetailViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/17/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SDWebImage
import BBBadgeBarButtonItem

class ProductDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {

    var product:Product!
    
    var tableVC:UITableViewController!
    var actionButton:UIButton!
    
    var productImageURL:[String] = []
    
    var productFeatures:[(String, String)] = [("Feature Highlight 1", "Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum"), ("Feature Highlight 2", "Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum")]
    var productReviews:[(String, LumaUser)] = [("Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum", LumaUser()),("Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum", LumaUser())]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Detail"
        let bagButton = UIButton(frame: CGRectMake(0,0,24,30))
        // load appropriate image on bag items count
        bagButton.setImage(UIImage(named: "bagBarButtonItemEmpty"), forState: UIControlState.Normal)
        bagButton.addTarget(self, action: #selector(LumaStoreViewController.bagBarButtonItemTapped(_:)), forControlEvents: .TouchUpInside)
        let bagBarButtonItem = BBBadgeBarButtonItem(customUIButton: bagButton)
        bagBarButtonItem.badgeValue = "0"
        navigationItem.rightBarButtonItem = bagBarButtonItem
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        tableVC = UITableViewController()
        addChildViewController(tableVC)
        tableVC.tableView = TPKeyboardAvoidingTableView()
        tableVC.tableView.frame = view.frame
        tableVC.tableView.backgroundColor = UIColor.whiteColor()
        tableVC.tableView.clipsToBounds = false
        tableVC.tableView.contentInset.bottom = 92
        tableVC.tableView.delegate = self
        tableVC.tableView.dataSource = self
        tableVC.tableView.registerClass(ProductTitleTableViewCell.self, forCellReuseIdentifier: "ProductTitleTableViewCell")
        tableVC.tableView.registerClass(ProductImageGalleryTableViewCell.self, forCellReuseIdentifier: "ProductImageGalleryTableViewCell")
        tableVC.tableView.registerClass(ProductFeatureTableViewCell.self, forCellReuseIdentifier: "ProductFeatureTableViewCell")
        tableVC.tableView.registerClass(ProductReviewTableViewCell.self, forCellReuseIdentifier: "ProductReviewTableViewCell")
        tableVC.tableView.rowHeight = UITableViewAutomaticDimension
        tableVC.tableView.estimatedRowHeight = 100
        tableVC.tableView.separatorStyle = .None
        view.addSubview(tableVC.tableView)
        
        actionButton = UIButton(frame: CGRectZero)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setButtonType("primary")
        actionButton.setTitle("Purchase for $\(product.price)", forState: .Normal)
        actionButton.addTarget(self, action: #selector(ProductDetailViewController.actionButtonTapped(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(actionButton)
        let metricsDictionary = ["sidePadding":20]
        
        let noFeedActionButtonH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[actionButton]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: ["actionButton" : actionButton])
        view.addConstraints(noFeedActionButtonH)
        let noFeedActionButtonV = NSLayoutConstraint.constraintsWithVisualFormat("V:[actionButton(56)]-36-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: ["actionButton" : actionButton])
        view.addConstraints(noFeedActionButtonV)
        
        productImageURL = ["https://9to5mac.files.wordpress.com/2016/05/aapl.jpg?w=2500&h=0#038;h=500", "https://9to5mac.files.wordpress.com/2016/05/aapl.jpg?w=2500&h=0#038;h=500", "https://9to5mac.files.wordpress.com/2016/05/aapl.jpg?w=2500&h=0#038;h=500"]
        
        
    }
    
    func actionButtonTapped(sender:UIButton) {
        print("buy bracelet button tapped")
        sender.enabled = false
        // add bracelet to bag in model
        // update bag icon in nav bar
        // if bag is empty, set image to non-empty bag icon, else empty
        
        updateBagBarButtonItem()
        
        sender.enabled = true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bagBarButtonItemTapped(sender:BBBadgeBarButtonItem) {
        print("bag bar button item tapped")
        
        let bagDetailVC = BagDetailViewController()
        navigationController?.pushViewController(bagDetailVC, animated: true)
    }
    
    // MARK: Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch  section {
        case 0:
            return 2
        case 1:
            return productFeatures.count
        case 2:
            return productReviews.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.item == 0{
                // product name and delivery info
                let cell = tableView.dequeueReusableCellWithIdentifier("ProductTitleTableViewCell") as! ProductTitleTableViewCell
                cell.productTitleLabel.text = product.name
                if product.deliveryDays > 1{
                    cell.productSubtitleLabel.text = "Delivers in \(product.deliveryDays) Business Days"
                }
                else if product.deliveryDays == 0{
                    cell.productSubtitleLabel.text = "Out of Stock"
                }
                else{
                    cell.productSubtitleLabel.text = "Delivers in 1 Business Day"
                }
                
                return cell
            }
            else{
                // product image gallery
                let cell = tableView.dequeueReusableCellWithIdentifier("ProductImageGalleryTableViewCell") as! ProductImageGalleryTableViewCell
                cell.galleryCollectionView.delegate = self
                cell.galleryCollectionView.dataSource = self
                cell.pageControl.numberOfPages = productImageURL.count
                return cell
            }
        case 1:
            // product features
            let cell = tableView.dequeueReusableCellWithIdentifier("ProductFeatureTableViewCell") as! ProductFeatureTableViewCell
            let productFeature = productFeatures[indexPath.row]
            cell.featureTitleLabel.text = productFeature.0
            cell.featureTitleLabel.textAlignment = .Center
            cell.featureBodyLabel.text = productFeature.1
            return cell
        case 2:
            // product reviews
            let cell = tableView.dequeueReusableCellWithIdentifier("ProductReviewTableViewCell") as! ProductReviewTableViewCell
            let productReview = productReviews[indexPath.row]
//            cell.reviewAuthorLabel.text = productReview.1.username
            cell.reviewContentLabel.text = productReview.0
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    // MARK: Table View Delegate
    

    // MARK: Collection View Data Source
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCollectionViewCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        cell.collectionImageView.sd_setImageWithURL(NSURL(string: ""), placeholderImage: UIImage(named: "galleryImagePlaceholder")) { (image, erroe, cacheType, url) in
        if cacheType == .None{
            cell.collectionImageView.alpha = 0
            UIView.animateWithDuration(0.35, animations: { 
                cell.collectionImageView.alpha = 1
            }
        )}
        cell.isHeightCalculated = false
        }
        return cell

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImageURL.count
    }
    
    // MARK: Collection View Delegate

    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        if tableVC.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) != nil{
            let pageControl = (tableVC.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as! ProductImageGalleryTableViewCell).pageControl
            if scrollView.isMemberOfClass(UICollectionView){
                let pageWidth:CGFloat = scrollView.frame.size.width
                let currentPage:CGFloat = scrollView.contentOffset.x / pageWidth
                
                if (currentPage % 1.0 != 0.0)
                {
                    pageControl.currentPage = Int(currentPage) + 1
                }
                else
                {
                    pageControl.currentPage = Int(currentPage)
                }
            }

        }


    }
    
    func updateBagBarButtonItem(){
        let bagButton = UIButton(frame: CGRectMake(0,0,24,30))
        // load appropriate image on bag items count
        bagButton.setImage(UIImage(named: "bagBarButtonItem"), forState: UIControlState.Normal)
        bagButton.addTarget(self, action: #selector(LumaStoreViewController.bagBarButtonItemTapped(_:)), forControlEvents: .TouchUpInside)
        let nonEmptyBagBarButtonItem = BBBadgeBarButtonItem(customUIButton: bagButton)
        nonEmptyBagBarButtonItem.badgeValue = "\(Int((navigationItem.rightBarButtonItem as! BBBadgeBarButtonItem).badgeValue)! + 1)"
        nonEmptyBagBarButtonItem.badgeOriginX = 1.5
        nonEmptyBagBarButtonItem.badgeOriginY = 9
        nonEmptyBagBarButtonItem.badgeBGColor = UIColor.clearColor()
        nonEmptyBagBarButtonItem.badgeFont = UIFont.systemFontOfSize(14)
        navigationItem.setRightBarButtonItem(nonEmptyBagBarButtonItem, animated: true)
        
    }

}
