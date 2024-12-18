//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true;
        navigationItem.title = K.appName
        
        
        tableView.dataSource = self;
       
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        // Dynamic cell height
          tableView.rowHeight = UITableView.automaticDimension
          tableView.estimatedRowHeight = 60

        
        loadMessages()
        
        

    }
    
    func loadMessages(){
       
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
            self.messages = [];
            if let e = error{
                print("there was an error retreiving data from firestore \(e)")
            }else{
                if let snapshots  = querySnapshot?.documents{
                    for doc in snapshots{
                        let data = doc.data();
                        if let messageSender = data[K.FStore.senderField] as? String,let messageBody = data[K.FStore.bodyField] as? String{
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }

                           
                        }
                    }
                }
            }
        }
        
    }
    
    var messages:[Message] = []
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text,let messageSender = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(
                data: [K.FStore.senderField:messageSender,
                       K.FStore.bodyField:messageBody,
                       K.FStore.dateField: Date().timeIntervalSince1970]) { error in
                if let e = error {
                    print("there was an error storing your data \(e)")
                }else{
                    print("data stored successfully")
                    
                    DispatchQueue.main.async {
                                      self.messageTextfield.text = ""
                                  }
                }
                           
                          
            }
            
        }
      

        
    }
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true);
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    

}

extension ChatViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
       
        let cell = tableView.dequeueReusableCell(withIdentifier:K.cellIdentifier,for:indexPath) as! MessageCell
        cell.label.text = message.body
        
        //message from current user
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true;
            cell.rightImageView.isHidden = false;
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named:K.BrandColors.purple)
        }
        
        //message from other user
        else{
            cell.leftImageView.isHidden = false;
            cell.rightImageView.isHidden = true;
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named:K.BrandColors.lightPurple)
        }
        
        return cell
    }
    
    
}


