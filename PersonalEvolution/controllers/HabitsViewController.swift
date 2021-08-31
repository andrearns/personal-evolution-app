//
//  HabitsViewController.swift
//  PersonalEvolution
//
//  Created by André Arns on 30/08/21.
//
import CloudKit
import UIKit

class HabitsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var habitsTableView: UITableView!
    
    var habitsList: [String] = []
    
    private let database = CKContainer(identifier: "iCloud.PersonalEvolution").publicCloudDatabase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Explore novos hábitos"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(swipeDownToReload), for: .valueChanged)
        
        self.habitsTableView.dataSource = self
        self.habitsTableView.delegate = self
        self.habitsTableView.refreshControl = control
        
        fetchHabits()
    }
    
    @objc func fetchHabits() {
        let query = CKQuery(recordType: "Habit", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { records, error in
            guard let records = records, error == nil else { return }
            DispatchQueue.main.async {
                self.habitsList = records.compactMap({ $0.value(forKey: "Name") as? String})
                self.habitsTableView.reloadData()
                print(self.habitsList)
            }
        }
    }
    
    @objc func swipeDownToReload() {
        self.habitsTableView.refreshControl?.beginRefreshing()
        
        let query = CKQuery(recordType: "Habit", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { records, error in
            guard let records = records, error == nil else { return }
            DispatchQueue.main.async {
                self.habitsList = records.compactMap({ $0.value(forKey: "Name") as? String})
                self.habitsTableView.reloadData()
                print(self.habitsList)
                self.habitsTableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    @objc func didTapAdd() {
        let alert = UIAlertController(title: "Adicionar hábito", message: nil, preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Digite o nome do hábito..."
        }
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Salvar", style: .default, handler: { [weak self] _ in
            if let field = alert.textFields?.first, let text = field.text, !text.isEmpty {
                self?.save(habit: text)
            }
        }))
        present(alert, animated: true)
    }
    
    @objc func save(habit: String) {
        let record = CKRecord(recordType: "Habit")
        record.setValue(habit, forKey: "Name")
        
        database.save(record) { record, error in
            if record != nil, error == nil {
                print("Salvo")
                DispatchQueue.main.async {
                    self.fetchHabits()
                }
            }
        }
    }
    
    // MARK: - Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.habitsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = habitsTableView.dequeueReusableCell(withIdentifier: "habitCell") as! HabitTableViewCell
        
        let habit = habitsList[indexPath.row]
        cell.setup(habit: habit)
        
        return cell
    }
}

