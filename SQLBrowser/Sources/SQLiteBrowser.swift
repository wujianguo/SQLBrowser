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


class GridViewCell: UIView {
    var isSelected: Bool = false
    
    var isHighlighted: Bool = false
    
    var textLabel: UILabel!
    
    func prepareForReuse() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        textLabel = UILabel()
        addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = bounds
    }
}

class GridView: UIScrollView, UITableViewDataSource, UITableViewDelegate{
    
    weak var gridViewDelegate: GridViewDelegate?
    
    weak var dataSource: GridViewDataSource?

    func dequeueReusableCell(for column: Int) -> GridViewCell {
        return GridViewCell()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    class InternalTableViewCell: UITableViewCell {
        
        static let identifier = "InternalTableViewCellIdentifier"
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var labels: [UILabel] = [UILabel]()
        var lines: [UIView] = [UIView]()
        var widths = [CGFloat]() {
            didSet {
                setupUIIfNeed()
            }
        }
        
        var texts: [String] = [String]() {
            didSet {
                if labels.count != texts.count {
                    return
                }
                for i in 0..<labels.count {
                    labels[i].text = texts[i]
                }
            }
        }

        func setupUIIfNeed() {
            if labels.count == widths.count {
                return
            }
            for label in labels {
                label.removeFromSuperview()
            }
            labels.removeAll()
            var x: CGFloat = 0
            for i in 0..<widths.count {
                let label = UILabel()
                label.frame = CGRect(x: x, y: 0, width: widths[i], height: bounds.height)
                contentView.addSubview(label)
                labels.append(label)
                
                if i > 0 {
                    let line = UIView()
                    line.frame = CGRect(x: x, y: 0, width: 1, height: bounds.height)
                    line.backgroundColor = UIColor.lightGray
                    contentView.addSubview(line)
                    lines.append(line)
                }
                
                x += widths[i]
            }
            doLayout()
        }
        
        func doLayout() {
            if labels.count != widths.count {
                return
            }
            var x: CGFloat = 0
            for i in 0..<widths.count {
                labels[i].frame = CGRect(x: x, y: 0, width: widths[i], height: bounds.height)
                if i > 0 {
                    lines[i-1].frame = CGRect(x: x, y: 0, width: 1, height: bounds.height)
                }
                x += widths[i]
            }
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            doLayout()
        }
    }
    
    func setupUI() {
        addSubview(tableView)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(InternalTableViewCell.self, forCellReuseIdentifier: InternalTableViewCell.identifier)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
//            ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = max(contentWidth, bounds.width)
        tableView.frame = CGRect(x: 0, y: 0, width: width, height: bounds.height)
        contentSize = CGSize(width: width, height: bounds.height)
    }
    
    lazy var contentWidth: CGFloat = {
        return widths.reduce(0, +)
    }()
    
    lazy var widths: [CGFloat] = {
        var w = [CGFloat]()
        let columns = dataSource?.numberOfColumns(in: self) ?? 0

        for i in 0..<columns {
            w.append(gridViewDelegate?.gridView(self, widthForColumn: i) ?? 0)
        }
        return w
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(in: self) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InternalTableViewCell.identifier, for: indexPath) as! InternalTableViewCell
        cell.widths = widths
        var texts = [String]()
        for i in 0..<widths.count {
            texts.append(dataSource?.gridView(self, textForCellAt: IndexPath(row: i, section: indexPath.row)) ?? "")
        }
        cell.texts = texts
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

protocol GridViewDataSource: NSObjectProtocol {
    
    func numberOfRows(in gridView: GridView) -> Int

    func numberOfColumns(in gridView: GridView) -> Int
    
    func gridView(_ gridView: GridView, textForCellAt indexPath: IndexPath) -> String    
}

protocol GridViewDelegate: NSObjectProtocol {
    func gridView(_ gridView: GridView, didHighlightRowAt indexPath: IndexPath)
    func gridView(_ gridView: GridView, didUnhighlightRowAt indexPath: IndexPath)
    
    func gridView(_ gridView: GridView, didSelectRowAt indexPath: IndexPath)
    func gridView(_ gridView: GridView, didDeselectRowAt indexPath: IndexPath)

    func gridView(_ gridView: GridView, heightForRowAt indexPath: IndexPath) -> CGFloat
    func gridView(_ gridView: GridView, widthForColumn column: Int) -> CGFloat
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
