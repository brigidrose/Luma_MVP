//
//  MomentDetailViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/3/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class MomentDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var tableVC:UITableViewController!
    var moment:Moment!
    var medias:[Media] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Moment"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"CloseBarButtonItem" ), style: .Plain, target: self, action: #selector(MomentDetailViewController.closeButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(MomentDetailViewController.actionButtonTapped))

        tableVC = UITableViewController()
        addChildViewController(tableVC)
        tableVC.tableView = UITableView(frame: CGRectZero)
        tableVC.tableView.translatesAutoresizingMaskIntoConstraints = false
        tableVC.tableView.delegate = self
        tableVC.tableView.dataSource = self
        tableVC.tableView.registerClass(MomentDetailSummaryTableViewCell.self, forCellReuseIdentifier: "MomentDetailSummaryTableViewCell")
        tableVC.tableView.registerClass(MomentMediaTableViewCell.self, forCellReuseIdentifier: "MomentMediaTableViewCell")
        tableVC.tableView.rowHeight = UITableViewAutomaticDimension
        tableVC.tableView.estimatedRowHeight = 150
        tableVC.tableView.separatorStyle = .None
        view.addSubview(tableVC.tableView)
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: NSLayoutFormatOptions(rawValue:0) , metrics: nil, views: ["tableView":tableVC.tableView])
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: NSLayoutFormatOptions(rawValue:0) , metrics: nil, views: ["tableView":tableVC.tableView])

//        let topConstraint = NSLayoutConstraint(item: tableVC.tableView, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0)
//        let bottomConstraint = NSLayoutConstraint(item: tableVC.tableView, attribute: .Bottom, relatedBy: .Equal, toItem: bottomLayoutGuide, attribute: .Top, multiplier: 1, constant: 0)
        
        view.addConstraints(hConstraints)
        view.addConstraints(vConstraints)
//        view.addConstraint(topConstraint)
//        view.addConstraint(bottomConstraint)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadMedia()
    }
    
    func closeButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func actionButtonTapped() {
        print("action button tapped")
    }
    
    // MARK: Table View Delegates
    
    
    // MARK: Table View Datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medias.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("MomentDetailSummaryTableViewCell") as! MomentDetailSummaryTableViewCell
            cell.titleLabel.text = moment.narrative
            if (moment.author["facebookId"] != nil){
                let id = moment.author["facebookId"] as! String
                let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?type=large")
                cell.userButton.sd_setImageWithURL(url, forState: .Normal)
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("MomentMediaTableViewCell") as! MomentMediaTableViewCell
            let media = medias[indexPath.row - 1]
            cell.captionLabel.text = media.caption
            cell.thumbnailImageView.sd_setImageWithURL(NSURL(string: media.file.url!))
            return cell
        }
    }
    
    func loadMedia() {
        let mediaQuery = moment.medias.query()
        mediaQuery.findObjectsInBackgroundWithBlock { (medias, error) in
            if error != nil{
                print(error)
            }
            else{
                self.medias = medias as! [Media]
                self.tableVC.tableView.reloadData()
            }
        }
    }

}
