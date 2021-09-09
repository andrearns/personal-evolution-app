//
//  DashboardViewController.swift
//  PersonalEvolution
//
//  Created by Bruno Imai on 02/09/21.
//

import UIKit
import Foundation

class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var dashboardTableView: UITableView!
    
    @IBOutlet weak var monthCollectionView: UICollectionView!
    
    @IBOutlet weak var dayCollectionView: UICollectionView!
    
    var month = Month.FetchMonth()
    
    var days = Day.FetchDay()
    
    var habits = ["Lutar com um pombo","Malhar maromba", "Uma batatinha por dia"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                    
        let cell = dashboardTableView.dequeueReusableCell(withIdentifier: "dashboardTableViewCell", for: indexPath) as! DashboardHabitTableViewCell
            let habit = habits[indexPath.item]
            cell.habitName = habit
            cell.setup(habit: habit)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let habit = habits[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "singleHabit") as! SingleHabitViewController
        vc.habit = habit
        present(vc, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.monthCollectionView{
            return month.count
        }else {
            return days.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.monthCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCollectionViewCell", for: indexPath) as! MonthCollectionViewCell
            let month = month[indexPath.item]
            cell.month = month
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCollectionViewCell", for: indexPath) as! DayCollectionViewCell
            let day = days[indexPath.item]
            cell.day = day
            return cell
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthCollectionView.dataSource = self
        dayCollectionView.dataSource = self

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
