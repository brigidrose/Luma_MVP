//
//  LumaStoreViewController.swift
//  
//
//  Created by Chun-Wei Chen on 5/16/16.
//
//

import UIKit
import TPKeyboardAvoiding

class LumaStoreViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageVC:UIPageViewController!
    var storeSectionsView:UIView!
    var selectedStoreSectionIndex = 0
    var storeSectionsSegmentedControl:UISegmentedControl!
    var braceletStoreVC:BraceletStoreViewController!
    var charmStoreVC:CharmStoreViewController!
    var viewControllers:[UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        view.tintColor = Colors.primary
        navigationItem.title = "Luma Store"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "CloseBarButtonItem"), style: .Plain, target: self, action: #selector(LumaStoreViewController.closeBarButtonItemTapped(_:)))
        
        pageVC = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageVC.dataSource = self
        pageVC.view.frame = CGRectZero
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        pageVC.view.clipsToBounds = false
        pageVC.delegate = self
        view.addSubview(pageVC.view)
        
        storeSectionsView =  UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight)) as UIVisualEffectView
        storeSectionsView.frame = CGRectZero
        storeSectionsView.translatesAutoresizingMaskIntoConstraints = false
        
        storeSectionsSegmentedControl = UISegmentedControl(items: ["Bracelet", "Charms"])
        storeSectionsSegmentedControl.frame = CGRectZero
        storeSectionsSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        storeSectionsSegmentedControl.selectedSegmentIndex = 0
        storeSectionsSegmentedControl.addTarget(self, action: #selector(LumaStoreViewController.storeSectionSegmentChanged(_:)), forControlEvents: .ValueChanged)

        let storeSectionsSeparatorView = UIView(frame: CGRectZero)
        storeSectionsSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        storeSectionsSeparatorView.backgroundColor = Colors.separatorGray

        let metricsDictionary = ["sidePadding":15, "verticalPadding":7.5]
        let viewsDictionary = ["pageVCView":pageVC.view, "topLayoutGuide":topLayoutGuide, "bottomLayoutGuide":bottomLayoutGuide, "storeSectionsView":storeSectionsView, "storeSectionsSegmentedControl":storeSectionsSegmentedControl, "storeSectionsSeparatorView":storeSectionsSeparatorView]
        
        let pageVCViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[pageVCView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String : AnyObject])
        let pageVCViewV = NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide][pageVCView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String : AnyObject])
        view.addConstraints(pageVCViewH + pageVCViewV)
        
        braceletStoreVC = BraceletStoreViewController()
        addChildViewController(braceletStoreVC)

        charmStoreVC = CharmStoreViewController()
        charmStoreVC.view.frame = view.frame
        addChildViewController(charmStoreVC)
        
        viewControllers = [braceletStoreVC]
        pageVC.setViewControllers(viewControllers , direction: .Forward, animated: false, completion: nil)
        addChildViewController(pageVC)
        
        view.addSubview(storeSectionsView)
        
        let storeSectionsViewH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[storeSectionsView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let storeSectionsViewV = NSLayoutConstraint.constraintsWithVisualFormat("V:[topLayoutGuide][storeSectionsView(44)]", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        view.addConstraints(storeSectionsViewH + storeSectionsViewV)
        
        
        storeSectionsView.addSubview(storeSectionsSegmentedControl)
        
        storeSectionsView.addSubview(storeSectionsSeparatorView)
        
        let storeSectionsSegmentedControlH = NSLayoutConstraint.constraintsWithVisualFormat("H:|-sidePadding-[storeSectionsSegmentedControl]-sidePadding-|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        let storeSectionsSeparatorH = NSLayoutConstraint(item: storeSectionsSeparatorView, attribute: .Width, relatedBy: .Equal, toItem: storeSectionsView, attribute: .Width, multiplier: 1, constant: 0)
        let storeSectionsInternalV = NSLayoutConstraint.constraintsWithVisualFormat("V:|-verticalPadding-[storeSectionsSegmentedControl(28)]-verticalPadding-[storeSectionsSeparatorView(1)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: metricsDictionary, views: viewsDictionary as! [String:AnyObject])
        
        storeSectionsView.addConstraints(storeSectionsSegmentedControlH + storeSectionsInternalV)
        storeSectionsView.addConstraint(storeSectionsSeparatorH)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        if viewController.isMemberOfClass(CharmStoreViewController){
            return viewControllerAtIndex(0)
        }
        else{
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        if viewController.isMemberOfClass(BraceletStoreViewController){
            return viewControllerAtIndex(1)
        }
        else{
            return nil
        }
    }
    
    
    func viewControllerAtIndex(index: Int) -> UIViewController
    {
        // Create a new view controller and pass suitable data.
        if index == 0{
            return braceletStoreVC
        }
        else{
            return charmStoreVC
        }
    }
    
    func closeBarButtonItemTapped(sender:UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func storeSectionSegmentChanged(sender:UISegmentedControl) {
        selectedStoreSectionIndex = sender.selectedSegmentIndex
        if selectedStoreSectionIndex == 0{
            pageVC.setViewControllers([viewControllerAtIndex(selectedStoreSectionIndex)], direction: .Reverse, animated: true, completion: nil)
        }
        else{
            pageVC.setViewControllers([viewControllerAtIndex(selectedStoreSectionIndex)], direction: .Forward, animated: true, completion: nil)

        }
    }
    

    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed{
            if previousViewControllers[0].isMemberOfClass(BraceletStoreViewController){
                selectedStoreSectionIndex = 1
            }
            else{
                selectedStoreSectionIndex = 0
            }
            storeSectionsSegmentedControl.selectedSegmentIndex = selectedStoreSectionIndex
            
        }
    }
    

}
