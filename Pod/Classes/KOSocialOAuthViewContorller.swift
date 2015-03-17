//
//  KOSocialOAuthViewContorller.swift
//  KOSocialOAuth_Example
//
//  Created by okohtenko on 16/03/15.
//  Copyright (c) 2015 kohtenko. All rights reserved.
//

import UIKit

protocol KOSocialOAuthViewControllerDelegate: class{
    
    func instagramLoginFinishedWithToken(accessToken: String?)
    func linkedInLoginFinishedWithToken(accessToken: String?)
    func vkLoginFinishedWithToken(accessToken: String?)
    
}

enum KOSocialOAuthService: Int{
    case VK
    case Instagram
    case LinkedIn
    case Facebook
    case Twitter
}

class KOSocialOAuthViewContorller: UIViewController, UIWebViewDelegate {
    
    weak var delegate: KOSocialOAuthViewControllerDelegate?
    var service: KOSocialOAuthService = .VK
    
    /// Go to http://vk.com/dev and create app. Set appId to this property
    var vkClientID: String?
    
    /// Go to http://vk.com/dev/permissions and decide which permission do need. Set string of coma separated values to this property. (Example: "offline,friends")
    var vkScope: String?
    
    
    /// Go to https://instagram.com/developer and create app. Set ClientID to this property
    var instagramClientID: String?
    
    /// Go to https://instagram.com/developer and create app. Set ClientID to this property
    var instagramClientSecret: String?
    
    /// Go to https://instagram.com/developer and create app. Set RedirectURL to this property (You can use any URL in app setting)
    var instagramRedirectURL: String?
    
    
    /// Go to https://developer.linkedin.com/docs/oauth2 and create app. Set Consumer Key / API Key to this property
    var linkedInClientID: String?
    
    /// Go to https://developer.linkedin.com/docs/oauth2 and create app. Set Consumer Secret to this property
    var linkedInClientSecret: String?
    
    /// Go to https://developer.linkedin.com/docs/oauth2 and create app. Set RedirectURL to this property (You can use any URL in app setting OAuth 2.0 Redirect URLs)
    var linkedInRedirectURL: String?
    
    /// Setup a unique string value of your choice that is hard to guess. Used to prevent CSRF. e.g. state=DCEeFWf45A53sdfKef424
    var linkedInState: String?
    
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var urlString = ""
        switch service {
        case .VK:
            if vkClientID != nil && vkScope != nil {
                urlString = "https://oauth.vk.com/authorize?client_id=\(vkClientID!)&scope=\(vkScope!)&redirect_uri=blank.html&response_type=token"
            }
        case .Instagram:
            if instagramClientID != nil && instagramRedirectURL != nil {
                urlString = "https://api.instagram.com/oauth/authorize/?client_id=\(instagramClientID!)&redirect_uri=\(instagramRedirectURL!)&response_type=code"
            }
        case .LinkedIn:
            if linkedInClientID != nil && linkedInState != nil && linkedInRedirectURL != nil{
                urlString = "https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=\(linkedInClientID!)&state=\(linkedInState!)&redirect_uri=\(linkedInRedirectURL!)"
            }
        default:
            break
        }
        if let url = NSURL(string: urlString) {
            webView.loadRequest(NSURLRequest(URL: url))
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL?.absoluteString{
            switch service {
            case .VK:
                if let range = url.rangeOfString("#access_token="){
                    if let endRange = url.rangeOfString("&") {
                        
                        let accessToken = url.substringWithRange(Range(start:range.startIndex, end:endRange.endIndex))
                        
                        delegate?.vkLoginFinishedWithToken(accessToken)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
                        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        return false
                    }
                }
                
            case .Instagram:
                
                if let code = getCodeFromUrl(url){
                    let session = NSURLSession.sharedSession()
                    
                    let request = NSMutableURLRequest(URL: NSURL(string: "https://api.instagram.com/oauth/access_token")!)
                    
                    request.HTTPMethod = "POST"
                    let postString = "client_id=\(instagramClientID!)&client_secret=\(instagramClientSecret!)&grant_type=authorization_code&redirect_uri=\(instagramRedirectURL!)&code=\(code)"
                    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                    
                    session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                        
                        if let dict = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil) as? NSDictionary {
                            if let access_token = dict["access_token"] as? String{
                                self.delegate?.instagramLoginFinishedWithToken(access_token)
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }else{
                                self.cancelPressed()
                            }
                        }else{
                            self.cancelPressed()
                        }
                    }).resume()
                    return false
                }
            case .LinkedIn:
                if let code = getCodeFromUrl(url){
                    let urlLinkedIn = "https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code&code=%@&redirect_uri=\(linkedInRedirectURL!)&client_id=\(linkedInClientID!)&client_secret=\(linkedInClientSecret!)"
                    
                    NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlLinkedIn)!, completionHandler: { (data, response, error) -> Void in
                        
                        if let dict = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil) as? NSDictionary{
                            if let access_token = dict["access_token"] as? String{
                                self.delegate?.linkedInLoginFinishedWithToken(access_token)
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                            else{
                                self.cancelPressed()
                            }
                        }else{
                            self.cancelPressed()
                        }
                    }).resume()
                    return false
                }
                
            default:
                break
            }
        }
        return true
        
    }
    
    
    func getCodeFromUrl(url: String) -> String?{
        if let range = url.rangeOfString("?code="){
            let endRange = url.rangeOfString("&")
            let startLocation = range.endIndex
            
            let endLocation = endRange == nil ? url.endIndex : endRange!.startIndex
            
            let rangeOfCode = Range(start: startLocation,
                end: endLocation)
            let code = url.substringWithRange(Range(start:startLocation, end:endLocation))
            return code
        }
        return nil
    }
    
    @IBAction func cancelPressed(){
        switch service {
        case .Instagram:
            delegate?.instagramLoginFinishedWithToken(nil)
        case .LinkedIn:
            delegate?.linkedInLoginFinishedWithToken(nil)
        case .VK:
            delegate?.vkLoginFinishedWithToken(nil)
        default:
            break
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}