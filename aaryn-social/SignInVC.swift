//
//  ViewController.swift
//  aaryn-social
//
//  Created by Maureen Biro on 2017-05-25.
//  Copyright © 2017 Aaryn Biro. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordField: FancyField!
    @IBOutlet weak var emailField: FancyField!
    
    
    var writingText = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        passwordField.delegate = self
        emailField.delegate = self
        
      
        passwordField.returnKeyType = UIReturnKeyType.done
        emailField.returnKeyType = UIReturnKeyType.done
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignInVC.dismissKeyboard))

        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        //key storke in search bar is change, this is called
//        if searchBar.text == nil || searchBar.text == "" {
//            inSearchMode = false
//            //collection.reloadData()
//            view.endEditing(true)
//            searchBar.resignFirstResponder()
//        } else {
//            inSearchMode = true
//            //if included in pokemon name
//            
//            
//        }
//    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func fbBtnTapped(_ sender: Any) {
        //for authenticating - 2 steps -- 1 - w provider, 2 - w firebase
        
        
        //step 1
        //checkin 2 facebook for go ahead
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                //tag to easily find error
                print("AARYN: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("AARYN: User cancelled FB Authentication")
            } else {
                print("AARYN: Successfully authenticated with Facebook")
                //credential for authenticating w firebase
                
                
                
                //does not work??
              //  let credential = FacebookAuthProvider.credential
              //  (withAccessToken: FBSDKAccessToken.current().tokenString)
                
               //  self.firebaseAuth(credential)
                
                
                //builds
                self.firebaseAuth(FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString))
            }
        
    }

}
    
    //for step 2 - auth w firebase
    func firebaseAuth(_ credential: AuthCredential){
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("AARYN: Unable to authenticate with Firebase - \(error)")
            } else {
                print("AARYN: Successfully authenticated with Firebase")
            }
            
            })
    }
    
    
    //authenticating user sign in
    @IBAction func signInBtnPressed(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            //should make popup if these are empty
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    print("AARYN: Email user authenticated with Firebase")

                } else {
                    //look at errors on firebase docs if run into problems
                    
                    //ex user does not exist
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                        print("AARYN: Unable to authenticate with Firebase using email")
                        } else {
                            print("AARYN: Successfully authenticated with Firebase")
                        }
                        
                    })
                }
            })
        
        
        }
    

    }

}

