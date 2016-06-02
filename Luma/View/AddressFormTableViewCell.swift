//
//  AddressFormTableViewCell.swift
//  Luma
//
//  Created by Chun-Wei Chen on 5/19/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddressFormTableViewCell: UITableViewCell, UITextFieldDelegate {

    var streetTextField:SkyFloatingLabelTextField!
    var cityTextField:SkyFloatingLabelTextField!
    var stateTextField:SkyFloatingLabelTextField!
    var zipTextField:SkyFloatingLabelTextField!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        
        streetTextField = SkyFloatingLabelTextField(frame: CGRectZero)
        streetTextField.translatesAutoresizingMaskIntoConstraints = false
        streetTextField.placeholder = "Street"
        streetTextField.title = ""
        streetTextField.selectedLineColor = Colors.primary
        streetTextField.selectedTitleColor = Colors.primary
        streetTextField.autocapitalizationType = .Words
        streetTextField.returnKeyType = .Next
        streetTextField.delegate = self
        contentView.addSubview(streetTextField)
        
        cityTextField = SkyFloatingLabelTextField(frame: CGRectZero)
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        cityTextField.placeholder = "City"
        cityTextField.title = ""
        cityTextField.selectedLineColor = Colors.primary
        cityTextField.selectedTitleColor = Colors.primary
        cityTextField.autocapitalizationType = .Words
        cityTextField.returnKeyType = .Next
        cityTextField.delegate = self
        contentView.addSubview(cityTextField)
        
        stateTextField = SkyFloatingLabelTextField(frame: CGRectZero)
        stateTextField.translatesAutoresizingMaskIntoConstraints = false
        stateTextField.placeholder = "State"
        stateTextField.title = ""
        stateTextField.selectedLineColor = Colors.primary
        stateTextField.selectedTitleColor = Colors.primary
        stateTextField.autocapitalizationType = .AllCharacters
        stateTextField.returnKeyType = .Next
        stateTextField.delegate = self
        contentView.addSubview(stateTextField)
        
        zipTextField = SkyFloatingLabelTextField(frame: CGRectZero)
        zipTextField.translatesAutoresizingMaskIntoConstraints = false
        zipTextField.placeholder = "Zip"
        zipTextField.title = ""
        zipTextField.selectedLineColor = Colors.primary
        zipTextField.selectedTitleColor = Colors.primary
        zipTextField.keyboardType = .NumbersAndPunctuation
        zipTextField.returnKeyType = .Done
        zipTextField.delegate = self
        contentView.addSubview(zipTextField)
        
        let viewsDictionary = ["streetTextField":streetTextField, "cityTextField":cityTextField, "stateTextField":stateTextField, "zipTextField":zipTextField]
        let metricsDictionary = ["sidePadding":15, "fieldBuffer":7.5]
        
        let streetTextFieldH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[streetTextField]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        let lineTwoTextFieldsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[cityTextField]-fieldBuffer-[stateTextField(==cityTextField)]-fieldBuffer-[zipTextField(==cityTextField)]-sidePadding-|", options: [.AlignAllTop, .AlignAllBottom], metrics: metricsDictionary, views: viewsDictionary)
        
        let textFieldsV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-sidePadding-[streetTextField]-fieldBuffer-[cityTextField]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary)
        
        contentView.addConstraints(streetTextFieldH + lineTwoTextFieldsH + textFieldsV)
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
        switch textField {
        case streetTextField:
            cityTextField.becomeFirstResponder()
        case cityTextField:
            stateTextField.becomeFirstResponder()
        case stateTextField:
            zipTextField.becomeFirstResponder()
        case zipTextField:
            textField.resignFirstResponder()
        default:
            print("default case")
        }
        return false
    }

}
