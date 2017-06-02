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

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func fbBtnTapped(_ sender: Any) {
        //for authenticating - 2 steps -- 1 - w provider, 2 - w firebase
        
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

}

