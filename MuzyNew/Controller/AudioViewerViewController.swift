//
//  AudioViewerViewController.swift
//  MuzyNew
//
//  Created by Syofia Friherdina on 28/07/21.
//

import UIKit
import AVFoundation

class AudioViewerViewController: UIViewController {

    var segmentedIndex : Int = 0
    var isActive:Bool = false
    var audioPlayer = AVAudioPlayer()
    var recordTitle = ""
    
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var sliderBar: UISlider!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet var viewScoreNotes: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    

    @IBAction func backButton(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
//Function tombol play and pause
    @IBAction func whenTapped(_ sender: UIButton) {
        if isActive {
            isActive = false
            let largeConfig = UIImage.SymbolConfiguration(scale: .large)
            let image = UIImage(systemName: "play.fill", withConfiguration: largeConfig)?.withRenderingMode(.automatic)
            playButton.setImage(image, for: .normal)
            audioPlayer.stop()
            
            
        } else {
            isActive = true
            let largeConfig = UIImage.SymbolConfiguration(scale: .large)
            let image = UIImage(systemName: "pause.fill", withConfiguration: largeConfig)?.withRenderingMode(.automatic)
            playButton.setImage(image, for: .normal)
            
            if segmentedControl.selectedSegmentIndex == 0 {
                let sound = Bundle.main.path(forResource: "suaraWakan", ofType: "mp3")
               
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                    
                }
                catch {
                    print(error)
                }
                
                setupPlayer()
                sliderBar.maximumValue = Float(audioPlayer.duration)
                audioPlayer.play()
                
            } else if segmentedControl.selectedSegmentIndex == 1 {
                let sound = Bundle.main.path(forResource: "pianoSound", ofType: "mp3")
               
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                    
                }
                catch {
                    print(error)
                }
                
                setupPlayer()
                sliderBar.maximumValue = Float(audioPlayer.duration)
                audioPlayer.play()
                }
            }
    }
    
    
    
    @IBOutlet var scoreNotesView: UIImageView!
    @IBOutlet var navbarTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingPage()
        whenPlayButton()
        saveMenu()
        
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "PlayPauseColorButton")], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "PrimaryColor")], for: .selected)
        
        if(self.traitCollection.userInterfaceStyle == .light){
            var image : UIImage = UIImage(named: "scoreNotesBlack")!
            scoreNotesView.image = image
        } else {
            var image : UIImage = UIImage(named: "scoreNotesWhite")!
            scoreNotesView.image = image
        }
            self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: UIFont(name: "New York Extra Large", size: 18),
            NSAttributedString.Key.foregroundColor: UIColor(named: "PlayPauseColorButton")]
    }
    
  
    func saveMenu(){
            print("push")
            //1. Bikin UIMenu
            let alert = UIAlertController(title: "Successful", message: "MIDI has been saved to file", preferredStyle: .alert)
            
            alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(named: "PrimaryColor")
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
//            alert.addAction(UIAlertAction(title: "Open in Files App", style: ., handler: nil))
            
            let saveMenu = UIMenu(title: "", children: [UIAction(title: "Save MIDI as .mp3", image: UIImage(systemName: "doc")){action in self.present(alert, animated: true, completion: nil) },
                                                        UIAction(title: "Save MIDI as .wav", image: UIImage(systemName: "doc")) { action in self.present(alert, animated: true, completion: nil) },
                                                        UIAction(title: "Save Score Notes as .pdf", image: UIImage(systemName: "doc")) { action in self.present(alert, animated: true, completion: nil) },
                                                        ]
            )
                              // << here !!
            //2. Bikin Barbutton
            let addButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), menu :saveMenu)
            navigationItem.setRightBarButton(addButton, animated: true)
            navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "PlayPauseColorButton")

        }
    
    private var timer:Timer?
    
    @objc private func updateProgress(){
        sliderBar.value = Float(audioPlayer.currentTime)
        startTimeLabel.text = getFormattedTime(timeInterval: audioPlayer.currentTime)
        let remainingTime = audioPlayer.duration - audioPlayer.currentTime
        endTimeLabel.text = getFormattedTime(timeInterval: remainingTime)
        print(audioPlayer.currentTime, audioPlayer.duration, remainingTime)
    }
    
    private func getFormattedTime(timeInterval: TimeInterval) -> String {
        let mins = timeInterval / 60
        let secs = timeInterval.truncatingRemainder(dividingBy: 60)
        let timeFormatter = NumberFormatter()
        timeFormatter.minimumIntegerDigits = 2
        timeFormatter.minimumFractionDigits = 0
        timeFormatter.roundingMode = .down
        
        guard let minsString = timeFormatter.string(from: NSNumber(value: mins)), let secStr = timeFormatter.string(from: NSNumber(value: secs)) else {
            return "00:00"
        }
        return "\(minsString):\(secStr)"
    }
    
    
    @IBAction func recordBar(_ sender: UISlider) {
        audioPlayer.currentTime = Float64(sender.value)
    }
    
    func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func setupPlayer(){
        let audioFilename = getDocumentDirectory().appendingPathComponent(recordTitle)
        
        //SYF
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
        } catch {
            print(error)
        }
    }
    
    
//tampilan awal
    private func loadingPage(){
        cardView.layer.cornerRadius = 26
    }


    private func whenPlayButton(){
        playButton.layer
            .cornerRadius = playButton.bounds.size.width / 2
     
    }
    
    
//function segmented ketika di klik
    @IBAction func didSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            segmentedIndex = 0
            
        } else if sender.selectedSegmentIndex == 1 {
            segmentedIndex = 1
        }
    }
}



