//
//  ProfileViewController.swift
//  ExchangeAGram
//
//  Created by SANTIPONG TANCHATCHAWAL on 6/29/15.
//  Copyright (c) 2015 SANTIPONG TANCHATCHAWAL. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, FBLoginViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var fbLoginView: FBLoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "publish_actions"]
        
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
    
    /// CONFORM FBLoginViewDelegate Protocol
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        profileImageView.hidden = false
        profileNameLabel.hidden = false
        
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        println(user)
        profileNameLabel.text = user.name
        
        let userImageURL = "https://graph.facebook.com/\(user.objectID)/picture?type=small"
        let url = NSURL(string: userImageURL)
        let imageData = NSData(contentsOfURL: url!)
        let image = UIImage(data: imageData!)
        
        profileImageView.image = image
        
    }
    
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        profileImageView.hidden = true
        profileNameLabel.hidden = true
    }
    
    
    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        println("ERROR: \(error.localizedDescription)")

    }

}
