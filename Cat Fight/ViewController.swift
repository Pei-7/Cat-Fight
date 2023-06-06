//
//  ViewController.swift
//  Cat Fight
//
//  Created by 陳佩琪 on 2023/6/5.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var meowPlayer: AVAudioPlayer?
    
    
    let themeNavy = UIColor(red: 5/255, green: 3/255, blue: 15/255, alpha: 1)
    let themeLight = UIColor(red: 127/255, green: 130/255, blue: 238/255, alpha: 1)
    let themeYellow = UIColor(red: 252/255, green: 191/255, blue: 73/255, alpha: 1)
    
    @IBOutlet var fightView: UIView!
    @IBOutlet var stageImageView: UIImageView!
    
    
    var playerName = UILabel()
    var computerName = UILabel()
    
    var playerIcon = UIImageView()
    var computerIcon = UIImageView()
    var playerHPBar = UIProgressView()
    var computerHPBar = UIProgressView()
    var playerHPLabel = UILabel()
    var computerHPLabel = UILabel()
    var playerDeductHPLabel = UILabel()
    var computerDeductHPLabel = UILabel()
    var playerHP = 100
    var computerHP = 100
    var deductHP: Int = 0
    
    let roundLabel = UILabel()
    let cornerRoundProgress = UILabel()
    var round = 1
    
    
    let catFightGif = UIImageView()
    let playerCardView = UIView()
    let nextButton = UIButton()
    let confirmButton = UIButton()
    let replayButton = UIButton()
    
    var computerSign = String()
    var playerSign = String()
    
    
    var playerCardButtons :[UIButton] = []
    var computerCardLabels :[UILabel] = []
    var cardsOnHand :[Sign] = []
    var playerCardsSelected :[UIButton] = []
    var computerCardsSelected :[UILabel] = []
    
    var computerSelectedSign :[UILabel] = []
    
    
    
    
    
    fileprivate func playerStatus(name: UILabel, nameX: Double, nameY: Double, icon: UIImageView,iconX: Double, iconY: Double,iconName: String, bar: UIProgressView, barX: Double, barY: Double, label: UILabel, labelX: Double, labelY: Double, hpLabel: UILabel, hpX: Double, hpY: Double) {
        //catFightGif.isHidden = true
        
        name.frame = CGRect(x: nameX, y: nameY, width: 100, height: 35)
        name.font = UIFont.boldSystemFont(ofSize: 18)
        name.textColor = UIColor.white
        name.textAlignment = .center
        fightView.addSubview(name)
        
        icon.frame = CGRect(x: iconX, y: iconY, width: 80, height: 80)
        icon.image = UIImage(named: iconName)
        icon.contentMode = .scaleToFill
        icon.layer.cornerRadius = 40
        icon.clipsToBounds = true
        fightView.addSubview(icon)
        
        bar.frame = CGRect(x: barX, y: barY, width: 200, height: 16)
        bar.progressTintColor = themeYellow
        bar.backgroundColor = UIColor(white: 1, alpha: 0.4)
        bar.progressViewStyle = .bar
        fightView.addSubview(bar)
        
        label.frame = CGRect(x: labelX, y: labelY, width: 32, height: 32)
        label.textColor = themeYellow
        label.font = UIFont.boldSystemFont(ofSize: 18)
        fightView.addSubview(label)
        
        hpLabel.frame = CGRect(x: hpX, y: hpY, width: 120, height: 60)
        //hpLabel.text = "-24HP" //測試用待刪
        hpLabel.font = UIFont.boldSystemFont(ofSize: 22)
        hpLabel.textColor = UIColor.red
        //hpLabel.transform = CGAffineTransform(rotationAngle: .pi/190 * -8)
        fightView.addSubview(hpLabel)
        
        
    }
    
    fileprivate func generateComputerCards() {
        

        for i in 1...5 {
            let pokerBackLabel = UILabel(frame: CGRect(x: 27 + 45*(i-1), y: 105, width: 62, height: 87))
            pokerBackLabel.text = "😺"
            pokerBackLabel.font = UIFont.systemFont(ofSize: 48)
            pokerBackLabel.textAlignment = .center
            pokerBackLabel.backgroundColor = themeYellow
            pokerBackLabel.layer.borderWidth = 4
            pokerBackLabel.layer.borderColor = UIColor.white.cgColor
            pokerBackLabel.layer.cornerRadius = 8
            pokerBackLabel.clipsToBounds = true
            fightView.addSubview(pokerBackLabel)
            computerCardLabels.append(pokerBackLabel)
        }
    }
    
    fileprivate func refreshStatus() {
        
        playerHPBar.progress = Float(playerHP)/100
        playerHPLabel.text = String(playerHP)
        computerHPBar.progress = Float(computerHP)/100
        computerHPLabel.text = String(computerHP)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = fightView.bounds
        gradientLayer.colors = [themeLight.cgColor,themeNavy.cgColor,themeNavy.cgColor,themeLight.cgColor]
        gradientLayer.locations = [0,0.32,0.62,1]
        fightView.layer.addSublayer(gradientLayer)
        
        catFightGif.frame = CGRect(x: 44, y: 292, width: 320, height: 180)
        fightView.addSubview(catFightGif)
        
        roundLabel.frame = CGRect(x: 18, y: 12, width: 280, height: 160)
        roundLabel.text = "Round \(round)"
        roundLabel.textColor = themeYellow
        roundLabel.font = UIFont.boldSystemFont(ofSize: 36)
        roundLabel.textAlignment = .center
        catFightGif.addSubview(roundLabel)
        
        catFightGif.addSubview(stageImageView)
        stageImageView.frame = CGRect(x: -108, y: -24, width: 508, height: 251)
        
        cornerRoundProgress.frame = CGRect(x: 276, y:-31, width: 60, height: 45)
        cornerRoundProgress.text = "\(round) / 5"
        cornerRoundProgress.textColor = themeLight
        cornerRoundProgress.textAlignment = .right
        catFightGif.addSubview(cornerRoundProgress)
        
        
        //player
        playerStatus(name: playerName, nameX: 8, nameY: 694, icon: playerIcon,iconX: 18, iconY: 724, iconName: "milky",bar: playerHPBar, barX: 116, barY: 788, label: playerHPLabel, labelX: 328, labelY: 772, hpLabel: playerDeductHPLabel, hpX: 100, hpY: 420)
        playerName.text = "You"
        
        //computer
        playerStatus(name: computerName, nameX: 278, nameY: 151, icon: computerIcon,iconX:292 , iconY: 75, iconName: "blacky", bar:computerHPBar,barX: 74, barY: 81, label:computerHPLabel , labelX: 30, labelY: 69, hpLabel: computerDeductHPLabel, hpX: 212, hpY: 296)
        computerName.text = "Computer"
        computerHPBar.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        
        refreshStatus()
        
        
        playerCardView.frame = CGRect(x: 0, y: 544, width: 390, height: 300)
        fightView.addSubview(playerCardView)
        
        
        for i in 1...5 {
            let card = UIButton(type: .system)
            card.addAction(UIAction(handler:  { [self, weak card] _ in
                buttonTapped(card!)
            }), for: .touchUpInside)
            card.titleLabel?.font = UIFont.systemFont(ofSize: 48)
            playerCardView.addSubview(card)
            card.frame = CGRect(x: 24 + 70 * (i - 1), y: 50, width: 62, height: 87)
            card.backgroundColor = UIColor.white
            card.layer.cornerRadius = 8
            card.clipsToBounds = true
            playerCardButtons.append(card)
        }
        //print("allCards",playerCardButtons,playerCardButtons.count)
        
        for card in playerCardButtons {
            let sign = randomSign()
            card.setTitle(sign.emoji, for: .normal)
            cardsOnHand.append(sign)
        }
        
        generateComputerCards()
        
        confirmButton.frame = CGRect(x: 233, y: 169, width: 134, height: 40)
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.backgroundColor = themeYellow
        confirmButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        confirmButton.layer.cornerRadius = 5
        confirmButton.clipsToBounds = true
        playerCardView.addSubview(confirmButton)
        
        confirmButton.addAction(UIAction(handler:  { [self, weak confirmButton] _ in
            confirmCards(confirmButton!)
        }), for: .touchUpInside)
        confirmButton.isEnabled = false
        
        
        nextButton.frame = CGRect(x: 233, y: 169, width: 134, height: 40)
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = themeYellow
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        nextButton.layer.cornerRadius = 5
        nextButton.clipsToBounds = true
        playerCardView.addSubview(nextButton)
        
        nextButton.addAction(UIAction(handler:  { [self, weak nextButton] _ in
            goToNext(nextButton!)
        }), for: .touchUpInside)
        nextButton.isHidden = true
        
        
        replayButton.frame = CGRect(x: 120, y: 85, width: 150, height: 45)
        replayButton.setTitle("Play Again", for: .normal)
        replayButton.backgroundColor = themeYellow
        replayButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        //replayButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        replayButton.layer.cornerRadius = 5
        replayButton.clipsToBounds = true
        playerCardView.addSubview(replayButton)
        
        replayButton.addAction(UIAction(handler:  { [self, weak replayButton] _ in
            replay(replayButton!)
        }), for: .touchUpInside)
        replayButton.isHidden = true
        
        
        
        let meowSound = Bundle.main.url(forResource: "meow", withExtension: "mp3")!
        do {
            meowPlayer = try AVAudioPlayer(contentsOf: meowSound)
                } catch {
                    print("meow sound: \(error)")
                }
        
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        playerCardsSelected.removeAll()
        
        for card in playerCardButtons {
            card.transform = CGAffineTransform(translationX: 0, y: 0)
            
            playerSign = sender.currentTitle!
            if card.currentTitle == playerSign {
                card.transform = CGAffineTransform(translationX: 0, y: -16)
                playerCardsSelected.append(card)
            }
        }
        confirmButton.isEnabled = true
        //print(playerCardsSelected.count)
    }
    
    
    
    @objc func confirmCards(_ sender: UIButton) {
        
        //player cards
        for card in playerCardsSelected {
            card.transform = CGAffineTransform(translationX: 0, y: -72)
            cardsOnHand.removeAll(where: {$0.emoji == card.currentTitle})
        }
        
        for card in playerCardButtons {
            card.isEnabled = false
        }
        
        //gif
        var catFightImages = [UIImage]()
        for i in 0...21 {
            catFightImages.append(UIImage(named: "cat fight-\(i)")!)
        }
        catFightGif.animationImages = catFightImages
        catFightGif.animationDuration = 2
        catFightGif.animationRepeatCount = 3
        catFightGif.startAnimating()
        
        //computer cards
        computerSign = randomSign().emoji
        for (index, label) in computerCardLabels.enumerated() {
            
            let cardArray = [0,1,2,3,4]
            let randomCount = Int.random(in: 1...5)
            let computerSelectedArray = cardArray.shuffled().prefix(randomCount)
            
            for cardNumber in computerSelectedArray {
                if index == cardNumber {
                    label.text = computerSign
                    label.backgroundColor = UIColor.white
                    label.transform = CGAffineTransform(translationX: 0, y: 72)
                    computerCardsSelected.append(label)
                }
            }
        }
        
        confirmButton.isHidden = true
        nextButton.isHidden = false
        roundLabel.text = ""
        
        
        //計算HP!
        
        let playerCardCount = Float(playerCardsSelected.count)
        let computerCardCount = Float(computerCardsSelected.count)
        //print("player",playerCardCount,"computer",computerCardCount)
        
        
        if playerSign != computerSign {
            if (playerSign == Sign.rock.emoji && computerSign == Sign.scissors.emoji) ||
                (playerSign == Sign.paper.emoji && computerSign == Sign.rock.emoji) ||
                (playerSign == Sign.scissors.emoji && computerSign == Sign.paper.emoji) {
                calculateDeduction(winner: playerCardCount, loser: computerCardCount, loserLabel: computerDeductHPLabel, deductComputer: true)
            } else {
                calculateDeduction(winner: computerCardCount, loser: playerCardCount, loserLabel: playerDeductHPLabel, deductComputer: false)
            }
        } else {
            var theBigger = playerCardCount
            var theSmaller = computerCardCount
            
            if computerCardCount > playerCardCount {
                theBigger = computerCardCount
                theSmaller = playerCardCount
            }
            
            let calculateDeduction = theBigger * 5 - theSmaller * 4.8
            deductHP = Int(calculateDeduction.rounded())
            
            if theBigger != theSmaller {
                switch theBigger {
                case playerCardCount:
                    computerDeductHPLabel.text = "-\(deductHP)HP"
                    computerHP -= deductHP
                default:
                    playerDeductHPLabel.text = "-\(deductHP)HP"
                    playerHP -= deductHP
                }
            } else {
                deductHP = 5
                computerDeductHPLabel.text = "-\(deductHP)HP"
                computerHP -= deductHP
                playerDeductHPLabel.text = "-\(deductHP)HP"
                playerHP -= deductHP
            }
        }
        
        refreshStatus()
        
        //print(deductHP,"player",playerHP,playerSign,"computer",computerHP,computerSign)
        //print(computerCardLabels.count)
        
        if round == 5 {
            nextButton.setTitle("Final Result", for: .normal)
        } else {
            nextButton.setTitle("Next", for: .normal)
        }
        
        
        
        meowPlayer!.numberOfLoops = 2
        meowPlayer!.currentTime = 0
        meowPlayer!.play()

        
    }
    
    
    @objc func goToNext(_ sender: UIButton) {
        
        meowPlayer!.stop()
        
        
        print(cardsOnHand.count)
                
        while cardsOnHand.count < 5 {
            let sign = randomSign()
            cardsOnHand.append(sign)
        }
        for (index, card) in playerCardButtons.enumerated() {
            card.setTitle(cardsOnHand[index].emoji, for: .normal)
            card.transform = CGAffineTransform(translationX: 0, y: 0)
            card.isEnabled = true
        }
        
        for label in computerCardLabels {
            label.removeFromSuperview()
        }
        computerCardLabels.removeAll()
        computerCardsSelected.removeAll()
        generateComputerCards()
        
        
        catFightGif.stopAnimating()
        confirmButton.isHidden = false
        confirmButton.isEnabled = false
        nextButton.isHidden = true
        
        computerDeductHPLabel.text = ""
        playerDeductHPLabel.text = ""
        

        
        if round < 5 {
            round += 1
            roundLabel.text = "Round\(round)"
            cornerRoundProgress.text = "\(round) / 5"
            
        } else {
            
            if playerHP > computerHP {
                roundLabel.text = "👑\nYou Won!"
            } else {
                roundLabel.text = "🪦\nYou Lost!"
            }
            
            roundLabel.numberOfLines = 0
            roundLabel.font = UIFont.systemFont(ofSize: 36)
            roundLabel.transform = CGAffineTransform(rotationAngle: .pi/180 * 0)
            
            for card in playerCardButtons {
                card.removeFromSuperview()
            }
            
            for label in computerCardLabels {
                label.removeFromSuperview()
            }
            cardsOnHand.removeAll()
            confirmButton.isHidden = true
            replayButton.isHidden = false
            
            playerName.isHidden = true
            computerName.isHidden = true
            playerIcon.isHidden = true
            computerIcon.isHidden = true
            playerHPBar.isHidden = true
            computerHPBar.isHidden = true
            playerHPLabel.isHidden = true
            computerHPLabel.isHidden = true
            playerDeductHPLabel.isHidden = true
            computerDeductHPLabel.isHidden = true
            
            
        }
    }
        
        
        
        func calculateDeduction(winner: Float, loser:Float, loserLabel: UILabel, deductComputer: Bool) {
            let calculateDeduction = winner * 5 - loser * 0.8
            deductHP = Int(calculateDeduction.rounded())
            loserLabel.text = "-\(deductHP)HP"
            if deductComputer == true {
                computerHP -= deductHP
            }else{
                playerHP -= deductHP
            }
            
        }
    
    
    
    @objc func replay(_ sender: UIButton) {
        
        round = 1
        roundLabel.text = "Round \(round)"
        cornerRoundProgress.text = "\(round) / 5"
        
        playerName.isHidden = false
        computerName.isHidden = false
        playerIcon.isHidden = false
        computerIcon.isHidden = false
        playerHPBar.isHidden = false
        computerHPBar.isHidden = false
        playerHPLabel.isHidden = false
        computerHPLabel.isHidden = false
        playerDeductHPLabel.isHidden = false
        computerDeductHPLabel.isHidden = false
        
        playerHP = 100
        computerHP = 100
        refreshStatus()
        playerCardButtons.removeAll()
        
        for i in 1...5 {
            let card = UIButton(type: .system)
            card.addAction(UIAction(handler:  { [self, weak card] _ in
                buttonTapped(card!)
            }), for: .touchUpInside)
            card.titleLabel?.font = UIFont.systemFont(ofSize: 48)
            playerCardView.addSubview(card)
            card.frame = CGRect(x: 24 + 70 * (i - 1), y: 50, width: 62, height: 87)
            card.backgroundColor = UIColor.white
            card.layer.cornerRadius = 8
            card.clipsToBounds = true
            playerCardButtons.append(card)
            print(i)
        }
        
        for card in playerCardButtons {
            let sign = randomSign()
            card.setTitle(sign.emoji, for: .normal)
            //print(card.currentTitle)
            cardsOnHand.append(sign)
        }
        print(cardsOnHand)
        
        computerCardLabels.removeAll()
        generateComputerCards()
        confirmButton.isHidden = false
        replayButton.isHidden = true

    }
    
    
}
