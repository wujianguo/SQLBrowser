//
//  SQLiteBrowser.swift
//  SQLBrowser
//
//  Created by Jianguo Wu on 2018/2/27.
//  Copyright © 2018年 Jianguo Wu. All rights reserved.
//

import UIKit

struct SQLiteDatabase {
    
    init(path: String) {
        name = path
        tables = ["table1", "table2", "table3"]
    }
    
    var tables = [String]()
    
    let name: String!
    
    func numberOfRows(in table: String) -> Int {
        return 100
    }
    
    func rows(in table: String) -> [[String]] {
        return [["1", "2", "3", "4"], ["1", "2", "3", "4"], ["1", "2", "3", "4"],["1", "2", "3", "4"]]
    }
}

class SelectStatementViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
}

class TableBrowserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    class RowTableViewCell: UITableViewCell {
        static let identifier = "RowTableViewCellIdentifier"
        
        var columns: [String]! {
            didSet {
//                textLabel?.text = columns.joined(separator: ",")
                setupUIIfNeed()
            }
        }
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var labels: [UILabel]?
        func setupUIIfNeed() {
            if labels != nil {
                return
            }
            
        }
    }
    
    init(database: SQLiteDatabase, table: String) {
        self.database = database
        self.table = table
        self.data = database.rows(in: table)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = table
        setupUI()
    }
    
    let database: SQLiteDatabase!
    let table: String!
    let data: [[String]]!
    
    var tableView: UITableView!
    var scrollView: UIScrollView!
    
    func setupUI() {
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = true
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
            ])
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(RowTableViewCell.self, forCellReuseIdentifier: RowTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        scrollView.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = scrollView.bounds.size.width
        let height = scrollView.bounds.size.height
        tableView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        scrollView.contentSize = CGSize(width: width, height: height)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RowTableViewCell.identifier, for: indexPath) as! RowTableViewCell
        cell.columns = data[indexPath.row]
        return cell
    }
}

class SQLiteTableViewController: UITableViewController {
    
    init(path: String) {
        super.init(style: .grouped)
        database = SQLiteDatabase(path: path)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = database.name
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCellIdentifier")
    }
    
    var database: SQLiteDatabase!
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return database.tables.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCellIdentifier", for: indexPath)
        cell.textLabel?.text = database.tables[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TableBrowserViewController(database: database, table: database.tables[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}
