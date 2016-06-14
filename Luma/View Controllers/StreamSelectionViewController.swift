//
//  StreamSelectionViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/9/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import Parse

class StreamSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var streamsTV:UITableView!
    var activeStreams:[Stream] = []
    var archivedStreams:[Stream] = []
    var newMomentVC:NewMomentViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Select Stream"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "CloseBarButtonItem"), style: .Plain, target: self, action: #selector(StreamSelectionViewController.closeButtonTapped))
        let streamsTVC = UITableViewController()
        addChildViewController(streamsTVC)
        
        view.backgroundColor = Colors.white
        
        streamsTVC.tableView = UITableView(frame: view.frame)
        streamsTV = streamsTVC.tableView
        streamsTV.estimatedRowHeight = 64
        streamsTV.rowHeight = UITableViewAutomaticDimension
        streamsTV.separatorStyle = .None
        streamsTV.delegate = self
        streamsTV.dataSource = self
        streamsTV.registerClass(StreamWithParticipantsTableViewCell.self, forCellReuseIdentifier: "StreamWithParticipantsTableViewCell")
        view.addSubview(streamsTV)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadStreams()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            // active streams
            return activeStreams.count
        }
        else{
            return archivedStreams.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let stream:Stream
        if indexPath.section == 0{
            stream = activeStreams[indexPath.row]
        }
        else{
            stream = archivedStreams[indexPath.row]
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("StreamWithParticipantsTableViewCell") as! StreamWithParticipantsTableViewCell
        cell.streamTitleLabel.text = stream.title
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return nil
        }
        else{
            if archivedStreams.count > 0{
                return "Archived"
            }
            else{
                return nil
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0{
            newMomentVC.inStream = activeStreams[indexPath.row]
        }
        else{
            newMomentVC.inStream = archivedStreams[indexPath.row]
        }
        dismissViewControllerAnimated(true, completion: {
            self.newMomentVC.updateSelectedStreamButton()
        })
    }

    
    func closeButtonTapped(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadStreams() {
        let loadCharmsQuery = PFQuery(className: "Charm")
        loadCharmsQuery.whereKey("owner", equalTo: PFUser.currentUser()!)
        loadCharmsQuery.includeKeys(["gifter", "model", "owner", "stream"])
        loadCharmsQuery.findObjectsInBackgroundWithBlock { (charms, error) in
            if error != nil{
                print(error)
            }
            else{
                self.activeStreams.removeAll()
                for charm in charms as! [Charm]{
                    self.activeStreams.append(charm.stream)
                }
                // load streams in which current user is not author and is contained in participants
                let loadParticipatingStreamsQuery = PFQuery(className: "Stream")
                loadParticipatingStreamsQuery.whereKey("author", notEqualTo: PFUser.currentUser()!)
                loadParticipatingStreamsQuery.whereKey("participants", equalTo: PFUser.currentUser()!)
                loadParticipatingStreamsQuery.findObjectsInBackgroundWithBlock({ (streams, error) in
                    if error != nil{
                        print(error)
                    }
                    else{
                        for stream in streams as! [Stream]{
                            self.activeStreams.append(stream)
                        }
                        self.streamsTV.reloadData()
                    }
                })
            }
        }
    }

}
