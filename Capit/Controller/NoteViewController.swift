//
//  NoteViewController.swift
//  Capit
//
//  Created by Abdullah on 08/03/2020.
//  Copyright © 2020 Abdullah. All rights reserved.
//

import UIKit
import RealmSwift

class NoteViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var noteTextView: UITextView!
    let realm = try! Realm()
    
    var selectedNote: Note? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = selectedNote?.title
        noteTextView.font = UIFont(name: "RobotoMono-Medium", size: 16)
        if let noteText = selectedNote?.text {
            noteTextView.text = noteText
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("TextViewDidChange")
        try! realm.write {
            selectedNote?.text = noteTextView.text
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            selectedNote?.text = noteTextView.text
        }
    }
    
}
