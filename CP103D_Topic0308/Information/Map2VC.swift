//
//  MapVC.swift
//  CP103D_Topic0308
//
//  Created by 吳佳臻 on 2019/3/25.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit
import MapKit

class Map2VC: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var spotList: [Spot]!
    var annotationList: [MKAnnotation]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        spotList = getSpotList()
        annotationList = getAnnotationList(spotList: spotList)
        setMapRegion()
        mapView.addAnnotations(annotationList)
        mapView.showsUserLocation = true
    }
    
    func setMapRegion() {
        let span = MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3)
        let region = MKCoordinateRegion(center: (annotationList.last!.coordinate), span: span)
        mapView.setRegion(region, animated: true)
        mapView.regionThatFits(region)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        /* 指定identifier以重複利用annotation view */
        let identifier = "annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView?.canShowCallout = true
        annotationView?.image = UIImage(named: "pin")
        /* 預設圖示中心點會在地點上，應改成圖示底部對齊地點，負值代表向上移動 */
        let height = annotationView?.frame.height
        annotationView?.centerOffset = CGPoint(x: 0, y: -(height!) / 2)
        
        let detailButton = UIButton(type: .detailDisclosure)
        //== 比值 === 比位置，
        for i in 0...annotationList.count {
            if annotationList[i] === annotation {
                /* 透過tag儲存annotation在array的index */
                detailButton.tag = i
                break
            }
        }
        /* 設定disclosure按鈕與事件處理 */
        detailButton.addTarget(self, action: #selector(clickDetail(_:)), for: .touchUpInside)
        //對話匡+上資訊的按鈕
        annotationView!.rightCalloutAccessoryView = detailButton
        
        return annotationView
    }
    
    //instantiateViewController 連接到下一頁
    @objc func clickDetail(_ button: UIButton) {
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        let index = button.tag
        let spot = spotList[index]
        detailVC.spot = spot
        /* storyboard加上UINavigationController */
        navigationController!.pushViewController(detailVC, animated: true)
    }
    
    func getSpotList() -> [Spot]{
        var spotList = [Spot]()
        let shulin = Spot(image: UIImage(named: "京站")!, name: "台北京站時尚廣場店", address: "10351 台北市大同區承德路一段一號B1京站時尚廣場B1 Q小路", time: "週日～週四、例假日 11:00〜21:30" , latitude: 25.049025, longitude: 121.518407)
        
        spotList.append(shulin)
        return spotList
    }
    
    func getAnnotationList(spotList: [Spot]) -> [MKAnnotation] {
        var annotationList = [MKAnnotation]()
        for spot in spotList {
            let annotation = MKPointAnnotation()
            annotation.title = spot.name
            annotation.subtitle = spot.address
            annotation.coordinate.latitude = spot.latitude
            annotation.coordinate.longitude = spot.longitude
            annotationList.append(annotation)
        }
        return annotationList
    }
    
    
    
}
