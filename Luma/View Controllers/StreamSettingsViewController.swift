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
    var stream:Stream!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.white
        
        navigationItem.title = "Stream"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "CloseBarButtonItem"), style: .Plain, target: self, action: #selector(StreamSettingsViewController.closeButtonTapped))
        
        tableVC = UITableViewController()
        addChildViewController(tableVC)
        
        tableVC.tableView = UITableView(frame: view.frame)
        tableVC.tableView.delegate = self
        tableVC.tableView.dataSource = self
        tableVC.tableView.registerClass(SettingsSummaryTableViewCell.self, forCellReuseIdentifier: "SettingsSummaryTableViewCell")
        tableVC.tableView.registerClass(ParticipantTableViewCell.self, forCellReuseIdentifier: "ParticipantTableViewCell")
        tableVC.tableView.registerClass(ActionRowTableViewCell.self, forCellReuseIdentifier: "ActionRowTableViewCell")
        tableVC.tableView.rowHeight = UITableViewAutomaticDimension
        tableVC.tableView.estimatedRowHeight = 150
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
        return 2
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
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("SettingsSummaryTableViewCell") as! SettingsSummaryTableViewCell
            return cell
        }
        else if indexPath.section == 1{
            if indexPath.row == participants.count{
                let cell = tableView.dequeueReusableCellWithIdentifier("ActionRowTableViewCell") as! ActionRowTableViewCell
                cell.actionLabel.text = "Add Participants..."
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCellWithIdentifier("ParticipantTableViewCell") as! ParticipantTableViewCell
                return cell
            }
        }
        else{
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath == NSIndexPath(forRow: participants.count, inSection: 1){
            transitionToParticipants()
        }
    }
    
    func transitionToParticipants() {
        let participantsVC = ParticipantsViewController()
        participantsVC.streamSettingsVC = self
        navigationController?.pushViewController(participantsVC, animated: true)

    }
}
