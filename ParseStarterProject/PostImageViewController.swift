//
//  PostImageViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Nicolas Dubus on 2016-01-08.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let compressionQuality: CGFloat = 1.0
    
    var activityIndicator = UIActivityIndicatorView()
    var baseImage = UIImage(named: "Compact Camera-100.png")
    
    @IBOutlet weak var imageToPost: UIImageView!
    
    @IBOutlet weak var message: UITextField!
    
    @IBAction func postImage(sender: AnyObject) {
        
        if (imageToPost.image?.isEqual(baseImage)) == nil && message.text != "" {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        var post = PFObject(className: "Post")
        post["message"] = message.text
        post["userid"] = PFUser.currentUser()?.objectId
        let imageData = UIImageJPEGRepresentation(imageToPost.image!, compressionQuality)
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackgroundWithBlock { (success, error) -> Void in
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            self.activityIndicator.stopAnimating()
            
            if error == nil {
                self.displayAlert("Image Posted", message: "Your image was successfully posted")
                self.imageToPost.image = UIImage(named: "Compact Camera-100.png")
                self.message.text = ""
            } else {
                self.displayAlert("Error", message: "There was an error posting your image")
                print("Error saving image")
                print(error)
            }

        }
        } else {
            if (imageToPost.image?.isEqual(baseImage)) != nil {
                displayAlert("Error", message: "Please Select an image")
            } else if message.text == "" {
                displayAlert("Error", message: "Please Enter a Description")
            }
        }
    }
    
    @IBAction func chooseImage(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        imageToPost.image = image

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
