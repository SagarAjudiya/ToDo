//
//  EditTaskVC.swift
//  ToDo
//
//  Created by Sagar Ajudiya on 20/06/24.
//

import UIKit

enum ScreenType {
    case add
    case edit
}

class EditTaskVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var txtTask: UITextField!
    @IBOutlet weak var lblError: UILabel!
    
    // MARK: - Variable
    var todo: ToDoModel?
    var screenType = ScreenType.add
    var clsDoneTap: ((ToDoModel) -> Void)?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - IBAction
    @IBAction func btnDoneTap(_ sender: UIButton) {
        addOrEditTask()
    }

}

// MARK: - Functions
extension EditTaskVC {
    
    private func setUI() {
        txtTask.delegate = self
        txtTask.text = todo?.task
        lblTitle.text = screenType == .add ? "New Task" : "Edit Task"
        btnDone.setTitle(screenType == .add ? "Done" : "Save", for: .normal)
        txtTask.becomeFirstResponder()
    }
    
    private func addOrEditTask() {
        guard validation else { return }
        if screenType == .add {
            let newTodo = ToDoModel(task: txtTask.text)
            clsDoneTap?(newTodo)
        } else {
            todo?.task = txtTask.text
            clsDoneTap?(todo ?? ToDoModel())
        }
        dismiss(animated: true)
    }
    
}

// MARK: - Validation
extension EditTaskVC {

    var validation: Bool {
        if txtTask.text?.isEmpty == true {
            let strTitle = "Please enter Todo"
            lblError.isHidden = false
            lblError.text = strTitle
            return false
        }
        return true
    }

}

// MARK: - TextField Delegate
extension EditTaskVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (range.location == 0 && string == " ") {
            return false
        }
        return true
    }
    
}
