import Scenes
import Igis
import Foundation


class BattleBGLayer : Layer {
    let background = BattleBackground()
    let battleStart = BattleText(dialogue:"MIGUEL wants to battle!")
    let battleInstructions = BattleText(dialogue:"Select options with your mouse.")

    let playerAttack = BattleText(dialogue:"You attacked!")
    let playerAttackFail = BattleText(dialogue:"You attacked, but Miguel blocked!")
    let playerHeal = BattleText(dialogue:"You healed!")
    let playerHealFail = BattleText(dialogue:"You're already at full health!")
    let playerBlock = BattleText(dialogue:"You blocked!")
    let playerCalm = BattleText(dialogue:"Focusing yourself, attack +5!")

    let miguelAttack = BattleText(dialogue:"Miguel attacked!")
    let miguelAttackFail = BattleText(dialogue:"Miguel attacked, but you blocked!")
    let miguelHeal = BattleText(dialogue:"Miguel healed!")
    let miguelHealFail = BattleText(dialogue:"Miguel tried to heal at 100 HP!")
    let miguelBlock = BattleText(dialogue:"Miguel prepared to block!")
    let miguelCalm = BattleText(dialogue:"Miguel focused himself, attack + 8!")

    let loss = BattleText(dialogue:"You were defeated. You suck.")
    let win = BattleText(dialogue:"You defeated Miguel! Thanks for playing!")
    
    let miguelHealth = HealthBar(name:"MIGUEL")
    let playerHealth = HealthBar(name:"PLAYER")

    let fight = Option(option:"Fight")
    let heal = Option(option:"Heal")
    let block = Option(option:"Block")
    let calm = Option(option:"Calm Mind")

    var damage = 20
    var miguelDamage = 30

    var activeOptions = false
    var miguelTurn = false

    var youBlocked = false
    var miguelBlocked = false

    var miguelDeterminer : Int



    func activateOptions() {
        fight.active = true
        heal.active = true
        block.active = true
        calm.active = true
        
        fight.clicked = false
        heal.clicked = false
        block.clicked = false
        calm.clicked = false

        youBlocked = false
        miguelTurn = false
        

        
    }
    

    func deactivateOptions() {
        fight.active = false
        heal.active = false
        block.active = false
        calm.active = false

       
    }  
    
    
    override func postCalculate(canvas:Canvas) {

        playerAttack.canContinue = miguelHealth.canContinue
        miguelAttack.canContinue = playerHealth.canContinue

        playerHeal.canContinue = playerHealth.canContinue
        miguelHeal.canContinue = miguelHealth.canContinue

        

        
        if battleStart.nextbox {
            battleStart.active = false
            battleStart.nextbox = false

            battleInstructions.active = true
        }

        if battleInstructions.nextbox {
            battleInstructions.active = false
            battleInstructions.nextbox = false

            activateOptions()
        }

        if calm.clicked {
            deactivateOptions()
            playerCalm.active = true
            damage += 5

            calm.clicked = false
        }

        if playerCalm.nextbox {
            playerCalm.active = false
            playerCalm.nextbox = false
            miguelTurn = true

            miguelBlocked = false
            
        }

        if heal.clicked {
            deactivateOptions()

            if playerHealth.currenthealth >= 100 {
                playerHealFail.active = true
            } else {
                playerHeal.active = true
                playerHealth.currenthealth += 15
            }
           
           
            heal.clicked = false
           
        }
        

        if (playerHeal.nextbox || playerHealFail.nextbox) && playerHealth.canContinue {
            playerHeal.active = false
            playerHealFail.active = false

            playerHeal.nextbox = false
            playerHealFail.nextbox = false

            miguelTurn = true

            miguelBlocked = false
        }
        

        if fight.clicked {
            deactivateOptions()

            if !miguelBlocked {
            miguelHealth.currenthealth -= damage
            playerAttack.active = true
            } else {
                playerAttackFail.active = true
            }
            
            fight.clicked = false
        }

        if (playerAttack.nextbox || playerAttackFail.nextbox) && miguelHealth.canContinue {
            playerAttack.active = false
            playerAttack.nextbox = false

            playerAttackFail.active = false
            playerAttackFail.nextbox = false
            miguelTurn = true

            miguelBlocked = false
        }

        if block.clicked {
            deactivateOptions()
            youBlocked = true
            playerBlock.active = true
            block.clicked = false
        }

        if playerBlock.nextbox {
            playerBlock.active = false
            playerBlock.nextbox = false
            miguelTurn = true

            miguelBlocked = false 
        }

        print(miguelTurn)

        if miguelTurn && !(win.active || loss.active) {
        
              miguelDeterminer = Int.random(in: 1 ... 3)
          

            if miguelDeterminer == 1 {

                if !youBlocked {
                playerHealth.currenthealth -= miguelDamage
                miguelAttack.active = true } else {
                    miguelAttackFail.active = true
                }
            }

            if miguelDeterminer == 2 {
                miguelBlock.active = true
                miguelBlocked = true
                print("block!")
              
            }

            if miguelDeterminer == 3 {

                if miguelHealth.currenthealth >= 100 {
                    miguelHealFail.active = true
                } else {
                    miguelHeal.active = true
                    miguelHealth.currenthealth += 30
                print("heal!")
                }
            }

            if miguelDeterminer == 4 {
                print("powerup!")
            }

            miguelTurn = false
        
        
        }

            if playerHealth.canContinue && miguelHealth.canContinue && (miguelAttackFail.nextbox || miguelAttack.nextbox || miguelBlock.nextbox || miguelHeal.nextbox || miguelHealFail.nextbox) {
            miguelAttackFail.active = false
            miguelAttack.active = false
            miguelBlock.active = false
            miguelHeal.active = false
            miguelHealFail.active = false
            
            miguelAttackFail.nextbox = false
            miguelAttack.nextbox = false
            miguelBlock.nextbox = false
            miguelHeal.nextbox = false
            miguelHealFail.nextbox = false

            activateOptions()
            }

            if miguelHealth.displayedhealth == 0 {
                win.active = true
                background.win.mode = .play
                deactivateOptions()
                background.banger.mode = .pause
                if background.migueldestrect.height >= 25 {
                    background.migueldestrect.height -= 3
                    background.migueldestrect.topLeft.y += 3
                }
            }

            if playerHealth.displayedhealth == 0 {
                loss.active = true
                background.loss.mode = .play
                deactivateOptions()
                background.banger.mode = .pause
                if background.trainerdestrect.height >= 25 {
                    background.trainerdestrect.height -= 3
                    background.trainerdestrect.topLeft.y += 3
                }
            }
            

        
            
        

      //  print(miguelHealth.canContinue)
        
    }

