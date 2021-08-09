//
//  RecordingListScreenViewController.swift
//  MuzyNew
//
//  Created by Syofia Friherdina on 28/07/21.
//

import UIKit
import AVFoundation

struct RecordingModel{
    var title : String = ""
    var duration : Int = 0
    var audio : Data = Data()
    var isSelected: Bool
}

enum MicState {
    case start
    case stop
}

class RecordingListScreenViewController: UIViewController {
    
    var audioPlayer = AVAudioPlayer()
    var micSystem:MicState = .stop
    @IBOutlet weak var navbarView: UIImageView!
    @IBOutlet weak var handleViewer: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet var recordingListScreenTableView: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    
    var dummyData = [RecordingModel]()
    var indexPlaying = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupUITable()
        recordingListScreenTableView.allowsMultipleSelectionDuringEditing = true
        recordingListScreenTableView.dataSource = self
        recordingListScreenTableView.delegate = self
        recordingListScreenTableView.estimatedRowHeight = 120
        recordingListScreenTableView.rowHeight = UITableView.automaticDimension
        
        
        self.navigationController?.navigationBar.largeTitleTextAttributes =
                [NSAttributedString.Key.font: UIFont(name: "New York Extra Large", size: 36),
                NSAttributedString.Key.foregroundColor: UIColor(named: "PlayPauseColorButton")]
        
    }
    
    
    @IBAction func didTappedEdit(_ sender: Any) {
        if recordingListScreenTableView.isEditing{
            recordingListScreenTableView.setEditing(false, animated: true)
            editButton.title = "Edit"
        }else{
            recordingListScreenTableView.setEditing(true, animated: true)
            editButton.title = "Done"
        }
        
//        debugPrint(dummyData.filter({ $0.isSelected == true}))
        
    }
    
    @IBAction func buttonStart(_ sender: UIButton) {
      
        if micSystem == .start {
            micSystem = .stop
          
            let largeConfig = UIImage.SymbolConfiguration(scale: .large)
           
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                  self.handleViewer.alpha = 1
                  self.handleViewer.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.bounds.width, height: -162)
                  self.handleViewer.layoutIfNeeded()
            }, completion: nil)
            
          addData()
    
              
        } else {
            micSystem = .start
          
            let largeConfig = UIImage.SymbolConfiguration(scale: .large)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                      self.handleViewer.alpha = 1
                      self.handleViewer.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.bounds.width, height: -300)
                      self.handleViewer.layoutIfNeeded()
                }, completion: nil)
        }
    }
        
    
    func setupUITable() {
        recordButton.layer.cornerRadius = recordButton.bounds.size.width / 2
        handleViewer.layer.cornerRadius = 26
        recordingListScreenTableView.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 20,right: 0)
        self.recordingListScreenTableView.rowHeight = 92

    }
    
    
    func addData(){
//        dummyData = [
//            RecordingModel(title: "Coba1", duration: 10, audio: Data()),
//            RecordingModel(title: "Coba2", duration: 3, audio: Data()),
//            RecordingModel(title: "Coba3", duration: 4, audio: Data()),
//            RecordingModel(title: "Coba4", duration: 3, audio: Data()),
//        ]
        var data =  RecordingModel(title: "Coba1", duration: 10, audio: Data(), isSelected: false)
        dummyData.append(data)
        recordingListScreenTableView.reloadData()
        
    }
    
    func setupTable(){
        let nib = UINib(nibName: "defaultRecordingListScreen", bundle: nil)
        recordingListScreenTableView.register(nib, forCellReuseIdentifier: "custom1")
        let nib2 = UINib(nibName: "ifTappedButton", bundle: nil)
        recordingListScreenTableView.register(nib2, forCellReuseIdentifier: "custom2")
        
    }
}

extension RecordingListScreenViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dummyData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if dummyData[indexPath.row].isSelected{
            return
        }
        dummyData[indexPath.row].isSelected.toggle()
        print("DidSelect method is called")
        
        let storyboard: UIStoryboard = UIStoryboard(name: "AudioViewer", bundle: nil)
        let vc = UIStoryboard(name:"AudioViewer", bundle: nil).instantiateViewController(identifier: "AudioViewerViewController") as! AudioViewerViewController
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //tableView.isEditing = true
        if tableView.isEditing{
            
            
        }else{
            
            
        }
        
        if !dummyData[indexPath.row].isSelected{
            return
        }
        dummyData[indexPath.row].isSelected.toggle()
        print("DidDeselect method is called")
    }
    func tableView (_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
//
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        //Cara Delete
//        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler) in
//            print("Delete: \(indexPath.row + 1)")
//            completionHandler(true)
//        }
//
//        delete.image = UIImage(systemName: "trash")?.withTintColor(UIColor(named: "DeleteAction") ?? .red, renderingMode: .alwaysOriginal)
//        delete.backgroundColor = UIColor(named: "SwipeActionDelete")
//
//        //Cara Rename
//        let rename = UIContextualAction(style: .normal, title: "Rename") { (action, view, completionHandler) in
//            print("Rename: \(indexPath.row + 1)")
//            completionHandler(true)
//        }
//
//        rename.image = UIImage (systemName: "pencil")?.withTintColor(UIColor(named: "PlayPauseColorButton") ?? .darkGray, renderingMode: .alwaysOriginal)
//        rename.backgroundColor = UIColor(named: "SwipeActionRename")
//
//        //swipe actions
//        let swipe = UISwipeActionsConfiguration(actions: [delete, rename])
//        return swipe
//    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        tableView.beginUpdates()
    //        dummyData.remove(at: indexPath.row)
    //        tableView.deleteRows(at: [indexPath], with: .fade)
            if editingStyle == .delete {
                tableView.beginUpdates()

                let alertView = UIAlertController(title: "Are you sure want to permanently delete this recording?", message: "This action cannot be undo", preferredStyle: .actionSheet)
                let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                    self.dummyData.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.endUpdates()
                }
                let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
                }
                    alertView.addAction(delete)
                    alertView.addAction(cancel)
                    
                present(alertView, animated: true, completion: nil)
                
            }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == indexPlaying{
            //cell playing
            let cell = recordingListScreenTableView.dequeueReusableCell(withIdentifier: "custom2") as! IfTappedCell
            cell.action = {
                self.indexPlaying = -1
                self.recordingListScreenTableView.reloadData()
            }
            
            let sound = Bundle.main.path(forResource: "suaraWakan", ofType: "mp3")
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                
            }
            catch {
                print(error)
            }
            audioPlayer.play()
            
            return cell
            
        } else {
            if indexPlaying == -1 {
            audioPlayer.stop() }
            print(indexPlaying)
            //cell default
            let cell = recordingListScreenTableView.dequeueReusableCell(withIdentifier: "custom1") as! DefaultRecordingCell
            
            cell.action = {
                self.indexPlaying = indexPath.row
                self.recordingListScreenTableView.reloadData()
            }
            
            return cell
            
        }
    
    }
    
}




extension RecordingListScreenViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.indexPlaying{
            // tinggi cell pas playing
            return UITableView.automaticDimension
        }else{
            // tinggi cell default
            return UITableView.automaticDimension
            }
        }
    func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        true
    }
    func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        recordingListScreenTableView.setEditing(true, animated: true)
    }
    func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
        print("\(#function)")
    }
}



