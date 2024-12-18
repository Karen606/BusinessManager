//
//  EventFormViewController.swift
//  BusinessManager
//
//  Created by Karen Khachatryan on 18.12.24.
//

import UIKit
import DropDown
import Combine

class EventFormViewController: UIViewController {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var eventTypeButton: UIButton!
    @IBOutlet weak var startDateTextField: BaseTextField!
    @IBOutlet weak var endDateTextField: BaseTextField!
    @IBOutlet weak var placeTextField: BaseTextField!
    @IBOutlet weak var descriptionTextView: PaddingTextView!
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var saveButton: BaseButton!
    @IBOutlet weak var eventDropDownImageView: UIImageView!
    @IBOutlet weak var reminderDropDownImageView: UIImageView!
    @IBOutlet weak var categoryDropDownImageView: UIImageView!
    @IBOutlet weak var eventTypeView: UIView!
    @IBOutlet weak var reminderView: UIView!
    @IBOutlet weak var categoryView: UIView!
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let eventDropDown = DropDown()
    private let reminderDropDown = DropDown()
    private let categoryDropDown = DropDown()
    private let viewModel = EventFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var completion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    override func viewDidLayoutSubviews() {
        self.eventDropDown.width = eventTypeButton.bounds.width
        self.eventDropDown.bottomOffset = CGPoint(x: self.eventTypeButton.frame.minX, y: self.eventTypeButton.frame.maxY + 2)
        self.reminderDropDown.width = reminderButton.bounds.width
        self.reminderDropDown.bottomOffset = CGPoint(x: self.reminderButton.frame.minX, y: self.reminderButton.frame.maxY + 2)
        self.categoryDropDown.width = categoryButton.bounds.width
        self.categoryDropDown.bottomOffset = CGPoint(x: self.categoryButton.frame.minX, y: self.categoryButton.frame.maxY + 2)
    }
    
    func setupUI() {
        setNavigationTitle(title: "Add event to calendar")
        setNaviagtionCancelButton()
        saveButton.titleLabel?.font = .semiboldSFPro(size: 20)
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 6
        descriptionTextView.font = .regular(size: 14)
        descriptionTextView.delegate = self
        placeTextField.delegate = self
        let dropDownButtons = [eventTypeButton, reminderButton, categoryButton]
        for button in dropDownButtons {
            button?.layer.borderColor = UIColor.black.cgColor
            button?.layer.borderWidth = 1
            button?.layer.cornerRadius = 6
            button?.titleLabel?.font = .regular(size: 14)
        }
        endDateTextField.setupRightViewIcon(.calendar, size: CGSize(width: 40, height: 40))
        startDateTextField.setupRightViewIcon(.calendar, size: CGSize(width: 40, height: 40))
        startDatePicker.locale = NSLocale.current
        startDatePicker.datePickerMode = .dateAndTime
        startDatePicker.preferredDatePickerStyle = .wheels
        startDatePicker.addTarget(self, action: #selector(startDatePickerValueChanged), for: .valueChanged)
        startDateTextField.inputView = startDatePicker
        
        endDatePicker.locale = NSLocale.current
        endDatePicker.datePickerMode = .dateAndTime
        endDatePicker.preferredDatePickerStyle = .wheels
        endDatePicker.addTarget(self, action: #selector(endDatePickerValueChanged), for: .valueChanged)
        endDateTextField.inputView = endDatePicker
        
        DropDown.appearance().textColor = .black
        DropDown.appearance().textFont = .regular(size: 15) ?? .boldSystemFont(ofSize: 18)
        DropDown.appearance().selectionBackgroundColor = .clear

        let eventData: [String] = EventType.allCases.map { $0.rawValue }
        eventDropDown.backgroundColor = .white
        eventDropDown.setupCornerRadius(8)
        eventDropDown.dataSource = eventData
        eventDropDown.anchorView = eventTypeView
        eventDropDown.direction = .bottom
        eventDropDown.addShadow()
        
        eventDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.viewModel.event.event = index
            self.eventTypeButton.setTitle(EventType.allCases[index].rawValue, for: .normal)
            self.eventDropDownImageView.isHighlighted = false
        }
        
        eventDropDown.cancelAction = { [weak self] in
            guard let self = self else { return }
            self.eventDropDownImageView.isHighlighted = false
        }
        
        let reminderData: [String] = Reminder.allCases.map { $0.rawValue }
        reminderDropDown.backgroundColor = .white
        reminderDropDown.setupCornerRadius(8)
        reminderDropDown.dataSource = reminderData
        reminderDropDown.anchorView = reminderView
        reminderDropDown.direction = .bottom
        reminderDropDown.addShadow()
        
        reminderDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.viewModel.event.reminder = index
            self.reminderButton.setTitle(Reminder.allCases[index].rawValue, for: .normal)
            self.reminderDropDownImageView.isHighlighted = false
        }
        
        reminderDropDown.cancelAction = { [weak self] in
            guard let self = self else { return }
            self.reminderDropDownImageView.isHighlighted = false
        }
        
        let categoryData: [String] = EventCategory.allCases.map { $0.rawValue }
        categoryDropDown.backgroundColor = .white
        categoryDropDown.setupCornerRadius(8)
        categoryDropDown.dataSource = categoryData
        categoryDropDown.anchorView = categoryView
        categoryDropDown.direction = .bottom
        categoryDropDown.addShadow()
        
        categoryDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.viewModel.event.category = index
            self.categoryButton.setTitle(EventCategory.allCases[index].rawValue, for: .normal)
            self.categoryDropDownImageView.isHighlighted = false
        }
        
        categoryDropDown.cancelAction = { [weak self] in
            guard let self = self else { return }
            self.categoryDropDownImageView.isHighlighted = false
        }

    }
    
    func subscribe() {
        viewModel.$event
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                self.saveButton.isEnabled = (event.event != nil && event.startDate != nil && event.endDate != nil && event.place.checkValidation() && event.info.checkValidation() && event.reminder != nil && event.category != nil)
            }
            .store(in: &cancellables)
    }
    
    @objc func startDatePickerValueChanged() {
        endDatePicker.minimumDate = startDatePicker.date
        viewModel.event.startDate = startDatePicker.date
        startDateTextField.text = startDatePicker.date.toString(format: "dd/MM/yy HH:mm")
    }
    
    @objc func endDatePickerValueChanged() {
        startDatePicker.maximumDate = endDatePicker.date
        viewModel.event.endDate = endDatePicker.date
        endDateTextField.text = endDatePicker.date.toString(format: "dd/MM/yy HH:mm")
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func chooseEventType(_ sender: UIButton) {
        eventDropDown.show()
        eventDropDownImageView.isHighlighted = !eventDropDown.isHidden
    }
    
    @IBAction func chooseReminder(_ sender: UIButton) {
        reminderDropDown.show()
        reminderDropDownImageView.isHighlighted = !reminderDropDown.isHidden
    }
    
    @IBAction func chooseCategory(_ sender: UIButton) {
        categoryDropDown.show()
        categoryDropDownImageView.isHighlighted = !categoryDropDown.isHidden
    }
    
    @IBAction func clickedSave(_ sender: BaseButton) {
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

extension EventFormViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == placeTextField {
            viewModel.event.place = textField.text
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        viewModel.event.info = textView.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
