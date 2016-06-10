//
//  StreamSelectionViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/9/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class StreamSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var streamsTV:UITableView!
    var activeStreams:[MomentStream] = []
    var archivedStreams:[MomentStream] = []
    
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            // active streams
            return activeStreams.count + 1
        }
        else{
            return archivedStreams.count + 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StreamWithParticipantsTableViewCell") as! StreamWithParticipantsTableViewCell
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
            return "Archived"
        }
    }

    
    func closeButtonTapped(){
        dismissViewControllerAnimated(true, completion: nil)
    }
}
