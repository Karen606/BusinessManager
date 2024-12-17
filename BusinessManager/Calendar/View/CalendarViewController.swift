//
//  CalendarViewController.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 17.12.24.
//

import UIKit
import FSCalendar
import Combine

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet var filterButtons: [FilterButton]!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tasksTableView: UITableView!
    private let viewModel = CalendarViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.scope = .week
        calendarView.backgroundColor = .clear
        filterButtons.first?.isSelected = true
        tasksTableView.register(UINib(nibName: "TaskDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskDetailsTableViewCell")
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        subscribe()
        viewModel.fetchData()
        calendarView.delegate = self
    }
    
    func subscribe() {
        viewModel.$tasks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.tasksTableView.reloadData()
            }
            .store(in: &cancellables)
    }

    @IBAction func chooseFilter(_ sender: FilterButton) {
        filterButtons.forEach({ $0.isSelected = false })
        sender.isSelected = true
        viewModel.choosePriority(index: sender.tag)
    }
    
    @IBAction func clickedAddTask(_ sender: UIButton) {
    }
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        viewModel.chooseDate(by: date)
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskDetailsTableViewCell", for: indexPath) as! TaskDetailsTableViewCell
        cell.configure(task: viewModel.tasks[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        8
    }
}
