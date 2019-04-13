//
//  ThisMonthVC.swift
//  CP103D_Topic0308
//
//  Created by 方錦泉 on 2019/4/13.
//  Copyright © 2019 min-chia. All rights reserved.
//

import UIKit
import Charts

class ThisMonthChartVC: UIViewController, ChartViewDelegate{
    
    @IBOutlet weak var chartView: PieChartView!
    
    //    var monthArray = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    //    var temperatureArray:[Double] = [20, 21, 22, 23, 24, 25, 26, 27, 28, 29 ,30, 31]
    var orderComplete = ["未出貨","已出貨","已退貨","已取消"]
    var orders = [Order]()
    var ordersThisMonth = [Order]()
    var ordersStatus = [Double]()
    let url_server = URL(string: common_url + "OrderServlet")
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setup(chartView: chartView)
        //圖表的設定
        chartView.delegate = self
        showAllOrder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ordersStatus.removeAll()
    }
    
    func showAllOrder(){
        let requestParam = ["action" : "getAll"]
        executeTask(url_server!, requestParam) { (data, response, error) in
            
            let decoder = JSONDecoder()
            // JSON含有日期時間，解析必須指定日期時間格式
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(format)
            let now = Date()
            let calendar = Calendar.current
            let componentSet: Set<Calendar.Component> = [.year, .month, .weekOfYear, .day, .hour, .minute, .second, .nanosecond]
            let nowComponents = calendar.dateComponents(componentSet, from: now)
            
            if error == nil {
                if data != nil {
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? decoder.decode([Order].self, from: data!) {
                        self.orders = result
                        self.ordersThisMonth = self.orders.filter { (order) -> Bool in
                            calendar.dateComponents(componentSet, from:order.date!).month == nowComponents.month
                        }
                        DispatchQueue.main.async {
                            self.getAllOrderStatus()
                            self.updateChartsData()
                        }
                        
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    func getAllOrderStatus() {
        var statusZero  = 0
        var statusOne = 0
        var statusTwo = 0
        var statusThree = 0
        for i in 0...ordersThisMonth.count-1 {
            let orderStatus = ordersThisMonth[i].status
            if orderStatus == 0 {
                statusZero += 1
            } else if orderStatus == 1{
                statusOne += 1
            } else if orderStatus == 2{
                statusTwo += 1
            } else if orderStatus == 3{
                statusThree += 1
            }
        }
        ordersStatus.append(Double(statusZero))
        ordersStatus.append(Double(statusOne))
        ordersStatus.append(Double(statusTwo))
        ordersStatus.append(Double(statusThree))
        //        print(ordersStatus)
    }
    
    
    func updateChartsData(){
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<ordersStatus.count {
            //需設定x, y座標分別需顯示什麼東西
            let dataEntry = PieChartDataEntry(value: ordersStatus[i], label: orderComplete[i])
            //最後把每次生成的dataEntry存入到dataEntries當中
            dataEntries.append(dataEntry)
        }
        
        var colors:[UIColor] = []
        
        for _ in 0..<ordersStatus.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255),alpha: 1)
            colors.append(color)
            
        }
        
        
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "訂單狀態")
        chartDataSet.colors = colors
        let charData = PieChartData(dataSet: chartDataSet)
        charData.setValueFormatter(DigitValueFormatter())
        chartView.data = charData
        
        class DigitValueFormatter: NSObject, IValueFormatter {
            func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
                let valueWithoutDecimalPart = String(format: "%.2f%%", value)
                return valueWithoutDecimalPart
            }
        }
        
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let detailAlert = UIAlertController(title: nil, message: "此類型的訂單有\(Int(highlight.y))筆", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        detailAlert.addAction(okAction)
        present(detailAlert, animated: true, completion: nil)
    }
    
    
    
    
    func setup(chartView: PieChartView) {
        chartView.usePercentValuesEnabled = true
        //百分比
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = true
        chartView.chartDescription?.text = "訂單狀態"
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        
        chartView.drawCenterTextEnabled = true
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "本月訂單\n訂單完成率")
        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 13)!,
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        
        //    let centerText = NSMutableAttributedString(string: "Charts\nby Daniel Cohen Gindi")
        //    centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 13)!,
        //    .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        //    centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
        //    .foregroundColor : UIColor.gray], range: NSRange(location: 10, length: centerText.length - 10))
        //    centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
        //    .foregroundColor : UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)], range: NSRange(location: centerText.length - 19, length: 19))
        chartView.centerAttributedText = centerText;
        //中央文字設定
        
        
        chartView.drawHoleEnabled = true
        //pieChart中間要不要有洞
        chartView.rotationAngle = 90
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        let l = chartView.legend
        //圖例
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
    }
    
    
    
    
    
    /*
     MARK: - Navigation
     
     In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     Get the new view controller using segue.destination.
     Pass the selected object to the new view controller.
     }
     */
    
}
