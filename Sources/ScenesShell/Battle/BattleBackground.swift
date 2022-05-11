import Scenes
import Igis
import Foundation

class BattleBackground : RenderableEntity {
    let bg : Image
    let circle1 : Image
    let circle2 : Image
    let trainer : Image
    let miguel : Image

    


    var bgdestrect : Rect
    var circle1destrect : Rect
    var circle2destrect : Rect
    var trainerdestrect : Rect
    var migueldestrect : Rect

    let banger : Audio
    let win : Audio
    let loss : Audio
   
    
    
    


    init() {
        guard let bgURL = URL(string:"https://github.com/onikh/ISPData/blob/main/battlebg.png?raw=true") else {
            fatalError("Failed to create URL for bg")
        }
        bg = Image(sourceURL:bgURL)

        guard let circle1URL = URL(string:"https://github.com/onikh/ISPData/blob/main/battlecircle.png?raw=true") else {
            fatalError("Failed to create URL for circle1")
        }
        
        circle1 = Image(sourceURL:circle1URL)

        circle2 = Image(sourceURL:circle1URL)

        guard let trainerURL = URL(string:"https://github.com/onikh/ISPData/blob/main/spritebase2.png?raw=true") else {
            fatalError("Failed to create URL for trainer")
        }

        trainer = Image(sourceURL:trainerURL)

        guard let miguelURL = URL(string:"https://github.com/onikh/ISPData/blob/main/miguel.png?raw=true") else {
            fatalError("Failed to create URL for miguel")
        }
        miguel = Image(sourceURL:miguelURL)

        guard let bangerURL = URL(string:"https://github.com/onikh/ISPData/blob/main/gamecorner.mp3?raw=true") else {
            fatalError("Failed to create URL for banger")
        }
        banger = Audio(sourceURL:bangerURL, shouldLoop:true)

        guard let winURL = URL(string:"https://github.com/onikh/ISPData/blob/main/win.mp3?raw=true") else {
            fatalError("Failed to create URL for win")
        }
        win = Audio(sourceURL:winURL)

        guard let lossURL = URL(string:"https://github.com/onikh/ISPData/blob/main/loss.mp3?raw=true") else {
            fatalError("Failed to create URL for win")
        }
        loss = Audio(sourceURL:lossURL)

        
        

        




            bgdestrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
            circle1destrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
            circle2destrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
            trainerdestrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
            migueldestrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))



        super.init(name:"BattleBackground")
    }

    override func setup(canvasSize:Size, canvas:Canvas) {
        canvas.setup(bg)
        canvas.setup(circle1)
        canvas.setup(circle2)
        canvas.setup(trainer)
        canvas.setup(miguel)
        canvas.setup(banger)
        canvas.setup(win)
        canvas.setup(loss)

        win.mode = .pause
        loss.mode = .pause

        if let canvasSize = canvas.canvasSize {
            bgdestrect.size = Size(width:canvasSize.width, height:canvasSize.height)
            circle1destrect = Rect(bottomLeft:Point(x:canvasSize.width/100, y:Int(Double(canvasSize.height)*0.666666)), size:Size(width:Int(Double(canvasSize.height)), height:Int(Double(canvasSize.height)*0.25)))
            circle2destrect = Rect(topRight:Point(x:canvasSize.width-canvasSize.width/100, y:Int(Double(canvasSize.height)*0.27)), size:Size(width:Int(Double(canvasSize.height)*0.6), height:Int(Double(canvasSize.height)*0.15)))
            trainerdestrect = Rect(topLeft:Point(x:circle1destrect.topLeft.x + circle1destrect.width/2, y:circle1destrect.topLeft.y + circle1destrect.height/2), size:Size(width:Int(Double(circle1destrect.height)*(34.0/52.0)), height:circle1destrect.height))

            trainerdestrect.topLeft.y -= trainerdestrect.height
            trainerdestrect.topLeft.x -= trainerdestrect.width/2

            migueldestrect = Rect(topLeft:Point(x:circle2destrect.topLeft.x + circle2destrect.width/2, y:circle2destrect.topLeft.y + circle2destrect.height/2), size:Size(width:Int(Double(circle2destrect.height)*(150.0/202.0)), height:circle2destrect.height))
            migueldestrect.topLeft.y -= migueldestrect.height
            migueldestrect.topLeft.x -= migueldestrect.width/2




            if banger.isReady {
                canvas.render(banger)
            } else {
                print("Not ready :(")
            }
        }

    }

    override func render(canvas:Canvas) {
        if bg.isReady && circle1.isReady && circle2.isReady && miguel.isReady && trainer.isReady && banger.isReady {
            bg.renderMode = .destinationRect(bgdestrect)
            circle1.renderMode = .destinationRect(circle1destrect)
            circle2.renderMode = .destinationRect(circle2destrect)
            trainer.renderMode = .destinationRect(trainerdestrect)
            miguel.renderMode = .destinationRect(migueldestrect)
            canvas.render(bg)
            canvas.render(circle1)
            canvas.render(circle2)
            canvas.render(miguel)
            canvas.render(trainer)
            canvas.render(banger)

            
          
        }

        if win.isReady && loss.isReady {
            canvas.render(loss, win)
        }
        }

        
    }



    
