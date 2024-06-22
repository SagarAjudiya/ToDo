//
//  ListCell.swift
//  ToDo
//
//  Created by Sagar Ajudiya on 20/06/24.
//

import UIKit

class ListCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblTask: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    // MARK: - Variable
    var clsIsDoneTap: ((ToDoModel) -> Void)?
    var clsDeleteTap: ((ToDoModel) -> Void)?
    
    // MARK: - Variable
    var todo: ToDoModel? {
        didSet {
            lblTask.text = todo?.task
            btnDone.isSelected = todo?.isDone ?? false
        }
    }
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - IBAction
    @IBAction func btnDoneTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        todo?.isDone = sender.isSelected
        clsIsDoneTap?(todo ?? ToDoModel())
    }
    
    @IBAction func btnDeleteTap(_ sender: UIButton) {
        clsDeleteTap?(todo ?? ToDoModel())
    }

}
