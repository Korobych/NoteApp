//
//  ViewController.swift
//  NoteApp
//
//  Created by Sergey Korobin on 30/06/2019.
//  Copyright © 2019 SergeyKorobin. All rights reserved.
//

import UIKit

class NoteEditViewController: UIViewController {
    
    var fileNotebook: FileNotebook!
    var selectedNote: Note? = nil
    
    var lastTappedColorButton: UIButton? = nil
    var addedDatePicker: UIDatePicker? = nil
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!{
        didSet{
            saveBarButton.target = self
            saveBarButton.action = #selector(saveBarButtonTapped)
        }
    }
    // MARK: TitleView
    @IBOutlet weak var titleTextField: UITextField!
    // MARK: ContentView
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentTextView: UITextView!{
        didSet{
            contentTextView.delegate = self
            contentTextView.isScrollEnabled = false
            contentTextView.layer.borderColor = UIColor.lightGray.cgColor
            contentTextView.layer.borderWidth = 1.0
        }
    }
    // MARK: DestroyDateView
    @IBOutlet weak var destroyDateView: UIView!
    @IBOutlet weak var destroyDateSwitch: UISwitch!
    @IBOutlet weak var destroyDateViewHeight: NSLayoutConstraint!
    
    @IBAction func destroyDateSwitchTapped(_ sender: UISwitch) {
        if sender.isOn {
            print("\ndestroyDate switch is ON")
            destroyDateViewHeight.constant += 216
            mainScrollView.layoutIfNeeded()
            createDatePicker(width: view.frame.width, date: selectedNote?.selfDestructionDate)
        } else {
            print("\ndestroyDate switch is OFF")
            destroyDateViewHeight.constant -= 216
            for view in destroyDateView.subviews{
                if view is UIDatePicker{
                    view.removeFromSuperview()
                }
            }
            addedDatePicker = nil
        }
    }
    // MARK: ColorView
    @IBOutlet weak var firstColorButton: UIButton!{
        didSet{
            firstColorButton.layer.borderColor = UIColor.black.cgColor
            firstColorButton.layer.borderWidth = 1.0
            firstColorButton.setTitle("", for: .normal)
            firstColorButton.backgroundColor = UIColor.white
            addCircleWithTickView(button: firstColorButton)
        }
    }
    @IBOutlet weak var secondColorButton: UIButton!{
        didSet{
            secondColorButton.layer.borderColor = UIColor.black.cgColor
            secondColorButton.layer.borderWidth = 1.0
            secondColorButton.setTitle("", for: .normal)
            secondColorButton.backgroundColor = UIColor.red
        }
    }
    @IBOutlet weak var thirdColorButton: UIButton!{
        didSet{
            thirdColorButton.layer.borderColor = UIColor.black.cgColor
            thirdColorButton.layer.borderWidth = 1.0
            thirdColorButton.setTitle("", for: .normal)
            thirdColorButton.backgroundColor = UIColor.green
        }
    }
    @IBOutlet weak var fourthColorButton: UIButton!{
        didSet{
            fourthColorButton.layer.borderColor = UIColor.black.cgColor
            fourthColorButton.layer.borderWidth = 1.0
            fourthColorButton.setTitle("", for: .normal)
            fourthColorButton.setBackgroundImage(UIImage(named: "spectrumPic"), for: .normal)
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(colorPickerLongPress))
            longPress.minimumPressDuration = 1.0
            fourthColorButton.addGestureRecognizer(longPress)
        }
    }
    
    @IBAction func changeColorButtonTapped(_ sender: UIButton) {
        if sender.backgroundColor != nil {
            addCircleWithTickView(button: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getInfoFromNote()
    }
    
    func createDatePicker(width: CGFloat, date: Date? = nil){
        let datePicker = UIDatePicker(frame: CGRect(x: destroyDateView.bounds.origin.x, y: destroyDateView.bounds.origin.y + destroyDateSwitch.frame.height, width: width, height: destroyDateView.bounds.height - destroyDateSwitch.frame.height))
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .dateAndTime
        if let selectedDate = date{
            datePicker.date = selectedDate
        }
        destroyDateView.addSubview(datePicker)
        
        addedDatePicker = datePicker
    }
    
    func addCircleWithTickView(button: UIButton) {
        // check for last tapped color button -> remove CircleViewWithTick in it
        if let lastTapped = lastTappedColorButton{
            for v in lastTapped.subviews{
                if v is CirlceViewWithTick{
                    v.removeFromSuperview()
                    break
                }
            }
        }
        lastTappedColorButton = button
        // add new view with CoreGraphics (tick in circle)
        let cirlceView = CirlceViewWithTick(frame: button.bounds)
        cirlceView.backgroundColor = UIColor.clear
        button.addSubview(cirlceView)
    }
    
    func getInfoFromNote(){
        // get info from note and update UI
        guard let editableNote = selectedNote else {return}
        titleTextField.text = editableNote.title
        contentTextView.text = editableNote.content
        textViewDidChange(contentTextView)
        switch editableNote.color {
        case .white:
            addCircleWithTickView(button: firstColorButton)
        case .red:
            addCircleWithTickView(button: secondColorButton)
        case .green:
            addCircleWithTickView(button: thirdColorButton)
        case let color:
            addCircleWithTickView(button: fourthColorButton)
            fourthColorButton.setBackgroundImage(nil, for: .normal)
            fourthColorButton.backgroundColor = color
        }
        // get destructionDate if it is stored and update it in UI
        guard let destructionDate = editableNote.selfDestructionDate else {return}
        if addedDatePicker == nil {
            destroyDateSwitch.isOn = true
            destroyDateViewHeight.constant += 216
            mainScrollView.layoutIfNeeded()
            createDatePicker(width: view.frame.width, date: destructionDate)
        }
    }
    
    @objc func colorPickerLongPress(gesture: UILongPressGestureRecognizer) {
        // Show ColorPickerViewController modally
        if gesture.state == UIGestureRecognizer.State.began {
            let storyboard = UIStoryboard(name: "ColorPicker", bundle: nil)
            let colorPickerViewController = storyboard.instantiateViewController(withIdentifier: "colorPickerModal") as! ColorPickerViewController
            colorPickerViewController.delegate = self
            if selectedNote == nil {
                // case when user creating new note
                guard let title = titleTextField.text else {return}
                guard let content = contentTextView.text else {return}
                guard let selectedColor = lastTappedColorButton?.backgroundColor else {return}
                var destructionDate: Date? = nil
                if let datePicker = addedDatePicker {
                    destructionDate = datePicker.date
                }
                colorPickerViewController.selectedNote = Note(title: title, content: content, color: selectedColor, selfDestructionDate: destructionDate)
            } else {
                // defalut edit scenario
                colorPickerViewController.selectedNote = selectedNote
            }
            navigationController?.pushViewController(colorPickerViewController, animated: true)
        }
    }
    
    @objc func saveBarButtonTapped() {
        var index = -1
        if let selectedNote = selectedNote {
            // case when user edits existing note
            // this note should be deleted from array
            
            // index = fileNotebook.remove(with: selectedNote.uid)
            
            let removeNoteOperation = RemoveNoteOperation(noteId: selectedNote.uid,
                                                          notebook: fileNotebook,
                                                          backendQueue: OperationQueue(),
                                                          dbQueue: OperationQueue())
            removeNoteOperation.completionBlock = {
                if let result = removeNoteOperation.result {
                    index = result
                }
            }
            OperationQueue().addOperation(removeNoteOperation)
        }
        // then new note should be created and saved
        guard let title = titleTextField.text else {return}
        guard let content = contentTextView.text else {return}
        guard let selectedColor = lastTappedColorButton?.backgroundColor else {return}
        // destruction date attempt to get value
        var destructionDate: Date? = nil
        if let datePicker = addedDatePicker {
            destructionDate = datePicker.date
        }
        let newNote = Note(title: title, content: content, color: selectedColor, importance: Importance.basic, selfDestructionDate: destructionDate)
        if index >= 0 {
            // case when user edits existing note
            // add note to the same array index as previously deleted note
            
            // NEW SaveNoteDBOperationWith Index should be implemented
            // Task safe
            fileNotebook.addWithIndex(note: newNote, index: index)
            fileNotebook.saveToFile()
            selectedNote = nil
            navigationController?.popViewController(animated: true)
            //
        } else {
            // fileNotebook.add(noteToAdd: newNote)
            
            let saveNoteOperation = SaveNoteOperation(note: newNote, notebook: fileNotebook, backendQueue: OperationQueue(), dbQueue: OperationQueue())
            
            saveNoteOperation.completionBlock = {
                OperationQueue.main.addOperation {
                    self.selectedNote = nil
                    self.navigationController?.popViewController(animated: true)
                }
            }
            OperationQueue().addOperation(saveNoteOperation)
        }
    }
    
    // MARK: Keyboard Logic
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // MARK: Orientation change logic
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("isLandscape")
            if destroyDateSwitch.isOn{
                for view in destroyDateView.subviews{
                    if view is UIDatePicker{
                        view.removeFromSuperview()
                        createDatePicker(width: size.height, date: selectedNote?.selfDestructionDate)
                        break
                    }
                }
            }
        } else if UIDevice.current.orientation.isPortrait{
            print("isPortrait")
            if destroyDateSwitch.isOn{
                for view in destroyDateView.subviews{
                    if view is UIDatePicker{
                        view.removeFromSuperview()
                        createDatePicker(width: size.width, date: selectedNote?.selfDestructionDate)
                        break
                    }
                }
            }
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
}

extension NoteEditViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        contentViewHeight.constant = estimatedSize.height
    }
}

extension NoteEditViewController: ModalToNoteEditVCDelegate {
    func getChangedNote(note: Note) {
        selectedNote = note
    }
}
