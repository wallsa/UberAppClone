//
//  ContainerController.swift
//  UberAppClone
//
//  Created by Wallace Santos on 11/12/22.
//

import UIKit
import Firebase

class ContainerController: UIViewController {
    
//MARK: - Properties
    
    private let homeController = HomeController()
    private var menuController : MenuController!
    private var isExpanded = false
    private lazy var xOrigin = self.view.frame.width - 80
    
    private let blackView = UIView()
    
    private var user:User?{
        didSet{
            guard let user = user else {return}
            homeController.user = user
            
            configureMenuController(withUser: user)
        }
    }
    
//MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkifUserIsLoggedIn()
    }
    
    override var prefersStatusBarHidden: Bool{
        return isExpanded
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .fade
    }
 
//MARK: - API
    
    func checkifUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }else{
            configure()
        }
    }
    
    func fetchUserData(){
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        Service.shared.fetchUserData(uid: currentUID) { user in
            self.user = user
        }
    }
    
    func signOut(){
        do {
            try Auth.auth().signOut()
            presentLoginController()
        } catch {
            print("DEBUG: Error signing out ")
        }
    }
//MARK: - Selectors
    
    @objc func dismissMenu(){
        isExpanded = false
        animateMenu(shouldExpand: isExpanded)
        
    }
    
//MARK: - Helper Functions
    
    func configure(){
        configureHomeController()
        fetchUserData()

    }
    
    func configureBlackView(){
        blackView.frame = CGRect(x: xOrigin, y: 0, width: 80, height: self.view.frame.height)
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.alpha = 0
        
        view.addSubview(blackView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        blackView.addGestureRecognizer(tap)
    }
    
    func configureHomeController(){
        addChild(homeController)
        homeController.delegate = self
        homeController.didMove(toParent: self)
        view.addSubview(homeController.view)
    }
    
    func configureMenuController(withUser user:User){
        menuController = MenuController(user: user)
        menuController.delegate = self
        addChild(menuController)
        menuController.didMove(toParent: self)
        view.insertSubview(menuController.view, at: 0)
        configureBlackView()
    }
    
    func animateMenu(shouldExpand:Bool, completion: ((Bool) -> ())? = nil){
        
        if shouldExpand{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homeController.view.frame.origin.x = self.xOrigin
                self.blackView.alpha = 1
            }, completion: nil)
        }else{
            self.blackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.homeController.view.frame.origin.x = 0
            }, completion: completion)
        }
        animateStatusBar()
    }
    
    func animateStatusBar(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: LoginController())
            if #available(iOS 13.0, *) {
                nav.isModalInPresentation = true
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
}

//MARK: - HomeController Delegate
extension ContainerController : HomeControllerDelegate{
    
    
    func handleMenuToggle() {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
    } 
}

//MARK: - MenuController Delegate

extension ContainerController: MenuControllerDelegate{
  
    
    func didSelect(option: MenuOptions) {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded) { _ in
            switch option {
            case .yourTrips:
                break
            case .settings:
                guard let user = self.user else {return}
                let controller = SettingsController(user: user)
                let navController = UINavigationController(rootViewController: controller)
                navController.isModalInPresentation = true
                navController.modalTransitionStyle = .crossDissolve
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true)
            case .logout:
                let alert = UIAlertController().createLogoutAlert { _ in
                    self.signOut()
                }
                self.present(alert, animated: true)
            }
        }
    }
    
    
}
