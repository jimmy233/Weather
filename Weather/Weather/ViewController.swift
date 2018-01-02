//
//  ViewController.swift
//  Weather
//
//  Created by jimmy233 on 2017/12/18.
//  Copyright © 2017年 NJU. All rights reserved.
//

/*151220045 蒋雨霖*/
import UIKit
import CoreLocation


class ViewController: UIViewController,CLLocationManagerDelegate,LocationSelectDelegate,UITableViewDelegate,UITableViewDataSource {
    var degree: Int!
    var condition: String!
    
    var Wind: Double!
    var Humidity:Int!
    var Cloud:Int!
    var exists: Bool = true
    var latitude:Double = 0
    var longitude:Double = 0
    
    var image:String!
    //weather
    
    var articles:[News]? = []
    //news
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var ImageWind: UIImageView!
    @IBOutlet weak var ds: UILabel!
    @IBOutlet weak var IconImage: UIImageView!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var Place: UILabel!
    let manager = CLLocationManager()
    @IBOutlet weak var temperature: UILabel!
   
    
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var cloud: UILabel!
    @IBOutlet weak var weatherDesc: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self;
        manager.desiredAccuracy=kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        let date=Date()
        let calender=Calendar.current
        
        let Year=calender.component(.year, from: date)
        let month=calender.component(.month, from: date)
        let day=calender.component(.day, from: date)
        let hour = calender.component(.hour, from: date)
        let time:String="\(Year)年\(month)月\(day)日\(hour)时"
        self.Time.text=time
        Rotate(targetView: ImageWind)
       // GetNews()
       // Getinfo(Place: self.Place.text!)
       // Wea.Getinfo(Place: self.Place.text!)
    // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func RefreshNews(_ sender: Any) {
        self.GetNews()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations[locations.count-1].coordinate.latitude)
        let location=locations[locations.count-1] as CLLocation
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                //self.Place.text="error"
                print("Reverse geocoder failed with error" + error!.localizedDescription)
            }
            
            else{
                //let pm = placemarks![0]
                self.Place.text=placemarks![0].locality
                //print(placemarks![0].locality)
                self.manager.stopUpdatingLocation()
                //self.Place.text=pm.locality
                self.Getinfo(Place: self.Place.text)
                self.GetNews()
            }
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func Getinfo(Place:String!)
    {
       
        print(Place)
        print("success get out")
        let urlPath = "http://api.apixu.com/v1/current.json?key=42840b51f2b34e2ea6c141401172512&q="+Place.replacingOccurrences(of: " ", with: "%20")
        print(urlPath)
        //urlPath.utf8
        
        
        let unsafeP=urlPath.addingPercentEncoding(withAllowedCharacters: NSCharacterSet(charactersIn:"`#%^{}\"[]|\\<> ").inverted)
        let url = URL(string:unsafeP!)
        
        print("success get in1")
        print(url as Any)
        if(url != nil)
        {
            let urlRequest = URLRequest(url: url!)
        //String: "http://api.apixu.com/v1/current.json?key=42840b51f2b34e2ea6c141401172512&q=\(Place.replacingOccurrences(of: " ", with: "%20"))"))
        print("success get in2")
        
        let task=URLSession.shared.dataTask(with: urlRequest){(data,response,error) in
            if error==nil
            {
                
                do
                {
                    
                    let json=try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                    if let current = json["current"] as? [String:AnyObject]{
                        if let temp = current["temp_c"] as? Int{
                            self.degree=temp
                        }
                        if let windtemp=current["wind_kph"] as? Double{
                            self.Wind=windtemp
                        }
                        if let htemp=current["humidity"] as? Int{
                            self.Humidity=htemp
                        }
                        if let ctemp=current["cloud"] as? Int{
                            self.Cloud=ctemp
                        }
                        if let condition=current["condition"] as? [String:AnyObject]
                        {
                            let icon=condition["icon"] as!String
                            self.condition=condition["text"] as! String
                            self.image="http:\(icon)"
                        }
                        
                    }
                    if let location = json["location"] as? [String:AnyObject]
                    {
                        if let lattemp = location["lat"] as? Double{
                            self.latitude=lattemp
                        }
                        if let longitemp = location["lon"] as? Double{
                            self.longitude=longitemp
                        }
                    }
                    
                    if let _ = json["error"] {
                        self.exists = false
                    }
                    DispatchQueue.main.async {
                        
                        if self.exists{
                            self.temperature.isHidden = false
                            self.weatherDesc.isHidden = false
                            self.wind.isHidden=false
                            self.humidity.isHidden=false
                            self.cloud.isHidden=false
                           
                            self.temperature.text="\(self.degree.description)℃"

                            self.weatherDesc.text=self.condition

                            self.wind.text="\(self.Wind.description)km/h"

                            self.humidity.text="\(self.Humidity.description)%"

                            self.cloud.text="\(self.Cloud.description)%"
                            self.IconImage.downloadIconImage(from: self.image!)

                        }else {
                            self.Place.text = "No matching"
                            self.exists = true
                            
                        }
                    }
                }
                catch let jsonError
                {
                    print(jsonError.localizedDescription)
                }
            }
        }
        task.resume()
        
    }
    }

    func Rotate(targetView:UIView,duration:Double = 1.0)
    {
        UIView.animate(withDuration: duration,delay: 0.0,options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(M_PI))
        }) { finished in
            self.Rotate(targetView: targetView, duration: duration)
        }
    }
    //Refresh
    
    @IBAction func RefreshWeather(_ sender: Any) {
        self.manager.startUpdatingLocation()
        let date=Date()
        let calender=Calendar.current
        
        let Year=calender.component(.year, from: date)
        let month=calender.component(.month, from: date)
        let day=calender.component(.day, from: date)
        let hour = calender.component(.hour, from: date)
        let time:String="\(Year)年\(month)月\(day)日\(hour)时"
        self.Time.text=time
    }
    //citylist
    @IBAction func SelectLocation(_ sender: Any) {
        let locationSelector = LocationSelect()
        locationSelector.delegate = self;
        self.navigationController?.pushViewController(locationSelector, animated: true)
    }
    func locationSelected(location: String) {
        var locationcn:String!
        if(location.isIncludeChinese())
        {
          locationcn=location.transformToPinyinWithoutBlank()
        }
       
        self.Place.text=location
        self.temperature.text=""
        self.wind.text=""
        self.cloud.text=""
        self.humidity.text=""
        self.Getinfo(Place: locationcn)
        self.navigationController?.popToViewController(self, animated: true)
    }
    
  //news
    func GetNews()
    {
        let urlPath:String = "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=a9f0a73febcc4703a7bbe627dbeccdfc"
        //bbc news
        let urlRequest=URLRequest(url:URL(string:urlPath)!)
        print("succeess in news")
        print(urlRequest)
        let task=URLSession.shared.dataTask(with: urlRequest){ (data,response,error) in
            if error==nil
            {
                print("success get news")
                self.articles = [News]()
                do
                {
                    let json=try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                     if let articles = json["articles"] as? [[String:AnyObject]]{
                        
                        for singlearticle in articles
                        {
                            let apieceofnews = News()
                            if let title = singlearticle["title"] as? String
                            {
                                apieceofnews.titleline=title
                            }
                            if let desc = singlearticle["description"] as? String
                            {
                                apieceofnews.textline=desc
                            }
                            if let url = singlearticle["url"] as? String
                            {
                                apieceofnews.url=url
                            }
                            if let urlToImage = singlearticle["urlToImage"] as? String
                            {
                                apieceofnews.imageUrl=urlToImage
                            }
                            self.articles?.append(apieceofnews)
                            
                        }
                    }
                    DispatchQueue.main.async {
                       self.tableView.reloadData()
                    }
                }
                catch let jsonError{
                    print(jsonError.localizedDescription)
                }
               
                
        }
            else
            {
                print("can't get news")
                print(error ?? 0)
                print("错误")
                return
            }
    }
         task.resume()
}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath)->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
       
        cell.Title.text = self.articles?[indexPath.item].titleline!
        cell.Desc.text=self.articles?[indexPath.item].textline!
       // cell.imageView?.contentMode=UIViewContentMode.center
        //cell.imageView?.clipsToBounds = true
        //cell.imageView?.contentMode=UIViewContentMode.scaleAspectFill
        
      //  if(self.articles?[indexPath.item].imageUrl != nil){
        //    cell.imageView?.downloadIconImage(from: (self.articles?[indexPath.item].imageUrl!)!)}
        
        return cell
    }
    func numofSections(in tableView:UITableView)->Int
    {
        return 1
    }
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int)->Int
    {
        return self.articles?.count ?? 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webshow = UIStoryboard.init(name:"Main",bundle: nil).instantiateViewController(withIdentifier: "web") as! WebViewController
        webshow.url = self.articles?[indexPath.item].url
        self.present(webshow, animated: true, completion: nil)
    }
    
}

extension UIImageView
{
    func downloadIconImage(from url:String)
    {
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
            else
            {
                print(error?.localizedDescription ?? 0)
                return
            }
        }
        task.resume()
    
    }
    //news

}
extension String {
    func isIncludeChinese() -> Bool {
        for ch in self.unicodeScalars {
            // 中文字符范围：0x4e00 ~ 0x9fff
            if (0x4e00 < ch.value  && ch.value < 0x9fff) {
                return true
            }
        }
        return false
    }
    func transformToPinyin() -> String {
        let stringRef = NSMutableString(string: self) as CFMutableString
 
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false)
       
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false)
        let pinyin = stringRef as String
        print(pinyin)
        return pinyin
    }
    func transformToPinyinWithoutBlank() -> String {
        var pinyin = self.transformToPinyin()
        pinyin = pinyin.replacingOccurrences(of: " ", with: "")
        return pinyin
    }
    
    
}


