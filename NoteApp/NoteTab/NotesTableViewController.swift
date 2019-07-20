//
//  NotesTableViewController.swift
//  NoteApp
//
//  Created by Sergey Korobin on 20/07/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import UIKit

class NotesTableViewController: UIViewController {

    @IBOutlet weak var notesTableView: UITableView!{
        didSet{
            notesTableView.delegate = self
            notesTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!{
        didSet{
            editBarButton.target = self
            editBarButton.action = #selector(editBarButtonTapped)
        }
    }
    @IBOutlet weak var addBarButton: UIBarButtonItem!{
        didSet{
            addBarButton.target = self
            addBarButton.action = #selector(addBarButtonTapped)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: UIBarButtonItems action logic
    @objc func editBarButtonTapped() {
        print("edit tapped")
        if notesTableView.isEditing {
            notesTableView.isEditing = false
        } else {
            notesTableView.isEditing = true
        }
    }
    
    @objc func addBarButtonTapped() {
        print("add tapped")
        performSegue(withIdentifier: "showNoteEditVC", sender: addBarButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNoteEditVC" {
            // do stuff here
            if let barButtonSender = sender as? UIBarButtonItem {
                print("empty build")
            } else if let indexPathSender = sender as? IndexPath {
                print("preload data")
            }
        }
            
    }
    
}

extension NotesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
//        let note = notebook[indexPath]
//        notebook.remove(with: note.uid)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showNoteEditVC", sender: indexPath)
    }
    
    // MARK: UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // test only
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        if indexPath.row == 0 {
            cell.colorView.backgroundColor = .red
            cell.titleLabel.text = "Тестовая заметка №1"
            cell.contentLabel.text = "параша - судьба наша"
        } else if indexPath.row == 1 {
            cell.colorView.backgroundColor = .yellow
            cell.titleLabel.text = "Тестовая заметка №2"
            cell.contentLabel.text = "параша - судьба наша\nпараша - судьба наша"
        } else if indexPath.row == 2 {
            cell.colorView.backgroundColor = .black
            cell.titleLabel.text = "Тестовая заметка №3"
            cell.contentLabel.text = "параша - судьба наша\nпараша - судьба наша\nпараша - судьба наша"
        } else if indexPath.row == 3 {
            cell.colorView.backgroundColor = .blue
            cell.titleLabel.text = "Тестовая заметка №4"
            cell.contentLabel.text = "параша - судьба наша\nпараша - судьба наша\nпараша - судьба наша\nпараша - судьба наша"
        } else if indexPath.row == 4 {
            cell.colorView.backgroundColor = .green
            cell.titleLabel.text = "Тестовая заметка №5"
            cell.contentLabel.text = "параша - судьба наша\nпараша - судьба наша\nпараша - судьба наша\nпараша - судьба наша\nпараша - судьба наша"
        } else if indexPath.row == 5 {
            cell.colorView.backgroundColor = .black
            cell.titleLabel.text = "BLACK"
            cell.contentLabel.text = "параша - судьба наша\nпараша - судьба наша\nпараша - судьба наша\nпараша - судьба наша\nпараша - судьба наша\nпараша - судьба наша"
        } else if indexPath.row == 6 {
            cell.colorView.backgroundColor = .black
            cell.titleLabel.text = "BLACK vol 2"
            cell.contentLabel.text = "елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!"
        } else if indexPath.row == 7 {
            cell.colorView.backgroundColor = .black
            cell.titleLabel.text = "BLACK vol 2"
            cell.contentLabel.text = "елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!"
        } else if indexPath.row == 8 {
            cell.colorView.backgroundColor = .black
            cell.titleLabel.text = "BLACK vol 2"
            cell.contentLabel.text = "елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!"
        } else if indexPath.row == 9 {
            cell.colorView.backgroundColor = .black
            cell.titleLabel.text = "BLACK vol 2"
            cell.contentLabel.text = "елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!елки иголки и ебал я телку, елки-иголки и ебал я телку!"
        }
        return cell
    }
    
}
