//
//  ViewController.swift
//  SQLBrowser
//
//  Created by Jianguo Wu on 2017/10/5.
//  Copyright © 2017年 Jianguo Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GridViewDataSource, GridViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(rightBarButtonItemClick(sender:)))
        
        let gridView = GridView(frame: .zero)
        gridView.gridViewDelegate = self
        gridView.dataSource = self
        view.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gridView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            gridView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            gridView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])

 /*
        let testView = UIView()
        testView.backgroundColor = UIColor.red
        testView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(testView)
        NSLayoutConstraint.activate([
            testView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            testView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            testView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            testView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
*/
    }
    
    @objc func rightBarButtonItemClick(sender: UIBarButtonItem) {
        let vc = SQLiteTableViewController(path: "sqlite_name")
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }

    func numberOfRows(in gridView: GridView) -> Int {
        return 100
    }
    
    func numberOfColumns(in gridView: GridView) -> Int {
        return 20
    }
    
    func gridView(_ gridView: GridView, textForCellAt indexPath: IndexPath) -> String {
        return "\(indexPath.section),\(indexPath.row)"
    }
    
    func gridView(_ gridView: GridView, widthForColumn column: Int) -> CGFloat {
        return 100
    }
    
    func gridView(_ gridView: GridView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func gridView(_ gridView: GridView, didHighlightRowAt indexPath: IndexPath) {
        
    }
    
    func gridView(_ gridView: GridView, didUnhighlightRowAt indexPath: IndexPath) {
        
    }
    
    func gridView(_ gridView: GridView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func gridView(_ gridView: GridView, didDeselectRowAt indexPath: IndexPath) {
        
    }
}

