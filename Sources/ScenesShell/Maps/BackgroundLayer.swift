import Scenes
import Igis
import Foundation
  /*
     This class is responsible for the background Layer.
     Internally, it maintains the RenderableEntities for this layer.
   */


class BackgroundLayer : Layer, KeyDownHandler {
    let transition = Transition()
    let map1 = Map1()
    let map2 = Map2()
    let seatext = Textbox(dialogue:"The sea shines a brilliant blue.")
    let signtext = Textbox(dialogue:"\"Entrance to the Forbidden Forest\"")
    let rockintro = Textbox(dialogue:"A strange aura emanates from the rock ahead...")
    let migueltext = Textbox(dialogue:"MIGUEL: Miguel 🐐🐐🐐")
    let mc = Mc()
    let water = Water()

    var miguelcount = 0 

   

    
    var transitioncount = 0

    var transto2 = false
    var transto1 = false

      init() {
          // Using a meaningful name can be helpful for debugging
          super.init(name:"Background")

          // We insert our RenderableEntities in the constructor
          insert(entity:map2, at:.back)
          insert(entity:map1, at:.back)
          insert(entity:water, at:.back)
          insert(entity:mc, at:.front)
          insert(entity:seatext, at:.front)
          insert(entity:signtext, at:.front)
          insert(entity:rockintro, at:.front)
          insert(entity:migueltext, at :.front)
          insert(entity:transition, at:.front)
      }

      override func preSetup(canvasSize:Size, canvas:Canvas) {
          dispatcher.registerKeyDownHandler(handler:self)
      }

      override func postTeardown() {
          dispatcher.unregisterKeyDownHandler(handler:self)
      }

      override func postCalculate(canvas:Canvas) {
          if let canvasSize = canvas.canvasSize {

              // Map1 Events
              if map1.sourcerect.topLeft.y < 2 && map1.active {
                  map1.active = false
                  transition.active = true
                  transto2 = true

                  map1.sourcerect.topLeft.y += 2*5
                  map1.testrect.topLeft.y -= Int(Double(map1.canvasheight)/100.0)*5
                  map1.testrect2.topLeft.y -= Int(Double(map1.canvasheight)/100.0)*5
                  map1.testrect3.topLeft.y -= Int(Double(map1.canvasheight)/100.0)*5
                  map1.testrect4.topLeft.y -= Int(Double(map1.canvasheight)/100.0)*5
                  map1.testrect5.topLeft.y -= Int(Double(map1.canvasheight)/100.0)*5
                  map1.testrect6.topLeft.y -= Int(Double(map1.canvasheight)/100.0)*5
                  map1.testrect7.topLeft.y -= Int(Double(map1.canvasheight)/100.0)*5
                  map1.testrect8.topLeft.y -= Int(Double(map1.canvasheight)/100.0)*5
                  print("if1")
              }

              if transto2 {
                  transitioncount += 1
                  print("if2")
                  if transitioncount == 30 {
                      transition.active = false
                      transto2 = false
                      map2.active = true
                      rockintro.active = true
                      transitioncount = 0
                  }
              }

              //Map2 Events
              
              if map2.sourcerect.bottomLeft.y > 470 && map2.active {
                  print("if3")
                  map2.active = false
                  transition.active = true
                  transto1 = true

                  map2.sourcerect.topLeft.y -= 10
                  map2.boundrect.topLeft.y += Int(Double(map2.canvasheight)/100.0)*5
                  map2.boundrect2.topLeft.y += Int(Double(map2.canvasheight)/100.0)*5
                  map2.boundrect3.topLeft.y += Int(Double(map2.canvasheight)/100.0)*5
                  map2.boundrect4.topLeft.y += Int(Double(map2.canvasheight)/100.0)*5
                  map2.boundrect5.topLeft.y += Int(Double(map2.canvasheight)/100.0)*5
                  map2.miguelrect.topLeft.y += Int(Double(map2.canvasheight)/100.0)*5 
              }

              if transto1 {
                  print("if4")
                  transitioncount += 1
                  if transitioncount == 30 {
                      transition.active = false
                      transto1 = false
                      map1.active = true
                      transitioncount = 0
                  }
              }

              // interaction locking
              if seatext.active || rockintro.active || signtext.active || map2.rendermiguel {
                  mc.mvmtlocked = true
                  map1.mvmtlocked = true
                  map2.mvmtlocked = true
              } else {
                  mc.mvmtlocked = false
                  map1.mvmtlocked = false
                  map2.mvmtlocked = false
              }

              if map2.rendermiguel {
                  miguelcount += 1
                  if miguelcount == 20 {
                      migueltext.active = true
                  }

                  
              }


              if migueltext.nextbox {
                  print("Ready to switch!")
                  func switchToGame() {
                      director.enqueueScene(scene: BattleScene())
                      director.transitionToNextScene()
                      
                  }
                  switchToGame()
              }


              if map1.lockedup || map2.lockedup {
                  water.lockedup = true
              } else {
                  water.lockedup = false
              }

              if map1.lockeddown || map2.lockeddown {
                  water.lockeddown = true 
              } else {
                  water.lockeddown = false
              }

              if map1.lockedleft || map2.lockedleft {
                  water.lockedleft = true
              } else {
                  water.lockedleft = false
              }

              if map1.lockedright || map2.lockedright {
                  water.lockedright = true
              } else {
                  water.lockedright = false
              }
                  
                      
      }
      }




      func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
          if code == "Enter" {

              let signcontainment = map1.testrect7.containment(target:map1.characterboundingrect)
              let seacontainment = map1.testrect.containment(target:map1.characterboundingrect)
              let miguelcontainment = map2.miguelrect.containment(target:map2.characterboundingrect)
              
              if map1.active && (!seacontainment.intersection([.overlapsTop]).isEmpty && seacontainment.contains(.contact)) && !seatext.active  {
                  seatext.active = true
                  
              } else {
                  seatext.active = false
              }

              if map1.active && (!signcontainment.intersection([.overlapsBottom]).isEmpty && signcontainment.contains(.contact)) && !signtext.active {
                  signtext.active = true
                  
              } else {
                  signtext.active = false
              }

              rockintro.active = false

              if map2.active && (!miguelcontainment.intersection([.overlapsBottom]).isEmpty && miguelcontainment.contains(.contact)) && !map2.rendermiguel {
                  map2.rendermiguel = true
              }

    
                  

      }
      }

}


      


// first map is 528*480
