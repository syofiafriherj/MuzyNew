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
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    
    
    
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
            let sound = Bundle.main.path(forResource: "Test1", ofType: "mp3")
           
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
    
    @IBOutlet var navbarTitle: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingPage()
        whenPlayButton()
        saveMenu()
    
      
        
        self.navigationController?.navigationBar.titleTextAttributes =
                    [NSAttributedString.Key.font: UIFont(name: "New York Extra Large", size: 18),
                     NSAttributedString.Key.foregroundColor: UIColor.init(displayP3Red: 0.224, green: 0.298, blue: 0.357, alpha: 1)]
        
    }
    
    
    
    func saveMenu(){
        //1. Bikin UIMenu
        let saveMenu = UIMenu(title: "", children: [UIAction(title: "Save MIDI as .mp3", image: UIImage(systemName: "doc")) { action in },
                                                    UIAction(title: "Save MIDI as .wav", image: UIImage(systemName: "doc")) { action in },
                                                    UIAction(title: "Save Score Notes as .pdf", image: UIImage(systemName: "doc")) { action in },
                                                    ])
        
        //2. Bikin Barbutton
        let addButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), menu :saveMenu)
//        navigationController?.navigationBar.tintColor = .black
        if(overrideUserInterfaceStyle == .light){
            navigationItem.setRightBarButton(addButton, animated: true)
            navigationItem.rightBarButtonItem?.tintColor = UIColor(displayP3Red: 0.224, green: 0.298, blue: 0.357, alpha: 0)
        } else {
            navigationItem.setRightBarButton(addButton, animated: true)
            navigationItem.rightBarButtonItem?.tintColor = UIColor(displayP3Red: 0.961, green: 0.957, blue: 0.937, alpha: 1)
        }
        
        
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
//        playButton.backgroundColor = .white
//        cardView.backgroundColor = .white
//        cardView.layer.backgroundColor = UIColor(red: 0.192, green: 0.263, blue: 0.318, alpha: 0.9).cgColor
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
