//
//  ViewController.swift
//  Hana Music
//
//  Created by Hana Lee on 2015. 8. 10..
//  Copyright (c) 2015년 Hana Lee. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player:AVAudioPlayer?

    @IBOutlet weak var musicArtwork: UIImageView!
    
    @IBOutlet weak var musicTitle: UILabel!
    @IBOutlet weak var musicArtist: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var musicControlBar: UIToolbar!
    @IBOutlet weak var volumnController: UISlider!
    
    @IBOutlet weak var musicProgress: UIProgressView!
    @IBOutlet weak var playAndPauseButton: UIBarButtonItem!
    
    @IBAction func showMusicListButton(sender: AnyObject) {
    }
    @IBAction func changeVolumn(sender: AnyObject) {
        player!.volume = volumnController.value
    }
    
    var updater : CADisplayLink! = nil
    var playing = false
    
    @IBAction func playAndPauseButton(sender: AnyObject) {
        var pauseImage : UIImage = RBSquareImageTo(UIImage(named: "pause_button.png")!, size: CGSize(width: 40, height: 40))
        var playImage : UIImage = RBSquareImageTo(UIImage(named: "play_button.jpg")!, size: CGSize(width: 40, height: 40))

        var audioPath = audioList[activeIndex] as! String
        
        var name = split(audioPath) {$0 == "/"}
        let cnt = name.count
        var songName = name[cnt-1]
        
        musicTitle.text = songName
        musicArtist.text = songName
        
        var songTitle = songName.stringByReplacingOccurrencesOfString(".mp3", withString: "")
        
        var encodedPath = audioPath.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let audioPath2:NSURL! = NSBundle.mainBundle().URLForResource(songTitle, withExtension: "mp3")
        
        let playerItem = AVPlayerItem(URL: audioPath2)
        //        println(playerItem.asset.commonMetadata)
        
        var assets:AVURLAsset = AVURLAsset(URL: NSURL(string: encodedPath), options: nil)
        var metaData = assets.commonMetadata
        //        println(metaData)

        var artworks:NSArray = AVMetadataItem.metadataItemsFromArray(playerItem.asset.commonMetadata, withKey: AVMetadataCommonKeyArtwork, keySpace: AVMetadataKeySpaceCommon)
        var artwork:AVMetadataItem = artworks[0] as! AVMetadataItem
        
        if artwork.keySpace == AVMetadataKeySpaceID3 {
            var artworkImage:UIImage = UIImage(data: artwork.value as! NSData)!
            musicArtwork.image = artworkImage
        } else if artwork.keySpace == AVMetadataKeySpaceiTunes {
            
        }
        //        println(artworks)
        //        println(artworks.count)
        var titles : NSArray = AVMetadataItem.metadataItemsFromArray(assets.commonMetadata, withKey: AVMetadataCommonKeyTitle, keySpace: AVMetadataKeySpaceCommon)
        var artists:NSArray = AVMetadataItem.metadataItemsFromArray(assets.commonMetadata, withKey: AVMetadataCommonIdentifierArtist, keySpace: AVMetadataKeySpaceCommon)
        var albumName:NSArray = AVMetadataItem.metadataItemsFromArray(assets.commonMetadata, withKey: AVMetadataCommonKeyAlbumName, keySpace: AVMetadataKeySpaceCommon)
        
        //        println(titles)
        //        println(artists)
        //        println(albumName)
        
        var error : NSError? = nil
        
        if player == nil {
            player = AVAudioPlayer(contentsOfURL: NSURL(string: encodedPath), error: &error)
        }
        
        if error == nil {

            if let currentPlayer = player {
                playing = player!.playing;
            }
            
            if !playing {
                playAndPauseButton.setBackgroundImage(pauseImage, forState: .Normal, barMetrics: .Default)
                    player!.numberOfLoops = -1 // play indefinitely
                    player!.prepareToPlay()
//                    player.delegate = self
                    player!.play()
                
                let duration = player!.duration / 60
                let numberOfPlaces = 2.0
                let multiplier = pow(10.0, numberOfPlaces)
                let rounded = round(duration * multiplier) / multiplier
                var endTimeText:String = "\(rounded)"
                var newString = endTimeText.stringByReplacingOccurrencesOfString(".", withString: ":")
                println(count(newString))
                if count(newString) == 4 {
                    newString = "0" + newString
                }
                endTime.text = "\(newString)"
                    
                    updater = CADisplayLink(target: self, selector: ("updateSliderProgress"))
                    updater.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)

                
            } else {
                player!.pause()
                playAndPauseButton.setBackgroundImage(playImage, forState: .Normal, barMetrics: .Default)
//                updater.invalidate()
            }
            
//            playAndPauseButton.setBackgroundImage(pauseImage, forState: .Normal, barMetrics: .Default)
//            var audioDuration:CMTime = assets.duration
//            var audioDurationSeconds:Float64 = CMTimeGetSeconds(audioDuration)
//            startTime.text = NSString(format: "%.1f", audioDuration)
//            println(audioDurationSeconds)
//            player!.play()
        } else {
            println(error)
        }
    }
    func updateSliderProgress(){
        var progress:Double = player!.currentTime / player!.duration

        let numberOfPlaces = 2.0
        let multiplier = pow(10.0, numberOfPlaces)
        let rounded = round(progress * multiplier) / multiplier
        
        var startTimeText:String = "\(rounded)"
        var newString = startTimeText.stringByReplacingOccurrencesOfString(".", withString: ":")
        if count(newString) == 4 {
            newString = "0" + newString
        }
        
        startTime.text = "\(newString)"
        musicProgress.setProgress(Float(progress), animated: true)
//        timeSlider.setValue(Float(progress), animated: false)
    }
    
    @IBAction func forwardButton(sender: AnyObject) {
    }
    @IBAction func rewindButton(sender: AnyObject) {
    }
    @IBAction func shareButton(sender: AnyObject) {
    }
    
    func RBSquareImageTo(image: UIImage, size: CGSize) -> UIImage {
        return RBResizeImage(RBSquareImage(image), targetSize: size)
    }
    
    func RBSquareImage(image: UIImage) -> UIImage {
        var originalWidth  = image.size.width
        var originalHeight = image.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        var posX = (originalWidth  - edge) / 2.0
        var posY = (originalHeight - edge) / 2.0
        
        var cropSquare = CGRectMake(posX, posY, edge, edge)
        
        var imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
        return UIImage(CGImage: imageRef, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)!
    }

    
    func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        musicControlBar.clipsToBounds = true
        musicProgress.setProgress(0, animated: false)
        playAndPauseButton(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

