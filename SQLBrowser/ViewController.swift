//
//  ViewController.swift
//  SQLBrowser
//
//  Created by Jianguo Wu on 2017/10/5.
//  Copyright © 2017年 Jianguo Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(rightBarButtonItemClick(sender:)))
    }
    
    @objc func rightBarButtonItemClick(sender: UIBarButtonItem) {
        let vc = SQLiteTableViewController(path: "sqlite_name")
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

