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
    
    
    
    let yValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 0.0),
        ChartDataEntry(x: 1.0, y: 4.0),
        ChartDataEntry(x: 2.0, y: 3.0),
        ChartDataEntry(x: 3.0, y: 2.0),
        ChartDataEntry(x: 4.0, y: 4.0),
        ChartDataEntry(x: 5.0, y: 4.0),
        ChartDataEntry(x: 6.0, y: 1.0)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEvolutionChart()
        setData()
        
        streakContainer.layer.cornerRadius = 15
        weekMoodContainer.layer.cornerRadius = 15
        weekMoodContainer.dropShadow()
        
        // Do any additional setup after loading the view.
    }
    
    
    

    func setupEvolutionChart() {
        evoutionChart.backgroundColor = UIColor(named: "ChartColorBG")!
        evoutionChart.rightAxis.enabled = false
        
        evoutionChart.drawGridBackgroundEnabled = false
        evoutionChart.gridBackgroundColor = UIColor.orange
        evoutionChart.leftAxis.enabled = false
        evoutionChart.xAxis.enabled = false
        
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

