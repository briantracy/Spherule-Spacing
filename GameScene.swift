//
//  GameScene.swift
//  spherule-spacing
//
//  Created by Brian Tracy on 8/6/18.
//  Copyright © 2018 Brian Tracy. All rights reserved.
//

import Foundation
import SpriteKit

struct GameData {
    var ballsThrown: Int
    var currentlyThrowing: Bool
    var currentlyZoomed: Bool
    let timer: Timer
    var startTime: UInt64?
}

struct Nodes {
    var obstacles: [SKNode]
    var balls: [SKNode]
    let tip: SKNode
    let tail: SKNode
    let line: SKShapeNode
    let timerLabel: SKLabelNode
    let camera: SKCameraNode
}

struct PhysicsConstants {
    static let ballContactBitMask = UInt32(1)
    static let wallContactBitMask = UInt32(2)
    static let obstacleContactBitMask = UInt32(3)
}

class GameScene: SKScene {
    
    
    private var nodes: Nodes!
    
    private var gameData: GameData!
    
    
    
    override func sceneDidLoad() {
        backgroundColor = Settings.colorScheme.value.backgroundColor

        
        loadScene()

    }
    
    private func loadScene() {
        initGameData()
        initNodes()
        initPhysicsWorld()
        listenToRestartTouch()
        placeObstacles()
    }
    private func unloadScene() {
        nodes.obstacles.forEach { $0.removeFromParent() }
        nodes.balls.forEach { $0.removeFromParent() }
        nodes.obstacles.removeAll()
        nodes.balls.removeAll()
        removeChildren(in: [nodes.tip, nodes.tail, nodes.line, nodes.timerLabel, nodes.camera])
    }
    
    override func didMove(to view: SKView) {
        scaleMode = .aspectFill

        

    }

    func throwBall() {
        let tip = nodes.tip.position
        let tail = nodes.tail.position
        gameData.ballsThrown += 1
        let rawVector = CGVector(dx: tip.x - tail.x, dy: tip.y - tail.y)
        let b = createBall()
        b.position = tail
        b.physicsBody?.velocity = rawVector.fixLength(to: Settings.ballVelocity.value)
        addChild(b)
        nodes.balls.append(b)
    }
}

extension GameScene /* Initializers */ {
    private func initGameData() {
        gameData = GameData(ballsThrown: 0, currentlyThrowing: false,
                            currentlyZoomed: false, timer: createTimer(),
                            startTime: nil)
    }
    private func initNodes() {
        nodes = Nodes(obstacles: [SKNode](), balls: [SKNode](), tip: createTip(),
                      tail: createTail(), line: createDashedLine(),
                      timerLabel: createTimerLabel(), camera: createCamera())
        
        startTimer()
        addChild(nodes.tip)
        addChild(nodes.tail)
        addChild(nodes.line)
        addChild(nodes.timerLabel)
        addChild(nodes.camera)
        self.camera = nodes.camera
    }
    
    private func initPhysicsWorld() {
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.friction = 0
        physicsBody?.contactTestBitMask = PhysicsConstants.wallContactBitMask
    }
}

extension GameScene /* Node Creation */ {
    
    private func createBall() -> SKShapeNode {
        let n = SKShapeNode(circleOfRadius: Settings.ballRadius.value)
        n.fillColor = Settings.colorScheme.value.ballFillColor
        n.strokeColor = Settings.colorScheme.value.ballStrokeColor
        n.physicsBody = SKPhysicsBody(circleOfRadius: Settings.ballRadius.value)
        n.physicsBody?.friction = 0
        n.physicsBody?.restitution = 1
        n.physicsBody?.angularDamping = 0
        n.physicsBody?.linearDamping = 0
        n.physicsBody?.angularDamping = 0
        n.physicsBody?.contactTestBitMask = PhysicsConstants.ballContactBitMask
        return n
    }
    
    private func createObstacle() -> SKShapeNode {
        let obstacleSize = CGSize(width: randInRange(Settings.obstacleMinWidth.value, Settings.obstacleMaxWidth.value),
                                  height: randInRange(Settings.obstacleMinHeight.value, Settings.obstacleMaxHeight.value))
        let n = SKShapeNode(rectOf: obstacleSize)
        n.fillColor = Settings.colorScheme.value.obstacleFillColor
        n.strokeColor = Settings.colorScheme.value.obstacleStrokeColor
        n.physicsBody = SKPhysicsBody(rectangleOf: obstacleSize)
        n.physicsBody?.isDynamic = false
        return n
    }
    
    private func createTail() -> SKShapeNode {
        let n = SKShapeNode(circleOfRadius: Settings.tailMarkerRadius.value)
        n.fillColor = Settings.colorScheme.value.tailMarkerFillColor
        n.strokeColor = Settings.colorScheme.value.tailMarkerStrokeColor
        n.alpha = 0
        return n
    }
    
    private func createTip() -> SKShapeNode {
        let n = SKShapeNode(circleOfRadius: Settings.tipMarkerRadius.value)
        n.fillColor = Settings.colorScheme.value.tipMarkerFillColor
        n.strokeColor = Settings.colorScheme.value.tipMarkerStrokeColor
        n.alpha = 0
        return n
    }
    
    private func createDashedLine() -> SKShapeNode {
        let p = UIBezierPath()
        //        p.move(to: nodes.tail.position)
        //        p.addLine(to: nodes.tip.position)
        
        let j =     p.cgPath         //p.cgPath.copy(dashingWithPhase: 0, lengths: [2, 3])
        
        let n = SKShapeNode(path: j)
        n.fillColor = .red
        n.strokeColor = UIColor.red
        n.lineWidth = 3
        //
        //        n.fillColor = Settings.colorScheme.value.connectingLineColor
        n.alpha = 0
        // n.position = nodes.tail.position
        return n
    }
    
