import MetalKit

enum TextureController
{
    static var textures: [String: MTLTexture] = [:]
    
    static func getTexture(filename: String) -> MTLTexture?
    {
        //If texture already loaded - just return it
        if let texture = textures[filename]
        {
            return texture
        }
        
        let texture = try? loadTexture(filename: filename)
        if texture != nil
        {
            textures[filename] = texture
        }
        
        return texture
    }
    
    static func loadTexture(filename: String) throws -> MTLTexture?
    {
        let textureLoader = MTKTextureLoader(device: Renderer.device)
        
        //Try load texture from xcassets file
        if let texture = try? textureLoader.newTexture(
                name: filename,
                scaleFactor: 1.0,
                bundle: Bundle.main,
                options: nil)
        {
            Logger.logInfo("Loaded texture \(filename)")
            return texture
        }
        
        //Try load texture from file
        let textureLoaderOptions: [MTKTextureLoader.Option: Any] =
        [.origin: MTKTextureLoader.Origin.bottomLeft,
         .SRGB: false,
         .generateMipmaps: NSNumber(value: true)]
        
        let fileExtension = URL(fileURLWithPath: filename).pathExtension.isEmpty ?
        "png" : nil
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension)
                else
        {
            Logger.logError("Failed to load \(filename)")
            return nil
        }
        
        let texture = try textureLoader.newTexture(URL: url, options: textureLoaderOptions)
        
        Logger.logInfo("Loaded texture \(url.lastPathComponent)")
        return texture
    }
}
