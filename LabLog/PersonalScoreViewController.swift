//
//  PersonalScoreViewController.swift
//  LabLog
//
//  Created by 大林拓実 on 2019/04/14.
//  Copyright © 2019年 TakumiObayashi. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PersonalScoreViewController: UIViewController {
    
    var databaseRef: DatabaseReference!
    
    @IBOutlet var entryButton: UIButton!
    @IBOutlet var personalScoreView: UILabel!
    @IBOutlet var currentYearMonthLabel: UILabel!
    
    var personalScore: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //現在の年月を取得・表示
        let currentYear = getCurrentYearAndMonth()["year"]!
        let currentMonth = getCurrentYearAndMonth()["month"]!
        
        currentYearMonthLabel.text = currentYear + "／" + currentMonth
        
        //DataBase(root positionを参照)インスタンス生成
        databaseRef = Database.database().reference()
        
        //呼び出し時点でのユーザーのスコアを取得・表示
        //読み取り
        databaseRef.child("year").child(currentYear)
                   .child("month").child(currentMonth)
                   .child("users").child("hereisuserid")
                   .observe(DataEventType.value, with: {(snapshot) in
                        let value = snapshot.value as? [String : AnyObject] ?? [:]
                        let fetchedUserScore = value["userscore"] as! Int
                        
                        self.personalScore = fetchedUserScore
                        self.personalScoreView.text = String(self.personalScore)
                   })
        
    }
    
    @IBAction func pushEntryButton(){
        //ローカル操作
        personalScore += 10
        personalScoreView.text = String(personalScore)
        
        //DB反映
        //現在の年月を取得
        let currentYear = getCurrentYearAndMonth()["year"]!
        let currentMonth = getCurrentYearAndMonth()["month"]!
        //書き込み
        databaseRef.child("year").child(currentYear)
                    .child("month").child(currentMonth)
                    .child("users").child("hereisuserid").child("userscore")
                    .setValue(personalScore)
    }
    
    
    func getCurrentYearAndMonth() ->Dictionary<String, String>{
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let returnDict:[String: String] = ["year": String(currentYear), "month": String(currentMonth)]
        
        return returnDict
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
