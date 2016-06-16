//
//  TextComposerViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/16/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import SZTextView

class TextComposerViewController: UIViewController {

    var textView:SZTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView = SZTextView(frame: CGRectZero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFontOfSize(17)
        view.addSubview(textView)
        
        let viewsDictionary = ["textView":textView, "topLayoutGuide":topLayoutGuide, "bottomLayoutGuide":bottomLayoutGuide]
        let metricsDictionary = ["sidePadding":15]
        
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[textView]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-25-[textView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        
        view.addConstraints(hConstraints)
        view.addConstraints(vConstraints)
        
        view.backgroundColor = Colors.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
