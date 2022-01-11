//
//  ShareViewController.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/4/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
// DISCLAIMER: LOTS OF CODE USED IN THIS PROJECT COMES FROM THE SWIFTYCAM DEMO. THE addButtons(), toggleCamera(), switchCamera(), AND ALL IMAGE ASSETS COME FROM THAT DEVELOPER.

import UIKit
import SwiftyCam
import AVFoundation
import AVKit
import Parse

class ShareViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate, SWRevealViewControllerDelegate  {
    
    var flipCameraButton: UIButton!
    var flashButton: UIButton!
    var captureButton: SwiftyRecordButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rVC = self.revealViewController()
        if (rVC != nil) {
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu_icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
            
            self.revealViewController().rearViewRevealWidth = ((self.view.bounds.size.height - UIApplication.shared.statusBarFrame.size.height) / 7) + 16
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().delegate = self
            self.revealViewController().rearViewRevealOverdraw = 0.0
            self.revealViewController().rearViewRevealDisplacement = 0.0
        }
        
        let homeImageView = UIImageView(image: #imageLiteral(resourceName: "share_navbar_icon"))
        self.navigationItem.titleView = homeImageView
        
        
        videoQuality = .high
        cameraDelegate = self
        print(flashEnabled)
        maximumVideoDuration = 16.0
        
        addBlurViews()
        
        addButtons()
        
        
    }
    
    func addBlurViews() {
        let viewPortTop = view.bounds.size.height / 2 - view.bounds.size.width / 2
        let viewPortBottom = view.bounds.size.height / 2 + view.bounds.size.width / 2
        
        let topView = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: viewPortTop))
        let bottomView = UIVisualEffectView(frame: CGRect(x: 0, y: viewPortBottom, width: view.bounds.size.width, height: view.bounds.size.height - viewPortBottom))
        
        let blurEffect = UIBlurEffect(style: .regular)
        
        topView.effect = blurEffect
        bottomView.effect = blurEffect
        
        topView.backgroundColor = UIColor.init(hex: PFUser.current()?.value(forKey: "interface_color") as! String).withAlphaComponent(0.5)
        bottomView.backgroundColor = UIColor.init(hex: PFUser.current()?.value(forKey: "interface_color") as! String).withAlphaComponent(0.5)
        
        self.view.addSubview(topView)
        self.view.addSubview(bottomView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        // Called when takePhoto() is called or if a SwiftyCamButton initiates a tap gesture
        // Returns a UIImage captured from the current session
        print("took photo")
        print(photo.size)
        let cropped = photo.squared
        print(cropped?.size as Any)
        self.performSegue(withIdentifier: "postPhoto", sender: photo)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when startVideoRecording() is called
        // Called if a SwiftyCamButton begins a long press gesture
        print("Did Begin Recording")
        captureButton.growButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        // Called when stopVideoRecording() is called
        // Called if a SwiftyCamButton ends a long press gesture
        print("Did finish Recording")
        captureButton.shrinkButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        // Called when stopVideoRecording() is called and the video is finished processing
        // Returns a URL in the temporary directory where video is stored
        print("finished processing")
        print(url)
        //cropVideoToSquare(at: url)
        self.performSegue(withIdentifier: "videoConfirmation", sender: url)
    }
    
    func cropVideoToSquare(at url: URL) {
        
        let asset = AVAsset(url: url)
        let clipVideoTrack = asset.tracks(withMediaType: AVMediaTypeVideo)[0]
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.frameDuration = CMTime(seconds: 1, preferredTimescale: 60)
        videoComposition.renderSize = CGSize(width: clipVideoTrack.naturalSize.width, height: clipVideoTrack.naturalSize.width)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: kCMTimeZero, duration: CMTime(seconds: 60, preferredTimescale: 60))
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
        
        let t1 = CGAffineTransform(translationX: clipVideoTrack.naturalSize.height, y: -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2.0)
        let t2 = t1.rotated(by: CGFloat.pi / 2.0)
        
        let finalTransformation = t2
        transformer.setTransform(finalTransformation, at: kCMTimeZero)
        
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]
        
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        exporter?.videoComposition = videoComposition
        exporter?.outputURL = url
        exporter?.outputFileType = AVFileTypeQuickTimeMovie
        
        exporter?.exportAsynchronously(completionHandler: { 
            DispatchQueue.main.async {
                self.exportFinished(at: exporter!.outputURL!)
            }
        })
    }
    
    func exportFinished(at url: URL) {
        self.performSegue(withIdentifier: "videoConfirmation", sender: url)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        // Called when a user initiates a tap gesture on the preview layer
        // Will only be called if tapToFocus = true
        // Returns a CGPoint of the tap location on the preview layer
        
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }, completion: { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }, completion: { (success) in
                focusView.removeFromSuperview()
            })
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        // Called when a user initiates a pinch gesture on the preview layer
        // Will only be called if pinchToZoomn = true
        // Returns a CGFloat of the current zoom level
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        // Called when user switches between cameras
        // Returns current camera selection
    }

    func addButtons() {
        captureButton = SwiftyRecordButton(frame: CGRect(x: view.frame.midX - 37.5, y: view.frame.height - 100.0, width: 75.0, height: 75.0))
        self.view.addSubview(captureButton)
        captureButton.delegate = self
        
        flipCameraButton = UIButton(frame: CGRect(x: (((view.frame.width / 2 - 37.5) / 2) - 15.0), y: view.frame.height - 74.0, width: 30.0, height: 23.0))
        flipCameraButton.setImage(#imageLiteral(resourceName: "flipCamera"), for: UIControlState())
        flipCameraButton.addTarget(self, action: #selector(cameraSwitchAction(_:)), for: .touchUpInside)
        self.view.addSubview(flipCameraButton)
        
        let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) + ((view.frame.width / 2) - 37.5) - 9.0)
        
        flashButton = UIButton(frame: CGRect(x: test, y: view.frame.height - 77.5, width: 18.0, height: 30.0))
        flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
        flashButton.addTarget(self, action: #selector(toggleFlashAction(_:)), for: .touchUpInside)
        self.view.addSubview(flashButton)
    }
    
    func cameraSwitchAction(_ sender: Any) {
        switchCamera()
    }
    
    func toggleFlashAction(_ sender: Any) {
        flashEnabled = !flashEnabled
        
        if flashEnabled == true {
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControlState())
        } else {
            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "postPhoto" {
            let dest = segue.destination as! PostPictureViewController
            dest.imageToPost = sender as? UIImage
        } else if segue.identifier == "videoConfirmation" {
            let dest = segue.destination as! PostVideoViewController
            dest.videoUrl = sender as? URL
        }
    }
    
    @IBAction func unwindToShare(segue: UIStoryboardSegue) {
    }
}
