//
//  BraceletStoreViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/16/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import Parse

class BraceletStoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableVC:UITableViewController!
    var actionButton:UIButton!
    
    var braceletFeatures:[(String, String)] = [("Feature Highlight 1", "Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum"), ("Feature Highlight 2", "Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum")]
    var braceletReviews:[(String, LumaUser)] = [("Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum", LumaUser()),("Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum Descriptions something Luma Bracelet is dada something something Luma Bracelet is dada something something Lum", LumaUser())]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableVC = UITableViewController()
        addChildViewController(tableVC)
        tableVC.tableView = TPKeyboardAvoidingTableView()
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
        tableVC.tableView.rowHeight = UITableViewAutomaticDimension
        tableVC.tableView.estimatedRowHeight = 100
        tableVC.tableView.separatorStyle = .None
        view.addSubview(tableVC.tableView)
        
        actionButton = UIButton(frame: CGRectZero)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setButtonType("primary")
        actionButton.setTitle("Buy for $149", forState: .Normal)
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
    

    // MARK: Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
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
        default:
            return UITableViewCell()
        }
    }
    
    // MARKL Table View Delegate
}
