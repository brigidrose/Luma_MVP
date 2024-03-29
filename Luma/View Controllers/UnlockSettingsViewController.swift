//
//  UnlockSettingsViewController.swift
//  Luma
//
//  Created by Chun-Wei Chen on 6/9/16.
//  Copyright © 2016 Luma Legacy. All rights reserved.
//

import UIKit
import MapKit
import Parse

class UnlockSettingsViewController: UIViewController, MKMapViewDelegate {

    var newMomentVC:NewMomentViewController!
    
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
        if newMomentVC.unlockDate != nil{
            datePicker.date = newMomentVC.unlockDate!
        }
        datePickerContainerView.addSubview(datePicker)
        
        locationPickerContainerView = UIView(frame: CGRectZero)
        locationPickerContainerView.translatesAutoresizingMaskIntoConstraints = false
        locationPickerContainerView.backgroundColor = Colors.white
        locationPickerContainerView.hidden = true
        view.addSubview(locationPickerContainerView)
        
        
        mapView = MKMapView(frame: CGRectZero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = false
        mapView.delegate = self
        if newMomentVC.unlockLocation != nil{
            mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: newMomentVC.unlockLocation!.latitude, longitude:newMomentVC.unlockLocation!.longitude), span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15))
        }
        else{
            mapView.region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15))
        }

        locationPickerContainerView.addSubview(mapView)
        
        let mapPinImageView = UIImageView(frame:CGRectZero)
        mapPinImageView.translatesAutoresizingMaskIntoConstraints = false
        mapPinImageView.image = UIImage(named: "mapPin")
        locationPickerContainerView.addSubview(mapPinImageView)

        
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
        if newMomentVC.unlockLocation != nil{
            segmentedControl.selectedSegmentIndex = 1
        }
        else if newMomentVC.unlockDate != nil{
            segmentedControl.selectedSegmentIndex = 0
        }
        else{
            segmentedControl.selectedSegmentIndex = 0
        }
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
        unlockSettingsTitleLabel.text = "Loading..."
        unlockSettingsSummaryLabelsContainerView.addSubview(unlockSettingsTitleLabel)
        
        unlockSettingsDetailLabel = UILabel(frame: CGRectZero)
        unlockSettingsDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        unlockSettingsDetailLabel.textAlignment = .Left
        unlockSettingsDetailLabel.font = UIFont.systemFontOfSize(13)
        unlockSettingsDetailLabel.text = "Longitude: \(round(1000 * mapView.centerCoordinate.longitude)/1000)   Latitude: \(round(1000 * mapView.centerCoordinate.latitude)/1000)"
        unlockSettingsSummaryLabelsContainerView.addSubview(unlockSettingsDetailLabel)
        
        unlockSettingsSeparatorView = UIView(frame: CGRectZero)
        unlockSettingsSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        unlockSettingsSeparatorView.backgroundColor = Colors.separatorGray
        unlockSettingsSummaryLabelsContainerView.addSubview(unlockSettingsSeparatorView)
        
        
        let viewsDictionary = ["topLayoutGuide":topLayoutGuide, "bottomLayoutGuide":bottomLayoutGuide, "segmentedControlContainerView":segmentedControlContainerView, "segmentedControlContainerSeparatorView":segmentedControlContainerSeparatorView, "segmentedControl":segmentedControl,"datePickerContainerView":datePickerContainerView, "locationPickerContainerView":locationPickerContainerView, "unlockSettingsSummaryLabelsContainerView":unlockSettingsSummaryLabelsContainerView, "unlockSettingsTitleLabel":unlockSettingsTitleLabel, "unlockSettingsDetailLabel":unlockSettingsDetailLabel, "unlockSettingsSeparatorView":unlockSettingsSeparatorView, "datePicker":datePicker, "mapView":mapView, "mapPinImageView":mapPinImageView]
        
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
        
        let mapPinImageViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:[mapPinImageView]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let mapPinImageViewV = NSLayoutConstraint.constraintsWithVisualFormat("V:[mapPinImageView]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let mapPinImageViewCenterX = NSLayoutConstraint(item: mapPinImageView, attribute: .CenterX, relatedBy: .Equal, toItem: mapView, attribute: .CenterX, multiplier: 1, constant: 7)
        let mapPinImageViewCenterY = NSLayoutConstraint(item: mapPinImageView, attribute: .CenterY, relatedBy: .Equal, toItem: mapView, attribute: .CenterY, multiplier: 1, constant: -15)
        
        locationPickerContainerView.addConstraints(mapPinImageViewH)
        locationPickerContainerView.addConstraints(mapPinImageViewV)
        locationPickerContainerView.addConstraint(mapPinImageViewCenterX)
        locationPickerContainerView.addConstraint(mapPinImageViewCenterY)
        updateViewToSegment()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func doneButtonTapped() {
        print("done button tapped")
        if segmentedControl.selectedSegmentIndex == 0{
            newMomentVC.unlockDate = datePicker.date
            newMomentVC.unlockLocation = nil
            updateLabelsWithTime()
        }
        else{
            newMomentVC.unlockLocation = PFGeoPoint(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            newMomentVC.unlockDate = nil
            updateLabelsWithLocation()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateViewToSegment(){
        print("update view to segment")
        updateLabelsWithTime()
        updateLabelsWithLocation()
        
        if segmentedControl.selectedSegmentIndex == 0{
            datePickerContainerView.hidden = false
            locationPickerContainerView.hidden = true
        }
        else{
            datePickerContainerView.hidden = true
            locationPickerContainerView.hidden = false
        }
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
        updateLabelsWithLocation()
    }
    
    func updateLabelsWithLocation() {
        if segmentedControl.selectedSegmentIndex == 1{
            self.unlockSettingsTitleLabel.text = "Unlocks Near"
            self.unlockSettingsDetailLabel.text = "loading location..."
        }
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)) { (places, error) in
            if places?.count > 0{
                let place = places![0]
                if self.segmentedControl.selectedSegmentIndex == 1{
                    if (place.subThoroughfare != nil && place.thoroughfare != nil && place.locality != nil && place.administrativeArea != nil){
                        self.unlockSettingsTitleLabel.text = "\(place.subThoroughfare!) \(place.thoroughfare!)"
                        self.unlockSettingsDetailLabel.text = "\(place.locality!), \(place.administrativeArea!)"
                        self.newMomentVC.unlockTypeLabel.text = "Unlocks Near"
                        self.newMomentVC.unlockParameterLabel.text = "\(place.subThoroughfare!) \(place.thoroughfare!)"
                    }
                    else{
                        self.unlockSettingsTitleLabel.text = "Unlocks Near"
                        self.newMomentVC.unlockTypeLabel.text = "Unlocks Near"
                        if place.locality != nil && place.administrativeArea != nil{
                            self.unlockSettingsDetailLabel.text = "\(place.locality!), \(place.administrativeArea!)"
                            self.newMomentVC.unlockParameterLabel.text = "\(place.locality!), \(place.administrativeArea!)"
                        }
                        else{
                            self.unlockSettingsDetailLabel.text = "Latitude: \(round(100 * self.mapView.centerCoordinate.latitude)/100)   Longitude: \(round(100 * self.mapView.centerCoordinate.longitude)/100)"
                            self.newMomentVC.unlockParameterLabel.text = "Latitude: \(round(100 * self.mapView.centerCoordinate.latitude)/100)   Longitude: \(round(100 * self.mapView.centerCoordinate.longitude)/100)"
                        }
                    }
                }
            }
        }

    }
    
    func updateLabelsWithTime(){
        let date = datePicker.date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        let timeFormatter = NSDateFormatter()
        timeFormatter.timeStyle = .ShortStyle
        
        if segmentedControl.selectedSegmentIndex == 0{
            self.unlockSettingsTitleLabel.text = "\(dateFormatter.stringFromDate(date))  \(timeFormatter.stringFromDate(date))"
            self.newMomentVC.unlockParameterLabel.text = "\(dateFormatter.stringFromDate(date))  \(timeFormatter.stringFromDate(date))"
            self.newMomentVC.unlockTypeLabel.text = "Unlocks At"
            self.unlockSettingsDetailLabel.text = "the moment will unlock at this time"
        }
    }
    
    func datePickerChanged() {
        updateLabelsWithTime()
    }
}
