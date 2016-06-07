//
//  NewMomentViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/6/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit

class NewMomentViewController: UIViewController {

    var streamSelectionButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationItem.title = "New Moment"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create", style: .Done, target: self, action: #selector(NewMomentViewController.createButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(NewMomentViewController.cancelButtonTapped))
        
        let addMediaButton = UIBarButtonItem(image: UIImage(named: "addMediaButtonIcon"), style: .Plain, target: self, action: #selector(NewMomentViewController.addMediaButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let addUnlockButton = UIBarButtonItem(image: UIImage(named: "addUnlockSettingsIcon"), style: .Plain, target: self, action: #selector(NewMomentViewController.addUnlockSettingsButtonTapped))
        navigationController?.toolbar.setItems([addMediaButton, flexSpace, addUnlockButton], animated: false)
        
        navigationController?.toolbarHidden = false

        view.backgroundColor = Colors.white
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createButtonTapped() {
        print("create button tapped")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelButtonTapped() {
        print("cancel button tapped")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addMediaButtonTapped() {
        print("add media button tapped")
    }
    
    func addUnlockSettingsButtonTapped(){
        print("add unlock settings button tapped")
    }


}
