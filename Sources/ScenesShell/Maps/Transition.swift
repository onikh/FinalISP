import Scenes
import Igis
import Foundation

class Transition : RenderableEntity {
    var transitionrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
    var active = false


    init() {

        super.init(name:"Transition")
    }

    override func setup(canvasSize:Size, canvas:Canvas) {
        if let canvasSize = canvas.canvasSize {
            transitionrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:canvasSize.width, height:canvasSize.height))

        }
    }

    override func render(canvas:Canvas) {
        if active {
            canvas.render(FillStyle(color:Color(.black)), Rectangle(rect:transitionrect, fillMode:.fillAndStroke))
        }
    }
}
        
                      
        
