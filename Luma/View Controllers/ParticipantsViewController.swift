//
//  ParticipantsViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/14/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4
import SwiftyJSON

class ParticipantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableVC:UITableViewController!
    var participants:[PFUser] = []
    var facebookFriends:[(String, String)] = []
    var streamSettingsVC:StreamSettingsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Participants"
        
        tableVC = UITableViewController()
        addChildViewController(tableVC)
        
        tableVC.tableView = UITableView(frame: view.frame)
        tableVC.tableView.delegate = self
        tableVC.tableView.dataSource = self
        tableVC.tableView.registerClass(ParticipantTableViewCell.self, forCellReuseIdentifier: "ParticipantTableViewCell")
        tableVC.tableView.rowHeight = UITableViewAutomaticDimension
        tableVC.tableView.estimatedRowHeight = 64
        tableVC.tableView.separatorStyle = .None
        view.addSubview(tableVC.tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadParticipants()
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else if section == 1{
            return participants.count
        }
        else{
            return facebookFriends.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let user = streamSettingsVC.stream.author
            let cell = tableView.dequeueReusableCellWithIdentifier("ParticipantTableViewCell") as! ParticipantTableViewCell
            cell.participantNameLabel.text = "\(user["firstName"]) \(user["lastName"])"
            let url = NSURL(string: "https://graph.facebook.com/\(user["facebookId"])/picture?width=500&height=500")
            cell.thumbnailImageView.sd_setImageWithURL(url)
            return cell
        }
        else if indexPath.section == 1{
            let user = participants[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("ParticipantTableViewCell") as! ParticipantTableViewCell
            cell.participantNameLabel.text = "\(user["firstName"]) \(user["lastName"])"
            let url = NSURL(string: "https://graph.facebook.com/\(user["facebookId"])/picture?width=500&height=500")
            cell.thumbnailImageView.sd_setImageWithURL(url)
            return cell
        }
        else{
            let user = facebookFriends[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("ParticipantTableViewCell") as! ParticipantTableViewCell
            cell.participantNameLabel.text = "\(user.0)"
            let url = NSURL(string: "https://graph.facebook.com/\(user.1)/picture?width=500&height=500")
            cell.thumbnailImageView.sd_setImageWithURL(url)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Owner"
        }
        else if section == 1{
            return "Participants"
        }
        else{
            return "Friends"
        }
    }
    
    func loadParticipants() {
        participants.removeAll()
        print("load participants")
        let participantsQuery = streamSettingsVC.stream.participants.query()
        participantsQuery.findObjectsInBackgroundWithBlock { (users, error) in
            if error != nil{
                print(error)
            }
            else{
                self.participants = users as! [PFUser]
                self.loadFacebookFriends()
            }
        }
    }
    
    func loadFacebookFriends(){
        facebookFriends.removeAll()
        let fbRequest = FBSDKGraphRequest(graphPath:"/me", parameters: ["fields": "friends"]);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if error == nil {
                let json = JSON(result)["friends"]
                for (key, subJson) in json["data"] {
                    if let id = subJson["id"].string {
                        var isParticipant = false
                        var isAuthor = false
                        for participant in self.participants{
                            if participant["facebookId"] as! String == id{
                                isParticipant = true
                            }
                            if self.streamSettingsVC.stream.author["facebookId"] as! String == id{
                                isAuthor = true
                            }
                        }
                        if !isParticipant && !isAuthor{
                            self.facebookFriends.append((subJson["name"].string!, id))
                        }
                    }
                }
                self.tableVC.tableView.reloadData()
                
            } else {
                print("Error Getting Friends \(error)");
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0{
        
        }
        else if indexPath.section == 1{
        
        }
        else{
            print(indexPath)
            let idInQuestion = facebookFriends[indexPath.row].1
            print(idInQuestion)
            let userQuery = PFQuery(className: "_User")
            userQuery.whereKey("facebookId", equalTo: idInQuestion)
            userQuery.findObjectsInBackgroundWithBlock({ (users, error) in
                if error != nil{
                    print(error)
                }
                else{
                    print(users)
                    let user = (users as! [PFUser])[0]
                    print(user)
                    self.streamSettingsVC.stream.participants.addObject(user)
                    self.streamSettingsVC.stream.saveInBackgroundWithBlock({ (success, error) in
                        if success{
                            print("stream saved")
                            self.loadParticipants()
                        }
                        else{
                            print(error)
                        }
                    })
                }
            })
        }
    }
    
}
