import Scenes
import Igis
import Foundation


class Water : RenderableEntity, KeyDownHandler {

    let water : Image
    var sourcerect : Rect
    var destrect : Rect
    var counter : Int
    var mvmtlocked = false

    var lockedright = false
    var lockedleft = false
    var lockedup = false
    var lockeddown = false

    init() {
        guard let waterURL = URL(string:"https://github.com/onikh/ISPData/blob/main/watertilemap.png?raw=true") else {
            fatalError("water")
        }

        water = Image(sourceURL:waterURL)
        destrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        sourcerect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        counter = 0
        super.init(name:"Water")
    }

    override func setup(canvasSize:Size, canvas:Canvas) {
        canvas.setup(water)

        if let canvasSize = canvas.canvasSize {
            let canvasratio =  Double(canvasSize.width)/Double(canvasSize.height)

            sourcerect = Rect(topLeft:Point(x:32, y:112), size:Size(width:(200*canvasSize.width)/canvasSize.height, height:200))

            destrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:canvasSize.width, height:canvasSize.height))
            dispatcher.registerKeyDownHandler(handler:self) 

            counter = 0

        }
    }

    override func teardown() {
        dispatcher.unregisterKeyDownHandler(handler:self)
    }

    override func render(canvas:Canvas) {
        if water.isReady {
            water.renderMode = .sourceAndDestination(sourceRect:sourcerect, destinationRect:destrect)
            canvas.render(water)
            counter += 1
            if counter%2 == 0 {
            sourcerect.topLeft.x += 1
            }
            if counter == 240 {
                sourcerect.topLeft.x = 0
                counter = 0
            }
        }
    }

    func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        if !mvmtlocked {

            
            if code == "ArrowUp" && sourcerect.topLeft.y > 0 && !lockedup {
                sourcerect.topLeft.y -= 2
            }
            if sourcerect.topLeft.y < 0 {
                sourcerect.topLeft.y = 112
            }
            

            if code == "ArrowDown" && !lockeddown && sourcerect.bottomLeft.y < 480 {
                sourcerect.topLeft.y += 2
                print("!")
            }
            if sourcerect.bottomLeft.y > 480 {
                sourcerect.bottomLeft.y = 240
            }

            if code == "ArrowRight" && sourcerect.bottomRight.x < 703 && !lockedright {
                sourcerect.topLeft.x += 2
            }
            if sourcerect.bottomRight.x > 703 {
            sourcerect.topLeft.x = 32
        }

            if code == "ArrowLeft" && sourcerect.topLeft.x > 2 && !lockedleft {
                sourcerect.topLeft.x -= 2
            }
            
        }
    }

           
}