    private func createTimerLabel() -> SKLabelNode {
        let n = SKLabelNode()
        n.fontName = "Menlo"
        n.position = UIScreen.center
        n.fontColor = .green
        return n
    }
    
    private func createCamera() -> SKCameraNode {
        let n = SKCameraNode()
        n.position = CGPoint(x: UIScreen.width / 2, y: UIScreen.height / 2)
        return n
    }
    
}



extension GameScene /* Touch Delegates */ {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self)
            gameData.currentlyThrowing = canPlaceBall(at: loc)
            guard gameData.currentlyThrowing else { return }
            nodes.tail.position = loc
            fadeInTail()
            fadeInLine()
            self.physicsWorld.speed /= Settings.timeSlowdownFactorWhenThrowing.value
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard gameData.currentlyThrowing else { return }
        if let touch = touches.first {
            nodes.tip.position = touch.location(in: self)
            fadeInTipMarker()
            updateLinePosition()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard gameData.currentlyThrowing else { return }
        if let touch = touches.first {
            nodes.tip.position = touch.location(in: self)
            self.physicsWorld.speed *= Settings.timeSlowdownFactorWhenThrowing.value
            if canThrowBall() { throwBall() }
            fadeOutTipMarker()
            fadeOutLine()
        }
    }
    
    private func listenToRestartTouch() {
        let gest = UITapGestureRecognizer(target: self, action: #selector(restartTap))
        gest.numberOfTouchesRequired = 2
        gest.numberOfTapsRequired = 1
        view?.addGestureRecognizer(gest)
    }
    
    @objc func restartTap() {
        
    }
}

extension GameScene /* Animation */ {
    private static let fadeIn = SKAction.fadeIn(withDuration: 1)
    private static let fadeOut = SKAction.fadeOut(withDuration: 1)
    
    private func fadeOutTipMarker() {
        nodes.tip.run(GameScene.fadeOut)
    }
    private func fadeInTipMarker() {
        nodes.tip.run(GameScene.fadeIn)
    }
    private func fadeOutLine() {
        nodes.line.run(GameScene.fadeOut)
    }
    private func fadeInLine() {
        nodes.line.run(GameScene.fadeIn)
    }
    private func fadeInTail() {
        nodes.tail.run(GameScene.fadeIn)
    }
}

extension GameScene /* Node Placement */ {
    
    func placeObstacles() {
        for _ in 0 ..< Settings.numberOfObstacles.value {
            placeObstacle()
        }
    }
    
    private func placeObstacle() {
        let obs = createObstacle()
        nodes.obstacles.append(obs)
        let xInset = Settings.obstacleMaxWidth.value
        let yInset = Settings.obstacleMaxHeight.value
        let position = CGPoint(x: randInRange(xInset, Int(UIScreen.width) - xInset),
                               y: randInRange(yInset, Int(UIScreen.height) - yInset))
        addChild(obs)
        obs.position = position
    }
    
    private func canPlaceBall(at: CGPoint) -> Bool {
        for obs in nodes.obstacles {
            if obs.contains(at) {
                return false
            }
        }
        return true
    }
    
    private func canThrowBall() -> Bool {
        return distance(from: nodes.tip.position, to: nodes.tail.position) > CGFloat(1)
    }
    
    private func updateLinePosition() {
        //removeChildren(in: [nodes.line])
        let path = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: nodes.tip.position - nodes.tail.position)
        nodes.line.path = path.cgPath.copy(dashingWithPhase: 0, lengths: [2, 3])
        
        nodes.line.strokeColor = Settings.colorScheme.value.connectingLineColor
        nodes.line.fillColor = Settings.colorScheme.value.connectingLineColor
        nodes.line.position = nodes.tail.position
        //addChild(nodes.line)
    }
}





extension GameScene /* Timer */ {
    
    private func createTimer() -> Timer {
        return Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            self?.updateTimer()
        })
    }
    private func startTimer() {
        gameData.startTime = mach_absolute_time()
        gameData.timer.fire()
    }
    private func updateTimer() {
        guard let startTime = gameData.startTime else { return }
        let elapsedInSeconds = Float64((mach_absolute_time() - startTime)) / Float64(NSEC_PER_SEC)
        let str = String(format: "%.1f", elapsedInSeconds) // ex: 4.2
        nodes.timerLabel.text = str
    }
    private func stopTimer() {
        
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.contactTestBitMask == contact.bodyB.contactTestBitMask {
            physicsWorld.speed /= 20
            print(contact.bodyA.contactTestBitMask)
            let loc = contact.bodyB.node!.position
            let moveAction = SKAction.move(to: loc, duration: 0.25)
            let zoom = SKAction.scale(to: 0.5, duration: 0.25)
            let group = SKAction.group([moveAction, zoom])
            camera?.run(group) {
                let moveAction = SKAction.move(to: CGPoint(x: UIScreen.width / 2, y: UIScreen.height / 2), duration: 0.25)
                let zoom = SKAction.scale(to: 1, duration: 0.25)
                let group = SKAction.group([moveAction, zoom])
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.camera?.run(group)
                    self.physicsWorld.speed *= 20
                    self.unloadScene()
                    self.loadScene()
                }
                
            }

        }
//        physicsWorld.speed /= 10
//        print("contact" )
//
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
}
