import MetalKit

struct GameScene
{
    lazy var models: [Model] = []
    
    var camera = FirstPersonCamera()
    
    init()
    {
        camera.position = [0, 1.5, -5]
    }
    
    mutating func update(size: CGSize)
    {
        camera.update(size: size)
    }
    
    mutating func update(deltaTime: Float)
    {
        camera.update(deltaTime: deltaTime)
    }
}