    init() {

         miguelDeterminer = 0


        
        super.init(name:"BackgroundLayer")  
        insert(entity:background, at:.back)
        insert(entity:miguelHealth, at:.front)
        insert(entity:playerHealth, at:.front)

        insert(entity:fight, at:.front)
        insert(entity:heal, at :.front)
        insert(entity:block, at:.front)
        insert(entity:calm, at:.front)

        insert(entity:playerAttack, at:.front)
        insert(entity:playerAttackFail, at:.front)   
        insert(entity:playerHeal, at:.front)
        insert(entity:playerHealFail, at:.front)
        insert(entity:playerBlock, at:.front)
        insert(entity:playerCalm, at:.front)

        insert(entity:miguelAttack, at:.front)
        insert(entity:miguelAttackFail, at:.front)
        insert(entity:miguelHeal, at:.front)
        insert(entity:miguelHealFail, at:.front)
        insert(entity:miguelBlock, at:.front)
        insert(entity:miguelCalm, at:.front)


        
        insert(entity:battleStart, at:.front)
        insert(entity:battleInstructions, at:.front)

        insert(entity:win, at:.front)
        insert(entity:loss, at:.front)


        

       

        
    }

    override func postSetup(canvasSize:Size, canvas:Canvas) {
        if let canvasSize = canvas.canvasSize {
            battleStart.active = true


            // Health Bars
        playerHealth.destrect.topLeft = Point(x:0, y:background.trainerdestrect.topLeft.y)
        miguelHealth.destrect.topLeft =  Point(x:canvasSize.width-miguelHealth.destrect.width, y:canvasSize.height/25)

        playerHealth.health.rect.topLeft = playerHealth.destrect.topLeft
        playerHealth.health.rect.topLeft += Point(x:Int(Double(playerHealth.destrect.width)*0.1), y:Int(Double(playerHealth.destrect.height)*0.66666))

        miguelHealth.health.rect.topLeft = miguelHealth.destrect.topLeft
        miguelHealth.health.rect.topLeft += Point(x:Int(Double(miguelHealth.destrect.width)*0.1), y:Int(Double(miguelHealth.destrect.height)*0.66666))

        playerHealth.text.baseline = .bottom
        playerHealth.text.alignment = .left 
        playerHealth.text.location = playerHealth.health.rect.topLeft

        miguelHealth.text.baseline = .bottom
        miguelHealth.text.alignment = .left
        miguelHealth.text.location = miguelHealth.health.rect.topLeft

        playerHealth.fraction.baseline = .top
        playerHealth.fraction.location = playerHealth.health.rect.bottomLeft

        miguelHealth.fraction.baseline = .top
        miguelHealth.fraction.location = miguelHealth.health.rect.bottomLeft


        // Options
        fight.destrect.topLeft = Point(x:0, y: canvasSize.height-fight.destrect.height)
        fight.word.location = fight.destrect.topLeft + Point(x:fight.destrect.width/2, y:fight.destrect.height/2)
        fight.word.baseline = .middle
        fight.word.alignment = .center

        heal.destrect.topLeft = fight.destrect.topLeft + Point(x:0, y: -(fight.destrect.height))
        heal.word.location = heal.destrect.topLeft + Point(x:heal.destrect.width/2, y:heal.destrect.height/2)
        heal.word.baseline = .middle
        heal.word.alignment = .center

        block.destrect.topLeft = Point(x:canvasSize.width/2, y:canvasSize.height-block.destrect.height)
        block.word.location = block.destrect.topLeft + Point(x:block.destrect.width/2, y:block.destrect.height/2)
        block.word.baseline = .middle
        block.word.alignment = .center

        calm.destrect.topLeft = Point(x:canvasSize.width/2, y:canvasSize.height-block.destrect.height*2)
        calm.word.location = calm.destrect.topLeft + Point(x:calm.destrect.width/2, y:calm.destrect.height/2)
        calm.word.baseline = .middle
        block.word.alignment = .center

        playerHealth.currenthealth = 100
        miguelHealth.currenthealth = 100

        miguelDeterminer = 0



        
        }


        

       

        
    }

    

    
}
