//
//  TopViewController.swift
//  LabLog
//
//  Created by 川岸樹奈 on 2019/04/16.
//  Copyright © 2019年 TakumiObayashi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class TopViewController: UIViewController {
    
    @IBOutlet var usrIcon: UIImageView!
    @IBOutlet var usrId: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        
        if user != nil {
            if let user = user {
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
                let uid = user.uid
                let email = user.email
                let photoURL = user.photoURL
                
                do {
                    let data = try Data(contentsOf: photoURL!)
                    usrIcon.image = UIImage(data: data)
                }catch let err {
                    print("Error : \(err.localizedDescription)")
                }
                usrId.text = uid
                print(uid, email, photoURL)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }

    }
    
}

extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
