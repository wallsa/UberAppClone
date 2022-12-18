//
//  SettingsController.swift
//  UberAppClone
//
//  Created by Wallace Santos on 12/12/22.
//

import UIKit

private let reuseIdentifier = "LocationCell"

//MARK: - SettingsController Delegate

protocol SettingsControllerDelegate: AnyObject{
    func updateUser(_ controller:SettingsController)
}

//MARK: - Configuration Enums
enum LocationType: Int, CaseIterable, CustomStringConvertible {
    case home
    case work
    
    var description: String{
        switch self {
        case .home: return "Home"
        case .work: return "Work"
        }
    }
    
    var subtitle: String{
        switch self {
        case .home: return "Add Home"
        case .work: return "Add Work"
        }
    }
}

class SettingsController:UITableViewController {
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
    }
    
    init(user:User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    
    weak var delegate:SettingsControllerDelegate?
    
    var user:User
    
    private let locationManager = LocationHandler.shared.locationManager
    
    private lazy var userInfoHeader : UserInfoHeader = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        let view = UserInfoHeader(user: user, frame: frame)
        return view
    }()
    
    
    //MARK: - Selectors
    
    @objc func handleDismissSettings(){
        self.dismiss(animated: true)
    }
    
    //MARK: - Helper Functions
    
    func locationText(forType type: LocationType) -> String{
        switch type {
        case .home : return user.homeLocation ?? type.subtitle
        case .work : return user.workLocation ?? type.subtitle
        }
    }
        
        func configureTableView(){
            tableView.rowHeight = 60
            tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)
            tableView.backgroundColor = .white
            tableView.tableHeaderView = userInfoHeader
            tableView.sectionHeaderTopPadding = 0
            tableView.isScrollEnabled = false
        }
        
        func configureNavigationBar(){
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barStyle = .black
            navigationItem.title = "Settings"
            navigationController?.navigationBar.barTintColor = .black
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(imageLiteralResourceName: Images.cancelX).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismissSettings))
        }
    
}
    //MARK: - TableView Delegate and DataSource
    extension SettingsController {
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return LocationType.allCases.count
        }
        
        override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let view = UIView()
            view.backgroundColor = .black
            
            let label = UILabel()
            label.textColor = .white
            label.text = "Favorites"
            label.font = UIFont.systemFont(ofSize: 16)
            
            view.addSubview(label)
            label.centerY(inview: view, leftAnchor: view.leftAnchor, paddinLeft: 12)
            
            return view
        }
        
        override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 30
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
            guard let type = LocationType(rawValue: indexPath.row) else {return cell}
            cell.localNameLabel.text = type.subtitle
            cell.adressNameLabel.text = locationText(forType: type)
            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let type = LocationType(rawValue: indexPath.row) else {return}
            guard let location = locationManager?.location else {return}
            let controller = AddLocationController(type: type, location: location)
            controller.delegate = self
            let navController = UINavigationController(rootViewController: controller)
            present(navController, animated: true)
        }
    }
    
    //MARK: - AddLocationControllerDelegate
    
    extension SettingsController : AddLocationControllerDelegate {
        func updateLocation(locationString: String, type: LocationType) {
            PassengerService.shared.saveLocation(locationString: locationString, type: type) { [self] _ , _ in
                self.dismiss(animated: true)
                switch type {
                case .home:
                    self.user.homeLocation = locationString
                case .work:
                    self.user.workLocation = locationString
                }
                self.tableView.reloadData()
                self.delegate?.updateUser(self)
            }
        }
    }

