//
//  UnlockSettingsViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/9/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import MapKit

class UnlockSettingsViewController: UIViewController, MKMapViewDelegate {

    var segmentedControl:UISegmentedControl!
    var datePickerContainerView:UIView!
    var locationPickerContainerView:UIView!

    var unlockSettingsSummaryLabelsContainerView:UIView!
    var unlockSettingsTitleLabel:UILabel!
    var unlockSettingsDetailLabel:UILabel!
    var unlockSettingsSeparatorView:UIView!
    
    var datePicker:UIDatePicker!
    var mapView:MKMapView!
    
    var locationManager = (UIApplication.sharedApplication().delegate as! AppDelegate).locationManager
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(UnlockSettingsViewController.doneButtonTapped))
        navigationItem.title = "Unlock Settings"
        
        view.backgroundColor = Colors.white
        
        datePickerContainerView = UIView(frame: CGRectZero)
        datePickerContainerView.translatesAutoresizingMaskIntoConstraints = false
        datePickerContainerView.backgroundColor = Colors.offWhite
        datePickerContainerView.hidden = false
        view.addSubview(datePickerContainerView)
        
        datePicker = UIDatePicker(frame: CGRectZero)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .DateAndTime
        datePicker.addTarget(self, action: #selector(UnlockSettingsViewController.datePickerChanged), forControlEvents: .ValueChanged)
        datePickerContainerView.addSubview(datePicker)
        
        locationPickerContainerView = UIView(frame: CGRectZero)
        locationPickerContainerView.translatesAutoresizingMaskIntoConstraints = false
        locationPickerContainerView.backgroundColor = Colors.white
        locationPickerContainerView.hidden = true
        view.addSubview(locationPickerContainerView)
        
        mapView = MKMapView(frame: CGRectZero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15))
        mapView.showsUserLocation = true
        mapView.delegate = self
        locationPickerContainerView.addSubview(mapView)
        
        let segmentedControlContainerView = UIView(frame: CGRectZero)
        segmentedControlContainerView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControlContainerView.backgroundColor = Colors.white
        view.addSubview(segmentedControlContainerView)
        
        let segmentedControlContainerSeparatorView = UIView(frame: CGRectZero)
        segmentedControlContainerSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControlContainerSeparatorView.backgroundColor = Colors.separatorGray
        segmentedControlContainerView.addSubview(segmentedControlContainerSeparatorView)
        
        segmentedControl = UISegmentedControl(items: ["Time", "Location"])
        segmentedControl.frame = CGRectZero
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(UnlockSettingsViewController.updateViewToSegment), forControlEvents: .ValueChanged)
        segmentedControlContainerView.addSubview(segmentedControl)

        unlockSettingsSummaryLabelsContainerView = UIView(frame: CGRectZero)
        unlockSettingsSummaryLabelsContainerView.translatesAutoresizingMaskIntoConstraints = false
        unlockSettingsSummaryLabelsContainerView.backgroundColor = Colors.white
        view.addSubview(unlockSettingsSummaryLabelsContainerView)
        
        unlockSettingsTitleLabel = UILabel(frame: CGRectZero)
        unlockSettingsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        unlockSettingsTitleLabel.textAlignment = .Left
        unlockSettingsTitleLabel.font = UIFont.systemFontOfSize(18)
        unlockSettingsTitleLabel.text = "Unlock Settings Title Label"
        unlockSettingsSummaryLabelsContainerView.addSubview(unlockSettingsTitleLabel)
        
        unlockSettingsDetailLabel = UILabel(frame: CGRectZero)
        unlockSettingsDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        unlockSettingsDetailLabel.textAlignment = .Left
        unlockSettingsDetailLabel.font = UIFont.systemFontOfSize(13)
        unlockSettingsDetailLabel.text = "Unlock Settings Detail Label"
        unlockSettingsSummaryLabelsContainerView.addSubview(unlockSettingsDetailLabel)
        
        unlockSettingsSeparatorView = UIView(frame: CGRectZero)
        unlockSettingsSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        unlockSettingsSeparatorView.backgroundColor = Colors.separatorGray
        unlockSettingsSummaryLabelsContainerView.addSubview(unlockSettingsSeparatorView)
        
        
        let viewsDictionary = ["topLayoutGuide":topLayoutGuide, "bottomLayoutGuide":bottomLayoutGuide, "segmentedControlContainerView":segmentedControlContainerView, "segmentedControlContainerSeparatorView":segmentedControlContainerSeparatorView, "segmentedControl":segmentedControl,"datePickerContainerView":datePickerContainerView, "locationPickerContainerView":locationPickerContainerView, "unlockSettingsSummaryLabelsContainerView":unlockSettingsSummaryLabelsContainerView, "unlockSettingsTitleLabel":unlockSettingsTitleLabel, "unlockSettingsDetailLabel":unlockSettingsDetailLabel, "unlockSettingsSeparatorView":unlockSettingsSeparatorView, "datePicker":datePicker, "mapView":mapView]
        
        let metricsDictionary = ["sidePadding":15, "miniSidePadding":7.5, "verticalPadding":8]
        
        let segmentedControlContainerViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[segmentedControlContainerView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let segmentedControlContainerViewV = NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide][segmentedControlContainerView][unlockSettingsSummaryLabelsContainerView]", options: [.AlignAllLeft, .AlignAllRight], metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        
        view.addConstraints(segmentedControlContainerViewH)
        view.addConstraints(segmentedControlContainerViewV)
        
        let segmentedControlContainerSeparatorViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[segmentedControlContainerSeparatorView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let segmentedControlH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-miniSidePadding-[segmentedControl]-miniSidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let segmentedControlV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-verticalPadding-[segmentedControl(28)]-verticalPadding-[segmentedControlContainerSeparatorView(1)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        
        segmentedControlContainerView.addConstraints(segmentedControlContainerSeparatorViewH)
        segmentedControlContainerView.addConstraints(segmentedControlH)
        segmentedControlContainerView.addConstraints(segmentedControlV)
        
        let datePickerH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[datePickerContainerView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let datePickerV = NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide][datePickerContainerView][bottomLayoutGuide]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        
        view.addConstraints(datePickerH)
        view.addConstraints(datePickerV)
        
        let datePickerCenterY = NSLayoutConstraint(item: datePicker, attribute: .CenterY, relatedBy: .Equal, toItem: datePickerContainerView, attribute: .CenterY, multiplier: 1, constant: 0)
        let internalDatePickerH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[datePicker]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let internalDatePickerV = NSLayoutConstraint.constraintsWithVisualFormat("V:[datePicker]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        
        datePickerContainerView.addConstraint(datePickerCenterY)
        datePickerContainerView.addConstraints(internalDatePickerH)
        datePickerContainerView.addConstraints(internalDatePickerV)
        
        let mapViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[mapView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let mapViewV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[mapView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        
        locationPickerContainerView.addConstraints(mapViewH)
        locationPickerContainerView.addConstraints(mapViewV)
        
        
        let locationPickerH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[locationPickerContainerView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let locationPickerV = NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide][locationPickerContainerView][bottomLayoutGuide]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        
        view.addConstraints(locationPickerH)
        view.addConstraints(locationPickerV)
        
        let unlockLabelsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[unlockSettingsTitleLabel]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let unlockLabelsV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-12-[unlockSettingsTitleLabel]-4-[unlockSettingsDetailLabel]", options: [.AlignAllLeft, .AlignAllRight], metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let unlockSeparatorV = NSLayoutConstraint.constraintsWithVisualFormat("V:[unlockSettingsDetailLabel]-12-[unlockSettingsSeparatorView(1)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let unlockSeparatorH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[unlockSettingsSeparatorView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        
        unlockSettingsSummaryLabelsContainerView.addConstraints(unlockLabelsH)
        unlockSettingsSummaryLabelsContainerView.addConstraints(unlockLabelsV)
        unlockSettingsSummaryLabelsContainerView.addConstraints(unlockSeparatorV)
        unlockSettingsSummaryLabelsContainerView.addConstraints(unlockSeparatorH)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func doneButtonTapped() {
        print("done button tapped")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateViewToSegment(){
        print("update view to segment")
        datePickerContainerView.hidden = !datePickerContainerView.hidden
        locationPickerContainerView.hidden = !locationPickerContainerView.hidden
        if locationPickerContainerView.hidden == false{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(UnlockSettingsViewController.locationSearchButtonTapped))
        }
        else{
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func locationSearchButtonTapped(){
        print("location search button tapped")
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.region)
    }
    
    func datePickerChanged() {
        print(datePicker.date)
    }
}
