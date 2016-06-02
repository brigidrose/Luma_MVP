//
//  SingleLineTextFieldTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/19/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class SingleLineTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    var textField:SkyFloatingLabelTextField!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        textField = SkyFloatingLabelTextField(frame: CGRectZero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Placeholder"
        textField.title = ""
        textField.selectedLineColor = Colors.primary
        textField.selectedTitleColor = Colors.primary
        textField.delegate = self
        textField.returnKeyType = .Done
        contentView.addSubview(textField)

        let metricsDictionary = ["sidePadding":15]
        let viewsDictionary = ["textField":textField]
     
        let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[textField]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[textField]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        contentView.addConstraints(hConstraints)
        contentView.addConstraints(vConstraints)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

}
