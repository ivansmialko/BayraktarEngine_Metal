import MetalKit
import SwiftUI

class Renderer: NSObject
{
    var options: Options
    
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    
    var pipelineState : MTLRenderPipelineState!
    var depthStencilState : MTLDepthStencilState?
    
    var lastTime: Double = CFAbsoluteTimeGetCurrent()
    var uniforms = Uniforms()
    var params = Params()
    
    lazy var scene = GameScene()
    
    init(metalView: MTKView, options: Options)
    {
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue()
        else
        {
            Logger.logError("Failed to create GPU device!")
            fatalError("Failed to create GPU device!")
        }
        
        self.options = options
        
        Renderer.device = device
        metalView.device = device
        Renderer.commandQueue = commandQueue
        
        //Create shader functions
        let library = device.makeDefaultLibrary()
        Self.library = library
        
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction = library?.makeFunction(name: "fragment_main")
        
        //Pipeline state object
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        do
        {
            pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultLayout
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }
        catch let error
        {
            Logger.logError(error.localizedDescription)
        }
        
        depthStencilState = Renderer.buildDepthStencilState()
        
        super.init()
        
        metalView.clearColor = MTLClearColor(
            red: 0.93,
            green: 0.97,
            blue: 1.0,
            alpha: 1.0)
        metalView.depthStencilPixelFormat = .depth32Float
        metalView.delegate = self
        mtkView(metalView, drawableSizeWillChange: metalView.bounds.size)
    }
    
    static func buildDepthStencilState() -> MTLDepthStencilState?
    {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true
        
        return Renderer.device.makeDepthStencilState(descriptor: descriptor)
    }
}

extension Renderer : MTKViewDelegate
{
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize)
    {
        
    }
    
    func draw(in view: MTKView) {
        guard
            let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
            let descriptor = view.currentRenderPassDescriptor,
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else
        {
            return
        }
        
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        
        let currentTime = CFAbsoluteTimeGetCurrent()
        let deltaTime = Float(currentTime - lastTime)
        lastTime = currentTime
        
        scene.update(deltaTime: deltaTime)
        uniforms.viewMatrix = scene.camera.viewMatrix
        uniforms.projectionMatrix = scene.camera.projectionMatrix
        
        for model in scene.models
        {
            model.render(encoder: renderEncoder, uniforms: uniforms, params: params)
        }
        
        renderEncoder.endEncoding()
        guard
            let drawable = view.currentDrawable
        else
        {
            return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
