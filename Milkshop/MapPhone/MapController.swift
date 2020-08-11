//
//  MapController.swift
//  Milkshop
//
//  Created by 劉瑄 on 2020/7/5.
//  Copyright © 2020 劉瑄. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapController:UIViewController{
    
    var location:CLLocationCoordinate2D!
    var coordinate:CLLocationCoordinate2D!
    
    
    @IBOutlet weak var map: MKMapView!
    var locationManager:CLLocationManager?
    
    //導航功能
    @IBAction func navigator(_ sender: UIButton) {
        let pA = MKPlacemark(coordinate: location, addressDictionary: nil)
        let pB = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mia = MKMapItem(placemark: pA)
        let mib = MKMapItem(placemark: pB)
        mia.name = "新莊泰泰好飲料店"
        mib.name = "現在位置"
        let routes = [mib, mia]
        let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
        MKMapItem.openMaps(with: routes, launchOptions: options)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
    }
    
    func setupSubview() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        if let coordinate = locationManager?.location?.coordinate{
            self.coordinate = coordinate  //已在外面宣告全域變數
            let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region:MKCoordinateRegion = MKCoordinateRegion(center: coordinate, span: span)
            map.setRegion(region, animated: true)
        }
        
        let latitude:CLLocationDegrees = 25.048602
        let longgitude:CLLocationDegrees = 121.447481
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longgitude)//座標
        let Xscale:CLLocationDegrees = 0.01 //數字越小地圖越大
        let Yscale:CLLocationDegrees = 0.01
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: Xscale, longitudeDelta: Yscale)//放大比例
        let region:MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        map.setRegion(region, animated: true)
        map.mapType = .standard
           
        let annotation = MKPointAnnotation()
        annotation.coordinate = location //大頭針的座標
        annotation.title = "新莊泰泰好飲料店"
        annotation.subtitle = "good drink"
        map.addAnnotation(annotation)
    }
    
    @IBAction func callout(_ sender: Any) {
        let controller = UIAlertController(title: "撥打電話給", message: "泰泰好 - 新北新莊店", preferredStyle: .actionSheet)
        let phoneNumber = "0222765634"
        let phoneAction = UIAlertAction(title: "確定", style: .default){(_) in
            if let url = URL(string: "tel:\(phoneNumber)"){
                UIApplication.shared.open(url, options: [:]) { (status) in
                    print("撥出電話")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .destructive, handler: nil)
        controller.addAction(phoneAction)
        controller.addAction(cancelAction)
        present(controller,animated: true ,completion: nil)
    }
}
