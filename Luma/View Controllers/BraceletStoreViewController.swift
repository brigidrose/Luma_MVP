//
//  BraceletStoreViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/16/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import Parse
import BBBadgeBarButtonItem

class BraceletStoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    var tableVC:UITableViewController!
    var actionButton:UIButton!
    
    var braceletFeatures:[(String, String)] = [("Feature Highlight 1", "Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum"), ("Feature Highlight 2", "Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum")]
    var braceletReviews:[(String, LumaUser)] = [("Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum", LumaUser()),("Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum", LumaUser())]

    var purchaseFormShown:Bool = false
    var purchaseFormSegmentedControl:UISegmentedControl!
    
    var isGift:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableVC = UITableViewController()
        addChildViewController(tableVC)
        tableVC.tableView = UITableView()
        tableVC.automaticallyAdjustsScrollViewInsets = false
        tableVC.tableView.frame = view.frame
        tableVC.tableView.backgroundColor = UIColor.whiteColor()
        tableVC.tableView.clipsToBounds = false
        tableVC.tableView.contentInset.top = 44
        tableVC.tableView.contentInset.bottom = 64 + 92
        tableVC.tableView.delegate = self
        tableVC.tableView.dataSource = self
        tableVC.tableView.registerClass(ProductHeadlineTableViewCell.self, forCellReuseIdentifier: "ProductHeadlineTableViewCell")
        tableVC.tableView.registerClass(ProductFeatureTableViewCell.self, forCellReuseIdentifier: "ProductFeatureTableViewCell")
        tableVC.tableView.registerClass(ProductReviewTableViewCell.self, forCellReuseIdentifier: "ProductReviewTableViewCell")
        tableVC.tableView.registerClass(AddressFormTableViewCell.self, forCellReuseIdentifier: "AddressFormTableViewCell")
        tableVC.tableView.registerClass(SingleLineTextFieldTableViewCell.self, forCellReuseIdentifier: "SingleLineTextFieldTableViewCell")
        tableVC.tableView.registerClass(MultilineTextViewTableViewCell.self, forCellReuseIdentifier: "MultilineTextViewTableViewCell")
        tableVC.tableView.registerClass(TitleSeparatorTableViewCell.self, forCellReuseIdentifier: "TitleSeparatorTableViewCell")
        tableVC.tableView.rowHeight = UITableViewAutomaticDimension
        tableVC.tableView.estimatedRowHeight = 140
        tableVC.tableView.separatorStyle = .None
        view.addSubview(tableVC.tableView)
        
        actionButton = UIButton(frame: CGRectZero)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setButtonType("primary")
        actionButton.setTitle("Purchase for $149", forState: .Normal)
        actionButton.addTarget(self, action: #selector(BraceletStoreViewController.actionButtonTapped(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(actionButton)
        let metricsDictionary = ["sidePadding":20]
        
        let noFeedActionButtonH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[actionButton]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: ["actionButton" : actionButton])
        view.addConstraints(noFeedActionButtonH)
        let noFeedActionButtonV = NSLayoutConstraint.constraintsWithVisualFormat("V:[actionButton(56)]-36-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: ["actionButton" : actionButton])
        view.addConstraints(noFeedActionButtonV)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func actionButtonTapped(sender:UIButton) {
        print("buy bracelet button tapped")
        sender.enabled = false
        if !purchaseFormShown{
            purchaseFormShown = true
            // show purchase form section
            tableVC.tableView.beginUpdates()
            tableVC.tableView.insertSections(NSMutableIndexSet(indexesInRange: NSRange(3...4)), withRowAnimation: .Bottom)
            tableVC.tableView.endUpdates()
            tableVC.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 3), atScrollPosition: .Top, animated: true)
            // set actionButton title to "Add to Bag" and enable = false
            actionButton.setTitle("Add to Bag", forState: .Normal)
            actionButton.enabled = false
        }
        // add bracelet to bag in model
        // update bag icon in nav bar
        // if bag is empty, set image to non-empty bag icon, else empty
        (parentViewController!.parentViewController! as! LumaStoreViewController).updateBagBarButtonItem()
        
        sender.enabled = true
    }
    
    func bagBarButtonItemTapped(sender:BBBadgeBarButtonItem) {
        print("bagBarButtonItemTapped")
    }

    // MARK: Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if purchaseFormShown{
            return 5
        }
        else{
            return 3
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            // headline
            return 1
        case 1:
            // features
            return braceletFeatures.count
        case 2:
            // review
            return braceletReviews.count
        case 3:
            // purchase form
            return 1
        case 4:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            // bracelet headline
            let cell = tableView.dequeueReusableCellWithIdentifier("ProductHeadlineTableViewCell") as! ProductHeadlineTableViewCell
            cell.productNameLabel.text = "Luma Bracelet"
            cell.productInfoLabel.text = "Delivers in 7 Business Days"
            cell.productSummaryLabel.text = "Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum"
            return cell
        case 1:
            // bracelet features
            let cell = tableView.dequeueReusableCellWithIdentifier("ProductFeatureTableViewCell") as! ProductFeatureTableViewCell
            cell.featureTitleLabel.text = braceletFeatures[indexPath.row].0
            cell.featureBodyLabel.text = braceletFeatures[indexPath.row].1
            return cell
        case 2:
            // bracelet reviews
            let cell = tableView.dequeueReusableCellWithIdentifier("ProductReviewTableViewCell") as! ProductReviewTableViewCell
//            cell.reviewAuthorLabel.text = braceletReviews[indexPath.row].1.username
            cell.reviewContentLabel.text = braceletReviews[indexPath.row].0
            return cell
        case 3:
            if purchaseFormSegmentedControl == nil{
                return UITableViewCell()
            }else if !isGift{

                // isGift == false

                switch indexPath.row {
                case 0:
                    // address form rows
                    let cell = tableView.dequeueReusableCellWithIdentifier("AddressFormTableViewCell") as! AddressFormTableViewCell
                    return cell
                default:
                    return UITableViewCell()
                }
            }
            else{
                // isGift
                switch indexPath.row {
                case 0:
                    // email form row
                    let cell = tableView.dequeueReusableCellWithIdentifier("SingleLineTextFieldTableViewCell") as! SingleLineTextFieldTableViewCell
                    cell.textField.placeholder = "Gift Recipient Email"
                    return cell
                default:
                    return UITableViewCell()
                }
            }
        case 4:
            switch indexPath.row {
            case 0:
                // story title form row
                let cell = tableView.dequeueReusableCellWithIdentifier("SingleLineTextFieldTableViewCell") as! SingleLineTextFieldTableViewCell
                cell.textField.placeholder = "Title (e.g. BFFs from BK)"
                return cell
            case 1:
                // story content textView
                let cell = tableView.dequeueReusableCellWithIdentifier("MultilineTextViewTableViewCell") as! MultilineTextViewTableViewCell
                cell.textView.placeholder = "Message (e.g. The greatest gift of life is friendship, and I have received it.)"
                return cell
            default:
                return UITableViewCell()
            }

        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3{
//            return UITableViewAutomaticDimension
            return 44 + 36 - 7.5
        }
        else if section == 4{
            return 44
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 3{
            let view = UIView(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.width, 44 + 36))
            view.backgroundColor = UIColor.whiteColor()
            
            let leftLineView = UIView(frame: CGRectZero)
            let rightLineView = UIView(frame: CGRectZero)
            let titleLabel = UILabel(frame: CGRectZero)
            purchaseFormSegmentedControl = UISegmentedControl(items: ["Not a Gift","It's a Gift"])
            leftLineView.translatesAutoresizingMaskIntoConstraints = false
            rightLineView.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            purchaseFormSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(leftLineView)
            view.addSubview(rightLineView)
            view.addSubview(titleLabel)
            view.addSubview(purchaseFormSegmentedControl)
            
            leftLineView.backgroundColor = UIColor.blackColor()
            rightLineView.backgroundColor = UIColor.blackColor()
            titleLabel.font = UIFont.monospacedDigitSystemFontOfSize(14, weight: UIFontWeightMedium).italic()
            titleLabel.text = "Gift Options"
            titleLabel.textAlignment = .Center
            purchaseFormSegmentedControl.addTarget(self, action: #selector(BraceletStoreViewController.isGiftChanged(_:)), forControlEvents: .ValueChanged)
            if isGift{
                purchaseFormSegmentedControl.selectedSegmentIndex = 1
            }
            else{
                purchaseFormSegmentedControl.selectedSegmentIndex = 0
            }
            
            let metricsDictionary = ["sidePadding":15, "titleLabelBuffer":7.5]
            let viewsDictionary = ["leftLineView":leftLineView, "rightLineView":rightLineView, "titleLabel":titleLabel, "purchaseFormSegmentedControl":purchaseFormSegmentedControl]
            
            let titleLabelCenterX = NSLayoutConstraint(item: titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
            let titleAndLinesH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[leftLineView]-titleLabelBuffer-[titleLabel]-titleLabelBuffer-[rightLineView]-sidePadding-|", options: .AlignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
            let allV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-titleLabelBuffer-[titleLabel]-titleLabelBuffer-[purchaseFormSegmentedControl(28)]-7.5-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
            let segmentedControlH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[purchaseFormSegmentedControl]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
            let leftLineViewHeight = NSLayoutConstraint(item: leftLineView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0.5)
            let rightLineViewHeight = NSLayoutConstraint(item: rightLineView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0.5)
            view.addConstraints(titleAndLinesH + allV + segmentedControlH)
            view.addConstraints([titleLabelCenterX, leftLineViewHeight, rightLineViewHeight])
            
            return view
        }
        else if section == 4{
            let view = UIView(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.width, 44 + 36))
            view.backgroundColor = UIColor.whiteColor()
            
            let leftLineView = UIView(frame: CGRectZero)
            let rightLineView = UIView(frame: CGRectZero)
            let titleLabel = UILabel(frame: CGRectZero)
            leftLineView.translatesAutoresizingMaskIntoConstraints = false
            rightLineView.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(leftLineView)
            view.addSubview(rightLineView)
            view.addSubview(titleLabel)
            
            leftLineView.backgroundColor = UIColor.blackColor()
            rightLineView.backgroundColor = UIColor.blackColor()
            titleLabel.font = UIFont.monospacedDigitSystemFontOfSize(14, weight: UIFontWeightMedium).italic()
            titleLabel.text = "What Is This For?"
            titleLabel.textAlignment = .Center
            
            let metricsDictionary = ["sidePadding":15, "titleLabelBuffer":7.5]
            let viewsDictionary = ["leftLineView":leftLineView, "rightLineView":rightLineView, "titleLabel":titleLabel]
            
            let titleLabelCenterX = NSLayoutConstraint(item: titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
            let titleAndLinesH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[leftLineView]-titleLabelBuffer-[titleLabel]-titleLabelBuffer-[rightLineView]-sidePadding-|", options: .AlignAllCenterY, metrics: metricsDictionary, views: viewsDictionary)
            let allV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-titleLabelBuffer-[titleLabel]-titleLabelBuffer-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
            let leftLineViewHeight = NSLayoutConstraint(item: leftLineView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0.5)
            let rightLineViewHeight = NSLayoutConstraint(item: rightLineView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0.5)
            view.addConstraints(titleAndLinesH + allV)
            view.addConstraints([titleLabelCenterX, leftLineViewHeight, rightLineViewHeight])
            
            return view

        }
        else{
            return nil
        }
    }
    
    func isGiftChanged(sender:UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            tableVC.tableView.beginUpdates()
            var oldIndexes:[NSIndexPath] = []
            for i in 0...0{
                oldIndexes.append(NSIndexPath(forRow: i, inSection: 3))
            }
            isGift = false
            var newIndexes:[NSIndexPath] = []
            for i in 0...0{
                newIndexes.append(NSIndexPath(forRow: i, inSection: 3))
            }
            tableVC.tableView.deleteRowsAtIndexPaths(oldIndexes, withRowAnimation: .Right)
            tableVC.tableView.insertRowsAtIndexPaths(newIndexes, withRowAnimation: .Left)
            tableVC.tableView.endUpdates()
        }
        else{
            tableVC.tableView.beginUpdates()
            var oldIndexes:[NSIndexPath] = []
            for i in 0...0{
                oldIndexes.append(NSIndexPath(forRow: i, inSection: 3))
            }
            isGift = true
            var newIndexes:[NSIndexPath] = []
            for i in 0...0{
                newIndexes.append(NSIndexPath(forRow: i, inSection: 3))
            }
            tableVC.tableView.deleteRowsAtIndexPaths(oldIndexes, withRowAnimation: .Left)
            tableVC.tableView.insertRowsAtIndexPaths(newIndexes, withRowAnimation: .Right)
            tableVC.tableView.endUpdates()
        }
        tableVC.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 3), atScrollPosition: .Top, animated: true)

    }
}
