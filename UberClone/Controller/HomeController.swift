//
//  HomeController.swift
//  UberClone
//
//  Created by Kerim Civelek on 4.11.2023.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class HomeController: UIViewController {

    //MARK: - Properties

    private let mapView = MKMapView()
    
    private let locationManager = CLLocationManager()
    
    private let inputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    
    
    //MARK: - Lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        enableLocationServices()
//        singOut()
    }
  
    //MARK: - API
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
            print("Debug: User is not logged in....")
        } else {
            configureUI() // Kullanıcı oturum açmışsa configureUI fonksiyonunu çağırın
            print("Debug: User is logged in....")
            print("Debug: User is logged in....\(Auth.auth().currentUser?.uid ?? "")")
        }
    }


    func singOut(){
        do{
            try Auth.auth().signOut()
        } catch{
            print("Debug: Error signing out... ")
        }
    }
    
    
    //MARK: - Helper Functions
    
    
    func configureUI(){
        configureMapView()
        
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimensions(height: 50, width: view.frame.width - 64)
        inputActivationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
        inputActivationView.alpha = 0
        inputActivationView.delegate = self
        
        UIView.animate(withDuration: 2) {
            self.inputActivationView.alpha = 1
        }
    }
    
    func configureMapView(){
        view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    
    func configureLocationInputView(){
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 200)
        locationInputView.alpha = 0
        locationInputView.delegate = self
        
        UIView.animate(withDuration: 0.5) {
            self.locationInputView.alpha = 1
        } completion: { _ in
            print("asdaf")
        }

    }

}

//MARK: - Location Services

extension HomeController: CLLocationManagerDelegate{
    
    func enableLocationServices(){
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus(){
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            print("Debug: Not determined...")
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("Debug: Auth always...")
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("Debug: Auth when in use...")
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.requestAlwaysAuthorization()
        }
    }
    
}


//MARK: - LocationInputActivationViewDelegate

extension HomeController: LocationInputActivationViewDelegate{
    func presentLocationInputView() {
        inputActivationView.alpha = 0
      configureLocationInputView()
    }
}



//MARK: - LocationInputViewDelegate

extension HomeController: LocationInputViewDelegate{
    func dissmisLocationInputView() {
        print("123125")
    }
    
    
}
