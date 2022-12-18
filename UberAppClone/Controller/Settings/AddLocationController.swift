//
//  AddLocationController.swift
//  UberAppClone
//
//  Created by Wallace Santos on 13/12/22.
//

import UIKit
import MapKit

private let reuseIdentifier = "Cell"

protocol AddLocationControllerDelegate : AnyObject {
    func updateLocation(locationString: String , type : LocationType)
}

class AddLocationController :UIViewController{

//MARK: - Life Cycle
    
    init(type : LocationType, location: CLLocation){
        self.type = type
        self.location = location
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchBar()
        configureSearchCompleter()
    }
    
//MARK: - Properties
    weak var delegate:AddLocationControllerDelegate?
    
    private let type : LocationType
    private let location : CLLocation
    
    private let searchBar = UISearchBar()
    
    private let tableView = UITableView()
    
    private let searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion](){
        didSet{
            tableView.reloadData()
        }
    }
        
        
//MARK: - Helper Functions
    
    func configureTableView(){
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        //tableView.tableFooterView = UIView()
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addShadow()
        
    }
    
    func configureSearchBar(){
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    func configureSearchCompleter(){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        searchCompleter.region = region
        searchCompleter.delegate = self
        
    }
}
//MARK: - TableView Methods
extension AddLocationController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: restorationIdentifier)
        let result = searchResults[indexPath.row]
        cell.textLabel?.text = result.title
        cell.detailTextLabel?.text = result.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locationSelected = searchResults[indexPath.row]
        let location = locationSelected.title + " " + locationSelected.subtitle
        let locationString = location.replacingOccurrences(of: ", Brasil", with: "")
        delegate?.updateLocation(locationString: locationString, type: type)
    }
}

//MARK: - Search Bar Delegate Methods
extension AddLocationController: UISearchBarDelegate{
// Metodo executado a cada vez que o texto da bar muda, aplicando esse texto ao framento da busca do completer
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
}

//MARK: -  Local Search Completer
extension AddLocationController : MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }   
}
