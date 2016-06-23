//
//  CommentComposerViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/16/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import SZTextView
import Parse
class CommentComposerViewController: TextComposerViewController, UITextViewDelegate {

    var momentDetailVC:MomentDetailViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Comment"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(CommentComposerViewController.cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .Done, target: self, action: #selector(CommentComposerViewController.doneButtonTapped))
        navigationItem.rightBarButtonItem?.enabled = false
        textView.placeholder = "Write a Comment..."
        textView.delegate = self
        textView.returnKeyType = .Done
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func doneButtonTapped() {
        print("done button tapped")
        
        let newComment = Comment()
        newComment.author = PFUser.currentUser()!
        newComment.content = textView.text
        newComment.inMoment = self.momentDetailVC.moment
        newComment.saveInBackgroundWithBlock { (success, error) in
            if success{
                let moment = self.momentDetailVC.moment
                moment.comments.addObject(newComment)
                moment.saveInBackgroundWithBlock({ (success, error) in
                    if success{
                        self.dismissViewControllerAnimated(true, completion: {
                            self.momentDetailVC.loadComments()
                        })
                    }
                    else{
                        print(error)
                    }
                })
            }
            else{
                print(error)
            }
        }
        
    }
        
    func textViewDidChange(textView: UITextView) {
        if textView.text != ""{
            navigationItem.rightBarButtonItem?.enabled = true
        }
        else{
            navigationItem.rightBarButtonItem?.enabled = false
        }

    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        else{
            return true
        }
    }

    
    
}
