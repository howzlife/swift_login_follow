/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupActive = true
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var registeredText: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBAction func signUp(sender: AnyObject) {
        
        if username.text == "" || password.text == "" {
           displayAlert("Error", message: "Please enter a username and password")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            if signupActive {
                
            var user = PFUser()
            user.username = username.text
            user.password = password.text
            
            var errorMessage = "Please try again later"
            
            user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil {
                    //Signup Successful
                
                } else {
                    
                    if let errorString = error!.userInfo["error"] as? NSString {
                        errorMessage = errorString as String
                    }
                    
                    print(errorMessage)
                    self.displayAlert("Failed Signup", message: errorMessage)
                }
            })
        
            } else {
                
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block:
                    { (user, error) -> Void in
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        if user != nil {
                            // Logged In!
                        } else {
                            print(error)
                            self.displayAlert("Failed Signup", message: "Please try again later")
                        }
                    
            })
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func login(sender: AnyObject) {
        
        if signupActive {
            signupButton.setTitle("Login", forState: UIControlState.Normal)
            registeredText.text = "Not Registered?"
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            signupActive = false
        } else {
            signupButton.setTitle("Sign Up", forState: UIControlState.Normal)
            registeredText.text = "Already Registered?"
            loginButton.setTitle("Log In", forState: UIControlState.Normal)
            signupActive = true
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlert(title: String, message: String) {
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
}
