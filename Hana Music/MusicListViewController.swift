//
//  MusicListViewController.swift
//  Hana Music
//
//  Created by Hana Lee on 2015. 8. 10..
//  Copyright (c) 2015년 Hana Lee. All rights reserved.
//

import UIKit
import AVFoundation

var activeIndex:Int = -1
var audioList = NSBundle.mainBundle().pathsForResourcesOfType("mp3", inDirectory: "")

class MusicListViewController: UIViewController, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 1
//    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return audioList.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("musicCell", forIndexPath: indexPath) as! UITableViewCell
//        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "musicCell")
        
        
        let fileName = audioList[indexPath.row] as! String
        
        var name = split(fileName) {$0 == "/"}
        let cnt = name.count
        var songName = name[cnt-1]
        
        cell.textLabel?.text = songName
        
        let albumArtWork:UIImage = getArtwork(indexPath.row)
        cell.imageView!.image = albumArtWork
        let albumName:String  = getAlbumName(indexPath.row)

        cell.detailTextLabel?.text = albumName
        
        return cell
    }
    
    func getAlbumName(index: Int) -> String {
        var audioPath = audioList[index] as! String
        
        var name = split(audioPath) {$0 == "/"}
        let cnt = name.count
        var songName = name[cnt-1]
        
        var songTitle = songName.stringByReplacingOccurrencesOfString(".mp3", withString: "")
        
        var encodedPath = audioPath.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let audioPath2:NSURL! = NSBundle.mainBundle().URLForResource(songTitle, withExtension: "mp3")
        
        let playerItem = AVPlayerItem(URL: audioPath2)
        //        println(playerItem.asset.commonMetadata)
        
        var assets:AVURLAsset = AVURLAsset(URL: NSURL(string: encodedPath), options: nil)
        var metaData = assets.commonMetadata

        var albumNames = AVMetadataItem.metadataItemsFromArray(playerItem.asset.commonMetadata, withKey: AVMetadataCommonKeyAlbumName, keySpace: AVMetadataKeySpaceCommon)

        var albumNameItem:AVMetadataItem = albumNames[0] as! AVMetadataItem

        var albumName:String?
        if albumNameItem.keySpace == AVMetadataKeySpaceID3 {
            albumName = albumNameItem.value as? String
        } else if albumNameItem.keySpace == AVMetadataKeySpaceiTunes {
            
        }
        
        return albumName!
    }
    
    func getArtwork(index : Int) -> UIImage {
        var audioPath = audioList[index] as! String
        
        var name = split(audioPath) {$0 == "/"}
        let cnt = name.count
        var songName = name[cnt-1]
        
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
        
        var artworkImage:UIImage?
        if artwork.keySpace == AVMetadataKeySpaceID3 {
            artworkImage = UIImage(data: artwork.value as! NSData)!
        } else if artwork.keySpace == AVMetadataKeySpaceiTunes {
            
        }
        
        return artworkImage!
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        activeIndex = indexPath.row
        return indexPath
    }
}
