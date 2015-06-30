//
//  FeedViewController.swift
//  ExchangeAGram
//
//  Created by SANTIPONG TANCHATCHAWAL on 6/25/15.
//  Copyright (c) 2015 SANTIPONG TANCHATCHAWAL. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData


class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var feedArray:[AnyObject] = []
    
    @IBAction func profileButtonPressed(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("showProfile", sender: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let request = NSFetchRequest(entityName: "FeedItem")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDelegate.managedObjectContext!
        feedArray = context.executeFetchRequest(request, error: nil)!  // This function does not know what type it is going to return that's why we use AnyObject
        collectionView.reloadData()
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
    
    
    @IBAction func cameraButtonPressed(sender: UIBarButtonItem) {
        // check if camera is available
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            var cameraController = UIImagePickerController()
            cameraController.delegate = self  // need UIImagePickerControllerDelegate and UINavigationControllerDelegate
            cameraController.sourceType = UIImagePickerControllerSourceType.Camera
            
            let mediaTypes:[AnyObject] = [kUTTypeImage]
            cameraController.mediaTypes = mediaTypes
            cameraController.allowsEditing = false
            
            self.presentViewController(cameraController, animated: true, completion: nil)
            
        } else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            var photoLibraryController = UIImagePickerController()
            photoLibraryController.delegate = self
            photoLibraryController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            let mediaTypes:[AnyObject] = [kUTTypeImage]
            photoLibraryController.mediaTypes = mediaTypes
            photoLibraryController.allowsEditing = false
            
            self.presentViewController(photoLibraryController, animated: true, completion: nil)
        } else {
            var alertView = UIAlertController(title: "ERROR", message: "Your Device does not support camera and photo library. Weird!", preferredStyle: UIAlertControllerStyle.Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertView, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    // UICollectionViewDataSource protocol
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell:FeedCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! FeedCell
        
        let thisItem = feedArray[indexPath.row] as! FeedItem
        
        cell.imageView.image = UIImage(data: thisItem.image)
        cell.captionLabel.text = thisItem.caption
        
        
        return cell
        
    }
    
    // UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let thisItem = feedArray[indexPath.row] as! FeedItem
        

        // ### CREATE FilterViewController by CODE #####
        var filterVC = FilterViewController()
        filterVC.thisFeedItem = thisItem
        
        self.navigationController?.pushViewController(filterVC, animated: true)
        
        
    }
    
    // UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        // info is dictionary key value pair
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let imageData = UIImageJPEGRepresentation(image, 1.0)   // return NSData instance
        let thumbNailData = UIImageJPEGRepresentation(image, 0.1)
        
        
        // CORE DATA
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("FeedItem", inManagedObjectContext: managedObjectContext!)
        let feedItem = FeedItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        
        feedItem.image = imageData
        feedItem.caption = "test caption"
        feedItem.thumbnail = thumbNailData
        
        let UUID = NSUUID().UUIDString
        feedItem.uniqueID = UUID
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
        
        feedArray.append(feedItem)
        
        
        
        
        // dismiss the view controller once we picked the image
        self.dismissViewControllerAnimated(true, completion: nil)
        self.collectionView.reloadData()
    }
    
    

}
