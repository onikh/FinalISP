import Scenes
import Igis
import Foundation

class HealthBar : RenderableEntity {
    let box : Image
    var destrect : Rect
    var currenthealth : Int
    var displayedhealth : Int
    var text : Text
    var fraction : Text
    var health : Rectangle
    var canContinue = true
    var ogHealthWidth : Int

    init(name:String) {
        guard let textboxURL = URL(string:"https://github.com/onikh/ISPData/blob/main/textbox.png?raw=true") else {
            fatalError("Failed to create URL for textbox")
        }

        box = Image(sourceURL:textboxURL)

        destrect = Rect(topLeft:Point(x:0, y:0), size:Size(width:1, height:1))
        text = Text(location:Point(x:0, y:0), text:name)
        health = Rectangle(rect:Rect(topLeft:Point(x:0,y:0), size:Size(width:1, height:1)), fillMode:.fill)


        currenthealth = 100
        displayedhealth = 100
        fraction = Text(location:Point(x:0, y:0), text:"100/100")
        ogHealthWidth = 0
        super.init(name:"HealthBar")
    }


    override func setup(canvasSize:Size, canvas:Canvas) {
        if let canvasSize = canvas.canvasSize {
            canvas.setup(box)

            destrect.size = Size(width:Int(Double(canvasSize.height)/2.5), height:Int(Double(canvasSize.height)*0.125))
            health.rect.size = Size(width:Int(Double(destrect.width)*0.8), height:destrect.height/30)

            text.font = "\(Int(Double(canvasSize.height)/25.0))pt Arial"
            fraction.font = "\(Int(Double(canvasSize.height)/50.0))pt Arial"

            ogHealthWidth = health.rect.width 

        }
    }

    override func calculate(canvasSize:Size) {
        fraction.text = "\(displayedhealth)/100"

        
        if displayedhealth < currenthealth && displayedhealth != 100 {
            displayedhealth += 1 
        }

        if displayedhealth > currenthealth {
            displayedhealth -= 1
        }

        if currenthealth > 100 {
            currenthealth = 100
        }

        if currenthealth == displayedhealth {
            canContinue = true
        } else {
            canContinue = false
        }

        health.rect.width = Int(Double(displayedhealth*ogHealthWidth)/100.0)

        if currenthealth < 0 {
            currenthealth = 0
        }

    }

    override func render(canvas:Canvas) {
        if box.isReady {
            box.renderMode = .destinationRect(destrect)
            canvas.render(box)
            canvas.render(FillStyle(color:Color(.black)), text, fraction)

            
            canvas.render(FillStyle(color:Color(.green)), health)
        }
    }
}
                                                
