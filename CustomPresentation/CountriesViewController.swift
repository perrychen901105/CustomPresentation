/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class CountriesViewController: UIViewController {
  
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var collectionViewLeadingConstraint: NSLayoutConstraint!
  @IBOutlet var collectionViewTrailingConstraint: NSLayoutConstraint!
  
    let simpleTransitionDelegate = SimpleTransitioningDelegate()
    
    var awesomeTransitionDelegate: AwesomeTransitioningDelegate?
    
    var selectionObject: SelectionObject?
    
  var countries = Country.countries()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imageView.image = UIImage(named: "BackgroundImage")
    
    let flowLayout = CollectionViewLayout(
      traitCollection: traitCollection)
    
    flowLayout.invalidateLayout()
    collectionView.setCollectionViewLayout(flowLayout,
      animated: false)
    
    collectionView.reloadData()
  }
  
  
  override func traitCollectionDidChange(previousTraitCollection:
    (UITraitCollection!)) {
      
      if collectionView.traitCollection.userInterfaceIdiom
        == UIUserInterfaceIdiom.Phone {
          
          // Increase leading and trailing constraints to center cells
          var padding: CGFloat = 0.0
          var viewWidth = view.frame.size.width
          
          if viewWidth > 320.0 {
            padding = (viewWidth - 320.0) / 2.0
          }
          
          collectionViewLeadingConstraint.constant = padding
          collectionViewTrailingConstraint.constant = padding
      }
  }
  
  
  // pragma mark - UICollectionViewDataSource
  
  func numberOfSectionsInCollectionView(collectionView:
    UICollectionView!) -> Int {
      return 1
  }
  
  func collectionView(collectionView: UICollectionView!,
    numberOfItemsInSection section: Int) -> Int {
      
      return countries.count
  }
  
  func collectionView(collectionView: UICollectionView!,
    cellForItemAtIndexPath indexPath: NSIndexPath!) ->
    UICollectionViewCell! {
      
      var cell: CollectionViewCell =
      collectionView.dequeueReusableCellWithReuseIdentifier(
        "CollectionViewCell", forIndexPath: indexPath)
        as CollectionViewCell;
      
      let country = countries[indexPath.row] as Country
      var image: UIImage = UIImage(named: country.imageName);
      cell.imageView.image = image;
      cell.imageView.layer.cornerRadius = 4.0
      
        // checks to see if there is a selectionObject, and that it's not the same as the one being displayed. If so, it uses the value stored in the new property of Country to update the visibility of the image view. If there is no selectionObject, then the image view is shown
        
        if selectionObject != nil && selectionObject?.country.countryName == country.countryName {
            cell.imageView.hidden = selectionObject!.country.isHidden
        } else {
            cell.imageView.hidden = false
        }
        
        
      return cell;
  }
  
  
  // pragma mark - UICollectionViewDelegate
  
  func collectionView(collectionView: UICollectionView!,
    didSelectItemAtIndexPath indexPath: NSIndexPath!) {
      showSimpleOverlayForIndexPath(indexPath)

  }
  
    func showSimpleOverlayForIndexPath(indexPath: NSIndexPath) {
//        let country = countries[indexPath.row] as Country
//        
//        transitioningDelegate = simpleTransitionDelegate
//        
//        var overlay = OverlayViewController(country: country)
//        overlay.transitioningDelegate = simpleTransitionDelegate
//        
//        presentViewController(overlay, animated: true, completion: nil)
        
        showAwesomeOverlayForIndexPath(indexPath)
    
    }
  
    func showAwesomeOverlayForIndexPath(indexPath: NSIndexPath) {
        let country = countries[indexPath.row] as Country
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as CollectionViewCell
        
        // 1    Get the collection view cell's frame for the cell at the index path. Use the value from the cells' superview so that you're using the actual position from the view controller and not just the position in the collection view.
        var rect = selectedCell.frame
        let origin = view.convertPoint(rect.origin, fromView: selectedCell.superview)
        rect.origin = origin
    
        
        // 2    Create a selection object using the country, indexPath, and frame of the cell
        selectionObject = SelectionObject(country: country, selectedCellIndexPath: indexPath, originalCellPosition: rect)
    
        
        // 3    Next assign awesomeTransitionDelegate an instance of AwesomeTransitionDelegate, configured with your selection object, and set it as the view controller's transitioningDelegate
        awesomeTransitionDelegate = AwesomeTransitioningDelegate(selectedObject: selectionObject!)
        transitioningDelegate = awesomeTransitionDelegate
        
        // 4    Finally, create and present the overlay
        var overlay = OverlayViewController(country: country)
        overlay.transitioningDelegate = awesomeTransitionDelegate
        presentViewController(overlay, animated: true, completion: nil)
        
        UIView.animateWithDuration(0.1, animations: {selectedCell.imageView.alpha = 0.0}, completion: nil)
        
    }

    func hideImage(hidded: Bool, indexPath: NSIndexPath) {
        if selectionObject != nil {
            selectionObject!.country.isHidden = hidded
        }
        
        if indexPath.row < self.countries.count {
            collectionView.reloadItemsAtIndexPaths([indexPath])
        }
    }
    
    // returns an array of indexPaths for all of the country objects being displayed in the collection view
    func indexPathsForAllItems() -> NSMutableArray {
        var count = countries.count
        var indexPaths = NSMutableArray()
        for var index = 0; index < count; ++index {
            indexPaths.addObject(NSIndexPath(forItem: index, inSection: 0))
        }
        return indexPaths
    }
    
    // takes the indexPaths returned from the previous method you added and either deletes the objects if the content is beign presented, or it inserts the objects if the content is being dismissed.
    
    /*
    *
    Adding objects to, or deleting objects from the collection view animates the cells in the left column to and from the left side of the screen, while the cells in the right column move to and from the right side of the screen.
    */
    func changeCellSpacingFroPresentation(presentation: Bool) {
        if presentation {
            var indexPaths = indexPathsForAllItems()
            countries = NSArray()
            collectionView.deleteItemsAtIndexPaths(indexPaths)
        } else {
            countries = Country.countries()
            var indexPaths = indexPathsForAllItems()
            collectionView.insertItemsAtIndexPaths(indexPaths)
        }
    }
    
    // return the frame of a cell at the given indexPath
    func frameForCellAtIndexPath(indexPath: NSIndexPath) -> CGRect {
        var cell = collectionView.cellForItemAtIndexPath(indexPath) as CollectionViewCell
        return cell.frame
    }
    
}

