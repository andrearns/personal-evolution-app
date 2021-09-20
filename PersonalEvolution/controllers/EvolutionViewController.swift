//
//  EvolutionViewController.swift
//  PersonalEvolution
//
//  Created by Bruno Imai on 09/09/21.
//

import UIKit
import Charts
class EvolutionViewController: UIViewController, ChartViewDelegate{
    
    @IBOutlet weak var streakContainer: UIView!
    @IBOutlet weak var weekMoodContainer: UIView!
    @IBOutlet weak var evoutionChart: LineChartView!
    
    @IBOutlet weak var streakDay1: UILabel!
    @IBOutlet weak var streakDay2: UILabel!
    @IBOutlet weak var streakDay3: UILabel!
    
    @IBOutlet weak var streakHabit1: UILabel!
    @IBOutlet weak var streakHabit2: UILabel!
    @IBOutlet weak var streakHabit3: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var dailyMoods: [DailyMood] = []
    var currentUser = User(name: "", imageData: nil, recordID: nil)
    
    var yValues: [ChartDataEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEvolutionChart()
        setWeekMood()
        setData()
        
        streakContainer.layer.cornerRadius = 15
        weekMoodContainer.layer.cornerRadius = 15
        weekMoodContainer.dropShadow()
        
        self.currentUser.name = UserSingleton.shared.name!
        self.currentUser.imageData = UserSingleton.shared.imageData!
        self.currentUser.recordID = UserSingleton.shared.recordID ?? UserSingleton.shared.fetchUserRecordID()
        print("Current user: \(self.currentUser)")
    }
    
    
    func setWeekMood(){
        let date = Date()

        for (i, dailyMood) in dailyMoods.enumerated(){
            if Calendar.current.isDate(date, equalTo: dailyMood.date!, toGranularity: .weekOfYear) && yValues.count <= 7{
                yValues.append(ChartDataEntry(x: Double(i), y: Double(dailyMood.mood!)))
            }
        }
        
        yValues = [ChartDataEntry(x: 1, y: 0),
                   ChartDataEntry(x: 2, y: 1),
                   ChartDataEntry(x: 3, y: 1),
                   ChartDataEntry(x: 4, y: 4),
                   ChartDataEntry(x: 5, y: 3),
                   ChartDataEntry(x: 6, y: 2),
                   ChartDataEntry(x: 7, y: 4)
                ]
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDailyMoods()
    }
    
    func fetchDailyMoods() {
        DispatchQueue.main.async {
            var dailyMoods: [DailyMood] = []
            CloudKitHelper.fetchDailyMoods { (result) in
                switch result {
                case .success(let newItem):
                    dailyMoods.append(newItem)
                    print(newItem)
                    print("Successfully fetched daily mood")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dailyMoods = dailyMoods.filter({ dailyMood in
                    dailyMood.userRef?.recordID == self.currentUser.recordID
                })
            }
        }
    }

    func setupEvolutionChart() {
        evoutionChart.backgroundColor = UIColor(named: "ChartColorBG")!
        evoutionChart.rightAxis.enabled = false
        
        evoutionChart.drawGridBackgroundEnabled = false
        evoutionChart.gridBackgroundColor = UIColor.orange
        evoutionChart.leftAxis.enabled = false
        evoutionChart.xAxis.enabled = false
        evoutionChart.legend.enabled = false
        evoutionChart.dragEnabled = false
        evoutionChart.scaleXEnabled = false
        evoutionChart.scaleYEnabled = false
        
        let xAxis = evoutionChart.xAxis
        xAxis.setLabelCount(5, force: true)
        
        
        
        let yAxis = evoutionChart.leftAxis
        yAxis.setLabelCount(5, force: true)
        
        evoutionChart.animate(xAxisDuration: 2)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData(){
        let set1 = LineChartDataSet(entries: yValues)
        
        set1.label?.removeAll()
        set1.mode = .cubicBezier
        set1.circleRadius = 4.0
        set1.lineWidth = 1
        set1.setColor(UIColor(named: "ChartColorLine")!)
        set1.setCircleColor(UIColor(named: "ChartColorBalls")!)
        
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        evoutionChart.data = data
        
    }
    func addStreaks(_ habits : [Habit]){
//        streakDay1.text = String(habits[0].streak)
//        streakDay2.text = String(habits[1].streak)
//        streakDay3.text = String(habits[2].streak)
        
        streakHabit1.text = habits[0].name
        streakHabit2.text = habits[1].name
        streakHabit3.text = habits[2].name
        
    }
}

extension UIView {
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

