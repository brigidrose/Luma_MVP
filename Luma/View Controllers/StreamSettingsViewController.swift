//
//  StreamSettingsViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/14/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import Parse

class StreamSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableVC:UITableViewController!
    var participants:[PFUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.white
        
        navigationItem.title = "Stream Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "CloseBarButtonItem"), style: .Plain, target: self, action: #selector(StreamSettingsViewController.closeButtonTapped))
        
        tableVC = UITableViewController()
        addChildViewController(tableVC)
        
        tableVC.tableView = UITableView(frame: view.frame)
        tableVC.tableView.delegate = self
        tableVC.tableView.dataSource = self
        view.addSubview(tableVC.tableView)
    }
    
    func closeButtonTapped() {
        print("close button tapped")
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        else{
            return 28
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return nil
        }
        else if section == 1{
            return "Participants"
        }
        else{
            return "Preferences"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else if section == 1{
            return participants.count + 1
        }
        else{
            return 3
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
