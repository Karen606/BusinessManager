//
//  TaskFormViewController.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 17.12.24.
//

import UIKit
import DropDown
import Combine
import UniformTypeIdentifiers

class TaskFormViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var descriptionTextView: PaddingTextView!
    @IBOutlet weak var startDateTextField: BaseTextField!
    @IBOutlet weak var endDateTextField: BaseTextField!
    @IBOutlet weak var startTimeTextField: BaseTextField!
    @IBOutlet weak var endTimeTextField: BaseTextField!
    @IBOutlet weak var priorityButton: UIButton!
    @IBOutlet weak var personsTableView: UITableView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var addPersonButton: UIButton!
    @IBOutlet weak var uploadFileButton: UIButton!
    @IBOutlet weak var createButton: BaseButton!
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var dropDownImageView: UIImageView!
    private let dropDown = DropDown()
    var completion: (() -> ())?
    private let viewModel = TaskFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let startTimePicker = UIDatePicker()
    private let endTimePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
        setupUI()
        subscribe()
    }
    
    override func viewDidLayoutSubviews() {
        self.dropDown.width = priorityButton.bounds.width
        self.dropDown.bottomOffset = CGPoint(x: self.priorityButton.frame.minX, y: self.priorityButton.frame.maxY + 2)
    }
    
    func setupUI() {
        setNavigationTitle(title: "Adding a task")
        setNaviagtionCancelButton()
        titleLabels.forEach({ $0.font = .regular(size: 16) })
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 6
        descriptionTextView.font = .regular(size: 14)
        descriptionTextView.delegate = self
        nameTextField.delegate = self
        endDateTextField.setupRightViewIcon(.calendar, size: CGSize(width: 40, height: 40))
        startDateTextField.setupRightViewIcon(.calendar, size: CGSize(width: 40, height: 40))
        startTimeTextField.setupRightViewIcon(.time, size: CGSize(width: 40, height: 40))
        endTimeTextField.setupRightViewIcon(.time, size: CGSize(width: 40, height: 40))
        personsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        priorityButton.layer.borderColor = UIColor.black.cgColor
        priorityButton.layer.borderWidth = 1
        priorityButton.layer.cornerRadius = 6
        priorityButton.titleLabel?.font = .regular(size: 14)
        
        addPersonButton.titleLabel?.font = .regular(size: 16)
        uploadFileButton.titleLabel?.font = .regular(size: 16)

        let data: [String] = Priority.allCases.map { $0.rawValue }
        dropDown.backgroundColor = .white
        dropDown.setupCornerRadius(8)
        dropDown.dataSource = data
        dropDown.anchorView = priorityView
        dropDown.direction = .bottom
        DropDown.appearance().textColor = .black
        DropDown.appearance().textFont = .regular(size: 15) ?? .boldSystemFont(ofSize: 18)
        DropDown.appearance().selectionBackgroundColor = .clear
        dropDown.addShadow()
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.viewModel.task.priority = index
            self.priorityButton.setTitle(Priority.allCases[index].rawValue, for: .normal)
            self.dropDownImageView.isHighlighted = false
        }
        
        dropDown.cancelAction = { [weak self] in
            guard let self = self else { return }
            self.dropDownImageView.isHighlighted = false
        }
        
        startDatePicker.locale = NSLocale.current
        startDatePicker.datePickerMode = .date
        startDatePicker.preferredDatePickerStyle = .inline
        startDatePicker.addTarget(self, action: #selector(startDatePickerValueChanged), for: .valueChanged)
        startDateTextField.inputView = startDatePicker
        
        endDatePicker.locale = NSLocale.current
        endDatePicker.datePickerMode = .date
        endDatePicker.preferredDatePickerStyle = .inline
        endDatePicker.addTarget(self, action: #selector(endDatePickerValueChanged), for: .valueChanged)
        endDateTextField.inputView = endDatePicker
        
        startTimePicker.locale = NSLocale.current
        startTimePicker.datePickerMode = .time
        startTimePicker.preferredDatePickerStyle = .wheels
        startTimePicker.addTarget(self, action: #selector(startTimePickerValueChanged), for: .valueChanged)
        startTimeTextField.inputView = startTimePicker
        
        endTimePicker.locale = NSLocale.current
        endTimePicker.datePickerMode = .time
        endTimePicker.preferredDatePickerStyle = .wheels
        endTimePicker.addTarget(self, action: #selector(endTimePickerValueChanged), for: .valueChanged)
        endTimeTextField.inputView = endTimePicker
        
        personsTableView.register(UINib(nibName: "PersonFormTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonFormTableViewCell")
        personsTableView.delegate = self
        personsTableView.dataSource = self
    }
    
    private func updateTableViewHeight(newSize: CGSize) {
        tableViewHeightConst.constant = newSize.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newSize = change?[.newKey] as? CGSize {
                updateTableViewHeight(newSize: newSize)
            }
        }
    }
    
    func subscribe() {
        viewModel.$task
            .receive(on: DispatchQueue.main)
            .sink { [weak self] task in
                guard let self = self else { return }
                self.createButton.isEnabled = (task.name.checkValidation() && task.info.checkValidation() && task.startDate != nil && task.endDate != nil && task.startTime != nil && task.endTime != nil && task.priority != nil && task.persons.contains(where: { $0.checkValidation() }))
                if task.persons.count != viewModel.previousPersonsCount {
                    self.personsTableView.reloadData()
                    viewModel.previousPersonsCount = task.persons.count
                }
            }
            .store(in: &cancellables)
    }
    
    @objc func startDatePickerValueChanged() {
        endDatePicker.minimumDate = startDatePicker.date
        viewModel.task.startDate = startDatePicker.date
        startDateTextField.text = startDatePicker.date.toString(format: "dd/MM/yy")
    }
    
    @objc func endDatePickerValueChanged() {
        startDatePicker.maximumDate = endDatePicker.date
        viewModel.task.endDate = endDatePicker.date
        endDateTextField.text = endDatePicker.date.toString(format: "dd/MM/yy")
    }
    
    @objc func startTimePickerValueChanged() {
        endTimePicker.minimumDate = startTimePicker.date
        viewModel.task.startTime = startDatePicker.date
        startTimeTextField.text = startTimePicker.date.toString(format: "HH:mm")
    }
    
    @objc func endTimePickerValueChanged() {
        startTimePicker.maximumDate = endTimePicker.date
        viewModel.task.endTime = endTimePicker.date
        endTimeTextField.text = endTimePicker.date.toString(format: "HH:mm")
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func choosePriority(_ sender: UIButton) {
        dropDown.show()
        dropDownImageView.isHighlighted = !dropDown.isHidden
    }
    
    @IBAction func clickedAddPerson(_ sender: UIButton) {
        viewModel.addPerson()
    }
    
    @IBAction func clickedUploadFile(_ sender: UIButton) {
        let supportedTypes: [UTType] = [UTType.data]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func clickedCreate(_ sender: BaseButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.completion?()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension TaskFormViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.task.persons.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonFormTableViewCell", for: indexPath) as! PersonFormTableViewCell
        cell.configure(person: viewModel.task.persons[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        8
    }
}

extension TaskFormViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == nameTextField {
            viewModel.task.name = textField.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField == nameTextField
    }
}

extension TaskFormViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        viewModel.task.info = textView.text
    }
}

extension TaskFormViewController: PersonFormTableViewCellDelegate {
    func changeValue(value: String?, cell: UITableViewCell) {
        if let indexPath = personsTableView.indexPath(for: cell) {
            viewModel.task.persons[indexPath.section] = value ?? ""
        }
    }
}

extension TaskFormViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        do {
            let fileData = try Data(contentsOf: url)
            viewModel.task.file = fileData
        } catch {
            self.showErrorAlert(message: error.localizedDescription)
        }
    }
}

extension TaskFormViewController {
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(TaskFormViewController.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                scrollView.contentInset = .zero
            } else {
                let height: CGFloat = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)!.size.height
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}
