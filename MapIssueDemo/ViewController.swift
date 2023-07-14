//
//  ViewController.swift
//  MapIssueDemo
//
//  Created by linxiaohai on 2023/7/14.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var bizUsers:[BizUser] = []
    
    lazy var addButton:UIButton = {
        let addButton = UIButton.init(frame: .zero)
        addButton.setTitle("重新添加地图元素", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.backgroundColor = .white
        addButton.addTarget(self, action: #selector(handleClick), for: .touchUpInside)
        return addButton
    }()
    
    lazy var mapView:MKMapView = {
        let mapView = MKMapView.init()
        if #available(iOS 16.0, *) {
            mapView.preferredConfiguration = MKStandardMapConfiguration.init(elevationStyle: MKMapConfiguration.ElevationStyle.flat, emphasisStyle: MKStandardMapConfiguration.EmphasisStyle.default)
        } else {
            // Fallback on earlier versions
        }
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
        mapView.delegate = self
        mapView.register(OnlineUserMarkAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mapView)
        self.mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.mapView.addSubview(addButton)
        
        addButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-100)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 64))
        }
        
        self.showAnimations()
        
        self.mapView.centerToLocation(CLLocation(latitude: 23.12916565, longitude: 113.36641303))
    }
    
    @objc func handleClick() {
        self.showAnimations()
    }
    
    func showAnimations() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        let user1 = BizUser.init()
        bizUsers.removeAll()
        user1.avatar = "https://cvws.icloud-content.com/B/AUZBN9Ehl-IIo5GWuHzrTpc0clEX/$%7Bf%7D?o=Ak79sUxUWMeqxg-6COwCccsmYL7p0lgYk4syNuneRrtB93QrxVKzWQNU69vlGiLy6w&v=1&x=3&a=CAog-AYaHYNJ3L7FzL5-Zhb_To_Fxjm1rPYqPKdl3eIjV8EShwEQqemhk5UxGKnG_ZSVMSIBAFIENHJRF2o2jQlYpiFmxeiGwYYyzlNN4t9ZaTzvcW7XKOMS-0ECXnEPPrOmRq8bIZr4kKRkavrNHngUISo4cjZZfnHTOYTcIpJgp5CSqECTDb_zcD8HNmfRLmkMJWZ6YrCpNNsmMyWA6qgfSgTuRFoJP68HSKQ&e=1689308324&fl=&r=73b2b0da-9da1-4d91-aebe-1b47b3a30d54-1&k=_&ckc=iCloud.com.idealists.yoki&ckz=_defaultZone&p=29&s=0WLtZtIfzRohLOVWTFb4JjNDcS0"
        user1.location = CLLocation(latitude: 23.129201808779964, longitude: 113.366408090433)
        bizUsers.append(user1)
        
        let user2 = BizUser.init()
        user2.avatar = "https://cvws.icloud-content.com/B/AS7Avu4c78csrOSFUcOE-f6Kmyms/$%7Bf%7D?o=AgcUEe9YBlPIduFsUJ0lYN3n-Fo6eOuOvgX_hTCqrjVyhrh2T77hsYAazHBinMKr3Q&v=1&x=3&a=CAogCLoy6bdHvnq2BGsON4nGJX6sG6SfsE4zXjWoh0A1u9IShwEQu-mhk5UxGLvG_ZSVMSIBAFIEipsprGo2wz52ePNwZ6cX_XMwXelWTYY61eu3q07TmCgykHO5KtNGtlRoUruzUXq4kqH49yNqzOxpL3WkcjYfDmF3aOWhNg25-RfE1ZUTX2wqoiczB1fbje0zKTr2wrY7Nb76QN1KZkJumCPCFdaYT4fTsNc&e=1689308324&fl=&r=73b2b0da-9da1-4d91-aebe-1b47b3a30d54-1&k=_&ckc=iCloud.com.idealists.yoki&ckz=_defaultZone&p=29&s=u6TZ1bCQNkuNg8GizEm1RcMcM60"
        user2.location = CLLocation(latitude: 22.309684733629663, longitude: 114.171374068157)
        
        bizUsers.append(user2)
        
        self.mapView.addAnnotations(bizUsers)
    }
}


extension ViewController:MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if annotation is MKClusterAnnotation {
            
            let annotaionView = mapView.annotationView(of: MKMarkerAnnotationView.self,
                                               annotation: annotation,
                                          reuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
            annotaionView.zPriority = .max
            return annotaionView
        }
        
        let annotaionView = mapView.annotationView(of: OnlineUserMarkAnnotationView.self,
                                           annotation: annotation,
                                      reuseIdentifier: NSStringFromClass(OnlineUserMarkAnnotationView.self))
        annotaionView.clusteringIdentifier = MKMapViewDefaultClusterAnnotationViewReuseIdentifier
        annotaionView.zPriority = .max
        return annotaionView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let markView = view as? MKMarkerAnnotationView, let annotation = markView.annotation as? MKClusterAnnotation {
            self.mapView.showAnnotations(annotation.memberAnnotations, animated: true)
            return
        }
        
        guard let markView = (view as? OnlineUserMarkAnnotationView) else { return }
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1
        animation.toValue = 1.5
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = 0.1
        animation.timingFunction = .init(name: .easeIn)
        markView.layer.add(animation, forKey: nil)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        guard let markView = (view as? OnlineUserMarkAnnotationView) else { return }
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1
        animation.fromValue = 1.5
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.duration = 0.1
        animation.timingFunction = .init(name: .easeOut)
        markView.layer.add(animation, forKey: nil)
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
//        views.forEach { $0.alpha = 0 }
//        UIView.animate(withDuration: 0.15, delay: 0) {
//            views.forEach { $0.alpha = 1 }
//        }
    }
}

extension MKMapView {
    
    func annotationView<T: MKAnnotationView>(of type: T.Type, annotation: MKAnnotation?, reuseIdentifier: String) -> T {
        guard let annotationView = dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? T else {
            return type.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        }
        annotationView.annotation = annotation
        return annotationView
    }
    
    func centerToLocation(_ location:CLLocation,regionRadius:CLLocationDistance = 10000,animated:Bool = true) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                       latitudinalMeters: regionRadius,
                                      longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: animated)
    }
}


