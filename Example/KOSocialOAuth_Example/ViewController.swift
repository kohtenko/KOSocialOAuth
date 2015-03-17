//
//  ViewController.swift
//  KOSocialOAuth_Example
//
//  Created by okohtenko on 16/03/15.
//  Copyright (c) 2015 kohtenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signInVK(){
        let ctrl = KOSocialOAuthViewContorller()
        ctrl.vkClientID = "4359501"
        ctrl.vkScope = "offline,friends"
        presentViewController(ctrl, animated: true, completion: nil)
    }
    
    @IBAction func signInInstagram(){
        let ctrl = KOSocialOAuthViewContorller()
        ctrl.instagramClientID = "ffa8f82db05a48dfa3665416e23761ab"
        ctrl.instagramClientSecret = "941d2d4c5f5e48f294d60b07f839a4d0"
        ctrl.instagramRedirectURL = "http://vk.com/LikeApp"
        presentViewController(ctrl, animated: true, completion: nil)
    }
    
    @IBAction func signInLinkedIn(){
        let ctrl = KOSocialOAuthViewContorller()
        ctrl.linkedInClientID = "lrskqzw5799t"
        ctrl.linkedInClientSecret = "dmTwJALHRBD76Ntt"
        ctrl.linkedInRedirectURL = "http://linkedIn.login.com"
        ctrl.linkedInState = "JNju88aebwei31ijm"
        presentViewController(ctrl, animated: true, completion: nil)
    }
    
}

