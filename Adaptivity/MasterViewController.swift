//
//  ViewController.swift
//  Adaptivity
//
//  Created by Stephen Anthony on 15/12/2015.
//  Copyright © 2015 Darjeeling Apps. All rights reserved.
//

import UIKit

private let PresentCountyWithAnimationSegueIdentifier = "PresentCountyWithAnimation"
private let PresentCountyWithNoAnimationSegueIdentifier = "PresentCountyWithNoAnimation"

/// The view controller responsible for displaying the county collection view.
class MasterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CountyViewControllerDelegate, UISearchBarDelegate {
    @IBOutlet internal var collectionView: UICollectionView!
    @IBOutlet private var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet private var searchBar: UISearchBar!
    internal var selectedCounty: County?
    private var searchResults: [County]?
    internal var countiesToDisplay: [County] {
        get {
            return searchResults ?? County.allCounties
        }
    }
    var history: CountyHistory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: view)
        }
    }
    
    func showCounty(county: County, animated: Bool) {
        selectedCounty = county
        history?.viewed(county)
        let segueIdentifier = animated ? PresentCountyWithAnimationSegueIdentifier : PresentCountyWithNoAnimationSegueIdentifier
        performSegueWithIdentifier(segueIdentifier, sender: self)
    }
    
    func beginSearch() {
        searchBar.becomeFirstResponder()
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        if styleForTraitCollection(newCollection) != styleForTraitCollection(traitCollection) {
            collectionView.reloadData() // Reload cells to adopt the new style
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        if styleForTraitCollection(traitCollection) == .Table {
            flowLayout.invalidateLayout() // Called to update the cell sizes to fit the new collection view width
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navigationController = segue.destinationViewController as? UINavigationController,
            countyViewController = navigationController.topViewController as? CountyViewController {
                countyViewController.county = selectedCounty
                countyViewController.delegate = self
        }
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countiesToDisplay.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let countyCell = collectionView.dequeueReusableCellWithReuseIdentifier("CountyCell", forIndexPath: indexPath) as! CountyCell
        countyCell.county = countiesToDisplay[indexPath.row]
        countyCell.displayStyle = styleForTraitCollection(traitCollection)
        return countyCell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return styleForTraitCollection(traitCollection).itemSizeInCollectionView(collectionView)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return styleForTraitCollection(traitCollection).collectionViewEdgeInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return styleForTraitCollection(traitCollection).collectionViewLineSpacing
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        showCounty(countiesToDisplay[collectionView.indexPathsForSelectedItems()!.first!.item], animated: true)
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
    }
    
    //MARK: UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults = County.allCounties.filter({$0.name.hasPrefix(searchBar.text ?? "")})
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchResults = nil
        collectionView.reloadData()
    }
    
    //MARK: CountyViewControllerDelegate
    func countyViewControllerDidFinish(countyViewController: CountyViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Private Methods
    private func styleForTraitCollection(traitCollection: UITraitCollection) -> CountyCellDisplayStyle {
        return traitCollection.horizontalSizeClass == .Regular ? .Grid : .Table
    }
}

// MARK: - CountyCellDisplayStyle extension to provide collection view layout information based on a display style.
extension CountyCellDisplayStyle {
    func itemSizeInCollectionView(collectionView: UICollectionView) -> CGSize {
        switch (self) {
        case .Table:
            return CGSize(width: CGRectGetWidth(collectionView.bounds), height: 100)
        case .Grid:
            return CGSize(width: 150, height: 120)
        }
    }
    
    var collectionViewEdgeInsets: UIEdgeInsets {
        switch (self) {
        case .Table:
            return UIEdgeInsetsZero
        case .Grid:
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    
    var collectionViewLineSpacing: CGFloat {
        switch (self) {
        case .Table:
            return 0
        case .Grid:
            return 44
        }
    }
}