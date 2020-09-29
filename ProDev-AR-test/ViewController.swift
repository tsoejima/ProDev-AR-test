//
//  ViewController.swift
//  ProDev-AR-test
//
//  Created by 副島拓哉 on 2020/09/28.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet var sceneView: ARSCNView!
    var selectedNode: SCNNode?
    var xyz: float_t = 0.2
    var x: float_t = 0.2
    var y: float_t = 0.2
    var z: float_t = 0.2
    var isFirst = true
    var times = true
    var count = 0
    let BoxNode = SCNNode()
    
    @IBAction func Slider(_ sender: UISlider) {
        label.text = String(x)
        x = Float(sender.value)
        BoxNode.geometry = SCNBox(width: CGFloat(self.x), height: CGFloat(self.y), length: CGFloat(self.z), chamferRadius: 0)
    }
    @IBAction func Slidery(_ sender: UISlider) {
        label2.text = String(y)
        y = Float(sender.value)
        BoxNode.geometry = SCNBox(width: CGFloat(self.x), height: CGFloat(self.y), length: CGFloat(self.z), chamferRadius: 0)
        BoxNode.position.y += abs(y - (y-0.0000001))
    }
    @IBAction func Sliderz(_ sender: UISlider) {
        label3.text = String(z)
        z = Float(sender.value)
        BoxNode.geometry = SCNBox(width: CGFloat(self.x), height: CGFloat(self.y), length: CGFloat(self.z), chamferRadius: 0)
    }
    enum CategoryBitMask: Int {
            case categoryToSelect = 2        // 010
            case otherCategoryToSelect = 4   // 100
            // you can add more bit masks below . . .
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        //sceneView.scene = scene
        
        // 特徴点を表示
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        // ライト追加
        sceneView.autoenablesDefaultLighting = true;
        
        // タップした時のaction追加
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapScreen)
        //ドラッグのアクション
        /*sceneView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.dragView(sender:))))*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        //平面認識
        configuration.planeDetection = .horizontal
        
        //configuration.environmentTexturing = .automatic

        // People Occlusion が使える端末か判定
        var message:String;
            if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
                    // People Occlusion を使用する
                configuration.frameSemantics = .personSegmentationWithDepth
                message = "Ok! This device supports people occulusion."
                } else {
                    message = "No! This device don't support people occulusion."
                }
                print("\(message)")

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if self.isFirst {
                self.isFirst = false
            }
            else if self.isFirst == false && self.times == true && self.count == 2{
                self.BoxNode.geometry = SCNBox(width: CGFloat(self.x), height: CGFloat(self.y), length: CGFloat(self.z), chamferRadius: 0)
                //self.BoxNode.position.y += Float(0.05)
                self.BoxNode.rotation = SCNVector4(0, 1, 0, 0)
                node.addChildNode(self.BoxNode)
                self.times = true
            }
        }
    }
    
    @objc func tapped(sender: UITapGestureRecognizer) {
        // タップされた位置のARアンカーを探す
        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)

        // タップした箇所が取得できていればアンカーを追加
        if !hitTest.isEmpty {
            count = 2
            let anchor = ARAnchor(transform: hitTest.first!.worldTransform)
            sceneView.session.add(anchor: anchor)
        }
    }
    /*@objc func dragView(sender: UIGestureRecognizer) {
            let tapPoint = sender.location(in: sceneView)
            
            let results = sceneView.hitTest(tapPoint, types: .existingPlane)
            if !results.isEmpty {
                if let result = results.first ,
                    let anchor = result.anchor ,
                    let BoxNode = sceneView.node(for: anchor) {
                    
                    DispatchQueue.main.async(execute: {
                        print("Success")
                        // 実世界の座標をSCNVector3で返したものを反映
                        self.BoxNode.position = SCNVector3(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
                        self.BoxNode.geometry = SCNBox(width: CGFloat(self.x), height: CGFloat(self.y), length: CGFloat(self.z), chamferRadius: 0)
                    })
                }
            }
        }*/

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
