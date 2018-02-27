//
//  TableDetailViewController.swift
//  SQLBrowser
//
//  Created by Jianguo Wu on 2018/2/10.
//  Copyright © 2018年 Jianguo Wu. All rights reserved.
//

import UIKit

class TableDetailViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        select = SQLiteDatabase.Select(columns: table.columns, offset: 0, limit: 30, where: nil, orderBy: .Asc)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
