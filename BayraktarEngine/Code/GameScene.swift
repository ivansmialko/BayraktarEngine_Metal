import MetalKit

struct GameScene
{
    lazy var house: Model = {
        Model(name: "lowpoly-house.obj")
    }()
    
    lazy var ground: Model = {
        var ground = Model(name: "plane.obj")
        ground.tiling = 16
        ground.scale = 40
        return ground
    }()
    
    lazy var obamium: Model =
    {
        var obamium = Model(name: "obamium.obj")
        obamium.position = [0, 0, 4]
        obamium.rotation = [0, Float(45).degreesToRadians, 0]
        return obamium
    }()
    
    lazy var btr: Model =
    {
        var car = Model(name: "Ukrainian_Z_BTR.obj")
        car.position = [3, -0.1, 8]
        return car
    }()
    
    lazy var models: [Model] = [ground, house, obamium, btr]
    
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
