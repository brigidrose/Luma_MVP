//
//  BagDetailViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/19/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
class BagDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableVC:UITableViewController!
    var payButton:UIButton!
    var summaryLoaded:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Bag"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: #selector(BagDetailViewController.editButtonTapped))
        
        tableVC = UITableViewController()
        addChildViewController(tableVC)
        
        tableVC.tableView = TPKeyboardAvoidingTableView(frame: CGRectZero)
        tableVC.tableView.translatesAutoresizingMaskIntoConstraints = false
        tableVC.tableView.rowHeight = UITableViewAutomaticDimension
        tableVC.tableView.estimatedRowHeight = 100
        tableVC.tableView.contentInset.bottom = 92
        tableVC.tableView.dataSource = self
        tableVC.tableView.delegate = self
        tableVC.tableView.registerClass(BagSummaryTableViewCell.self, forCellReuseIdentifier: "BagSummaryTableViewCell")
        tableVC.tableView.registerClass(BagItemTableViewCell.self, forCellReuseIdentifier: "BagItemTableViewCell")
        view.addSubview(tableVC.tableView)
        
        let tableVH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableV]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["tableV":tableVC.tableView])
        let tableVV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableV]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["tableV":tableVC.tableView])
        view.addConstraints(tableVH + tableVV)
        
        payButton = UIButton(frame: CGRectZero)
        payButton.translatesAutoresizingMaskIntoConstraints = false
        payButton.setButtonType("primary")
        payButton.setTitle("Purchase with \u{F8FF} Pay", forState: .Normal)
        payButton.addTarget(self, action: #selector(BagDetailViewController.payButtonTapped), forControlEvents: .TouchUpInside)
        view.addSubview(payButton)
        
        let metricsDictionary = ["sidePadding":20]
        
        let payButtonH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[payButton]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: ["payButton" : payButton])
        view.addConstraints(payButtonH)
        let payButtonV = NSLayoutConstraint.constraintsWithVisualFormat("V:[payButton(56)]-36-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: ["payButton" : payButton])
        view.addConstraints(payButtonV)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func payButtonTapped() {
        print("pay button tapped")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editButtonTapped(){
        tableVC.tableView.setEditing(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(BagDetailViewController.doneButtonTapped))
    }
    
    func doneButtonTapped(){
        tableVC.tableView.setEditing(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: #selector(BagDetailViewController.editButtonTapped))
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == tableView.numberOfRowsInSection(0) - 1{
            summaryLoaded = true
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == tableView.numberOfRowsInSection(0) - 1{
            // summary cell
            let cell = tableView.dequeueReusableCellWithIdentifier("BagSummaryTableViewCell") as! BagSummaryTableViewCell
            if !summaryLoaded{
                let subtotalLabel = UILabel()
                subtotalLabel.text = "Subtotal: $196"
                subtotalLabel.textAlignment = .Right
                cell.stackView.addArrangedSubview(subtotalLabel)
                let taxLabel = UILabel()
                taxLabel.text = "Tax: $20.21"
                taxLabel.textAlignment = .Right
                cell.stackView.addArrangedSubview(taxLabel)
                let totalLabel = UILabel()
                totalLabel.text = "Total: $216.21"
                totalLabel.font = UIFont.systemFontOfSize(20, weight: UIFontWeightMedium)
                totalLabel.textAlignment = .Right
                cell.stackView.addArrangedSubview(totalLabel)
            }
            return cell
        }
        else{
            // item cell
            let cell = tableView.dequeueReusableCellWithIdentifier("BagItemTableViewCell") as! BagItemTableViewCell
            return cell
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 && indexPath.row < tableView.numberOfRowsInSection(indexPath.section) - 1{
            return true
        }
        else{
            return false
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 0{
            let deleteAction = UITableViewRowAction(style: .Destructive, title: "Remove", handler: { (action, indexPath) in
                print("indexPath is \(indexPath)")
                self.tableVC.tableView.setEditing(false, animated: true)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: #selector(BagDetailViewController.editButtonTapped))
            })
            return [deleteAction]
        }
        else{
            return nil
        }
    }
}
