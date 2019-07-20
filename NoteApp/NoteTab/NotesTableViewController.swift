//
//  NotesTableViewController.swift
//  NoteApp
//
//  Created by Sergey Korobin on 20/07/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import UIKit

class NotesTableViewController: UIViewController {

    private let fileNotebook = FileNotebook()
    
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
        fileNotebook.loadFromFile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notesTableView.reloadData()
    }
    
    // MARK: UIBarButtonItems action logic
    @objc func editBarButtonTapped() {
        notesTableView.isEditing = !notesTableView.isEditing
    }
    
    @objc func addBarButtonTapped() {
        performSegue(withIdentifier: "showNoteEditVC", sender: addBarButton)
    }
    
    // MARK: prepare for note editing VC segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNoteEditVC" {
            guard let nextVC = segue.destination as? NoteEditViewController else {return}
            nextVC.fileNotebook = fileNotebook
            if let _ = sender as? UIBarButtonItem {
                print("new note edit")
            } else if let indexPathSender = sender as? IndexPath {
                let selectedNote = fileNotebook.notesArray[indexPathSender.row]
                nextVC.selectedNote = selectedNote
            }
        }
            
    }
    
}

extension NotesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let note = fileNotebook.notesArray[indexPath.row]
        fileNotebook.remove(with: note.uid)
        fileNotebook.saveToFile()
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showNoteEditVC", sender: indexPath)
    }
    
    // MARK: UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNotebook.notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        let note = fileNotebook.notesArray[indexPath.row]
        cell.colorView.backgroundColor = note.color
        cell.titleLabel.text = note.title
        cell.contentLabel.text = note.content
        return cell
    }
    
}
