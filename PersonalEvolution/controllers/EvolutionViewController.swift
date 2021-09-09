//
//  EvolutionViewController.swift
//  PersonalEvolution
//
//  Created by Bruno Imai on 09/09/21.
//

import UIKit
import Charts
class EvolutionViewController: UIViewController, ChartViewDelegate{

    @IBOutlet weak var evoutionChart: LineChartView!
    
    let yValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 0.0),
        ChartDataEntry(x: 1.0, y: 1.0),
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
        
        // Do any additional setup after loading the view.
    }
    

    func setupEvolutionChart() {
        evoutionChart.backgroundColor = UIColor(named: "ChartColorBG")!
        evoutionChart.rightAxis.enabled = false
        
        evoutionChart.drawGridBackgroundEnabled = false
        
        let xAxis = evoutionChart.xAxis
        xAxis.labelFont = .boldSystemFont(ofSize: 12)
        xAxis.setLabelCount(5, force: true)
        xAxis.labelTextColor = .white
        xAxis.axisLineColor = .white
        xAxis.labelPosition = .bottom
        
        
        let yAxis = evoutionChart.leftAxis
        yAxis.setLabelCount(5, force: true)
        yAxis.axisMinimum = 0
        
        evoutionChart.animate(xAxisDuration: 2)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData(){
        let set1 = LineChartDataSet(entries: yValues, label: "Suas Emoções")
        
        set1.drawFilledEnabled = true
        set1.fill = Fill(color: UIColor(named: "ChartColor")!)
        set1.fillAlpha = 0.8
        set1.mode = .cubicBezier
        set1.circleRadius = 4.0
        set1.lineWidth = 3
        set1.setColor(UIColor(named: "ChartColor")!)
        
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        evoutionChart.data = data
    }

}
