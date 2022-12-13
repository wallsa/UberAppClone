//
//  MenuController.swift
//  UberAppClone
//
//  Created by Wallace Santos on 11/12/22.
//

import UIKit

private let reuseIdentifier = "MenuCell"

//MARK: - Delegate Protocol

protocol MenuControllerDelegate:AnyObject {
    func didSelect(option:MenuOptions)
}

//MARK: - Enums
//Case Iterable possibilita nossa enum de alguns metodos  iteraveis assim utilizamos no metodo de nossa tableview,
//CustoStringCovertible possibilita o uso da description, uma representacao textual de cada caso
enum MenuOptions:Int, CaseIterable, CustomStringConvertible {
    case yourTrips
    case settings
    case logout
    
    var description: String{
        switch self {
        case .yourTrips: return "Your Trips"
        case .settings: return "Settings"
        case .logout: return "Log Out"
        }
    }
}

//MARK: - Menu Controller

class MenuController: UIViewController {
    
//MARK: - Properties
    
    weak var delegate:MenuControllerDelegate?
    
    private let user : User
    
    private lazy var menuHeader : MenuHeader = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 80, height: 200)
        let view = MenuHeader(user: user, frame: frame)
        return view
    }()
    
    private let tableView = UITableView()
    
//MARK: - LifeCycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTableView()
    }
    
//MARK: - Selectors
    
//MARK: - Helper Functions
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableHeaderView = menuHeader
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}

extension MenuController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        guard let menuOption = MenuOptions(rawValue: indexPath.row) else {return UITableViewCell()}
        cell.textLabel?.text = menuOption.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let optionSelected = MenuOptions(rawValue: indexPath.row) else {return}
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        delegate?.didSelect(option: optionSelected)
        
    }
    
    
    
  
}
