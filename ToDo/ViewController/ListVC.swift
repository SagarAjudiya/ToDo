//
//  ListVC.swift
//  ToDo
//
//  Created by Sagar Ajudiya on 20/06/24.
//

import UIKit

class ListVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    
    // MARK: - Variable
    private var list = [ToDoModel]() {
        didSet {
            tblList.reloadData()
            tblList.backgroundView?.alpha = list.count <= 0 ? 1 : 0
        }
    }
    private lazy var searchList = list {
        didSet {
            tblList.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    // MARK: - IBAction
    @IBAction func btnAddTap(_ sender: Any) {
        guard let newTaskVC = getInstance(from: "Main", EditTaskVC.self) else { return }
        newTaskVC.screenType = .add
        newTaskVC.clsDoneTap = { [weak self] todo in
            guard let self else { return }
            list.insert(todo, at: 0)
            searchList.insert(todo, at: 0)
            SessionManager.shared.userTodo = list
        }
        present(newTaskVC, animated: true)
    }
    
}

// MARK: - Functions
extension ListVC {
    
    private func setUI() {
        txtSearch.delegate = self
        tblList.setup(ListCell.self, delegate: self, dataSource: self)
        if let todo = SessionManager.shared.userTodo {
            list = todo
        }
//        if let model = CoreDataWrapper.shared.fetchResponseModels([ToDoModel].self) {
//            for item in model {
//                list = item
//                print(list)
//            }
//        }
        }
    
    private func saveToCoreData() {
//        if let jsonData = try? JSONEncoder().encode(list) {
//            CoreDataWrapper.shared.createTableForResponseModel([ToDoModel].self, jsonData: jsonData)
//        }
    }

}

// MARK: - TextField Delegate
extension ListVC: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let searchText = txtSearch?.text ?? ""
        if searchText.isEmpty {
            searchList = list
        } else {
            searchList = list.filter { ($0.task?.lowercased() ?? "").contains(searchText.lowercased()) }
        }
        tblList?.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if txtSearch?.text == "" && string == " " {
            return false
        }
        return true
    }
    
}

// MARK: - TableView Delegate
extension ListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchList.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.className, for: indexPath) as? ListCell else { return UITableViewCell() }
        cell.todo = searchList[indexPath.row]
        
        cell.clsIsDoneTap = { [weak self] todo in
            guard let self else { return }
            if let index = list.firstIndex(where: { $0.id == todo.id }) {
                list[index].isDone = todo.isDone
                searchList[indexPath.row].isDone = todo.isDone
            }
            SessionManager.shared.userTodo = list
        }
        
        cell.clsDeleteTap = { [weak self] todo in
            guard let self else { return }
            showAlert(title: "Are you sure?", message: "You want to delete this?", okActionHandler: {
                if let index = self.list.firstIndex(where: { $0.id == todo.id }) {
                    self.list.remove(at: index)
                    self.searchList.remove(at: indexPath.row)
                }
                SessionManager.shared.userTodo = self.list
                self.showToast(message: "Task delete successfully.")
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let editTaskVC = getInstance(from: "Main", EditTaskVC.self) else { return }
        editTaskVC.screenType = .edit
        editTaskVC.todo = list[indexPath.row]
        editTaskVC.clsDoneTap = { [weak self] todo in
            guard let self else { return }
            list[indexPath.row] = todo
            searchList[indexPath.row] = todo
            SessionManager.shared.userTodo = list
            showToast(message: "Task edit successfully.")
        }
        present(editTaskVC, animated: true)
    }
    
}
