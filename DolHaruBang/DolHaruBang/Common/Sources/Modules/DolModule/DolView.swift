//
//  DolView.swift
//  DolHaruBang
//
//  Created by 양희태 on 8/20/24.
//

import SceneKit
import SwiftUI


// 3D 돌을 출력하는 UI
struct DolView : UIViewRepresentable {
    
    
//    @Binding var selectedFaceShape : FaceShape
    @Binding var selectedFace : Face
    @Binding var selectedFaceShape : FaceShape
    @Binding var selectedAccessory : Accessory
    

    // UI가 만들어질때 생성
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = loadScene(faceShape: selectedFaceShape)
        scnView.backgroundColor = UIColor.clear // SCNView의 배경을 투명하게 설정
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = false // 기본 조명 자동 활성화 비활성화
        scnView.defaultCameraController.interactionMode = .orbitTurntable
        
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        print("업데이트")
        
        // 씬이 로드되어 있다고 가정합니다.
        guard let scene = uiView.scene else {
            print("씬이 없습니다.")
            return
        }
            
      
        // 모든 노드 보이게 설정
        showAllNodes(rootNode: scene.rootNode)
        
        // showChild이 false일 때 child 노드만 보이게 설정
        if let parentNode = scene.rootNode.childNode(withName: "\(selectedFaceShape) reference", recursively: true) {
            moveNodeToPosition(node: parentNode, x: 0.0, y: 0.0, z: 0.0) // x, y, z 값은 원하는 위치로 설정
            // 선택한 얼굴형만 보이게
            hideAllNodesExcept(node: parentNode, rootNode: scene.rootNode)
            if let childNode = parentNode.childNode(withName: "\(selectedFace)", recursively: true) {
                showAllNodes(rootNode: parentNode)
                // 선택한 얼굴형중 선택한 표정만
                hideAllNodesExcept(node: childNode, rootNode: parentNode) // 선택 노드만 보이게 설정
            } else {
                    print("\(selectedFace) 노드가 씬에 존재하지 않습니다.")
            }
        }
        
        
        if let accessoryNode = scene.rootNode.childNode(withName: "Face" , recursively: true){
            if let childAccessoryNode = accessoryNode.childNode(withName: "\(selectedAccessory) reference", recursively: true) {
                // 선택한 얼굴형중 선택한 표정만black_glasses reference
                print("출력 \(selectedAccessory) reference")
                showAllNodes(rootNode: accessoryNode)
                hideAllNodesExcept(node: childAccessoryNode, rootNode: accessoryNode) // 선택 노드만 보이게 설정
                moveNodeToPosition(node: childAccessoryNode, x: 0.0, y: 0.0, z: 0.1) // x, y, z 값은 원하는 위치로 설정
            } else {
                    print("\(selectedFace) 노드가 씬에 존재하지 않습니다.")
            }
        }
        
       

        print("어떤것이 Hidden인지")
        printNodeDetails(node: scene.rootNode)
        print("씬의 노드 출력 끝")
        
       
        
        
    }
    
}




func loadScene(faceShape : FaceShape) -> SCNScene {
    let scene = SCNScene(named: "Dols.scnassets/DolGroup.scn") ?? SCNScene()

//    printNodeDetails(node: scene.rootNode)

    let accessoryNode = addAccessory()
    scene.rootNode.addChildNode(accessoryNode)
    

    for node in scene.rootNode.childNodes {
          node.scale = SCNVector3(x: 1, y: 1, z: 1) // 스케일 값을 조정하여 모델의 크기를 조절

      }
    
    // shading 값 설정
    updateMaterialsToPhysicallyBased(for: scene)
    
//    let cameraNode = makeCamera()
//    scene.rootNode.addChildNode(cameraNode)
//    
    // 환경 조명 추가
    let ambientLightNode = makeAmbientLight()
    scene.rootNode.addChildNode(ambientLightNode)
//    
//    // 그림자 조명 추가
//    let spotLightNode = makeSpotLight()
//    scene.rootNode.addChildNode(spotLightNode)
      
      // 방향성 조명 추가 1
//    let forwardDirectionalLightNode = makeDirectionalLight(X: -0.01, Y: -0.01, Z: 10, intensity: 1000, name: "forwardDirectionalLightNode")
//      scene.rootNode.addChildNode(forwardDirectionalLightNode)
//      
//    // 방향성 조명 추가 2
//    let leftDirectionalLightNode = makeDirectionalLight(X: -6, Y: 5, Z: 6.5, intensity: 500, name: "leftDirectionalLightNode")
//    scene.rootNode.addChildNode(leftDirectionalLightNode)
//    
//    // 방향성 조명 추가 3
//    let rightDirectionalLightNode = makeDirectionalLight(X: 6, Y: -3, Z: -3, intensity: 200, name: "rightDirectionalLightNode")
//    scene.rootNode.addChildNode(rightDirectionalLightNode)
    
    scene.rootNode.name = "model"
    
    // HDRI 파일의 URL을 가져옵니다.
        guard let hdrURL = Bundle.main.url(forResource: "lythwood_field_4k", withExtension: "hdr") else {
            print("HDR 이미지 파일을 찾을 수 없습니다.")
            return scene
        }
    
        let materialProperty = SCNMaterialProperty(contents: hdrURL)

    
       print("Intensity: \(materialProperty.intensity)")
       print("Minification Filter: \(materialProperty.minificationFilter)")
       print("Magnification Filter: \(materialProperty.magnificationFilter)")
       print("Mipmap Filter: \(materialProperty.mipFilter)")
       print("Contents Transform: \(materialProperty.contentsTransform)")
       print("Wrap S: \(materialProperty.wrapS)")
       print("Wrap T: \(materialProperty.wrapT)")
       print("Mapping Channel: \(materialProperty.mappingChannel)")
        
       scene.lightingEnvironment.contents = hdrURL
    
        
    return scene
}

func hideAllNodesExcept(node: SCNNode, rootNode: SCNNode) {
    
    for childNode in rootNode.childNodes {
        if childNode != node && childNode.name != "camera"  && childNode.name != "ambientLight" && childNode.name != "leftDirectionalLightNode" && childNode.name != "forwardDirectionalLightNode" && childNode.name != "rightDirectionalLightNode" && childNode.name != "spotLight" && childNode.name != "accessory" && childNode.name != "floor"{
            childNode.isHidden = true
        }
    }
}

func showAllNodes(rootNode: SCNNode) {
    // 현재 노드의 숨김 상태를 해제합니다.
       rootNode.isHidden = false
       
       // 현재 노드의 자식 노드들에 대해서도 재귀적으로 호출합니다.
       for childNode in rootNode.childNodes {
           showAllNodes(rootNode: childNode)
       }
}

func makeCamera() -> SCNNode {
        let cameraNode = SCNNode()
       cameraNode.camera = SCNCamera()
       cameraNode.position = SCNVector3(x: 0, y: 0, z: 3)
       cameraNode.camera?.automaticallyAdjustsZRange = false
        cameraNode.name = "camera"
        return cameraNode
}


func addAccessory() -> SCNNode {
    let scene = SCNScene(named: "Accessorys.scnassets/AccessoryGroup.scn") ?? SCNScene()
    scene.rootNode.name = "accessory"
    moveNodeToPosition(node: scene.rootNode, x: 0.0, y: 0.0, z: 0.0) // x, y, z 값은 원하는 위치로 설정
    return scene.rootNode
}

func makeAmbientLight() -> SCNNode{
    let ambientLightNode = SCNNode()
    let ambientLight = SCNLight()
    ambientLight.type = .ambient
    ambientLight.intensity = 3000 // 환경 조명 강도 조절
    ambientLightNode.light = ambientLight
    ambientLightNode.name = "ambientLight"
    return ambientLightNode
}

func makeSpotLight() -> SCNNode{
    let spotLightNode = SCNNode()
    let spotLight = SCNLight()
    spotLight.type = .spot
    spotLight.intensity = 1000
    spotLight.color = UIColor(white: 1.0, alpha: 1.0) // 빛의 색상 원색
    
    // 그림자 설정
    spotLight.castsShadow = true
    spotLight.automaticallyAdjustsShadowProjection = true
    spotLight.maximumShadowDistance = 20.0 // 그림자가 보이는 최대 거리
    spotLight.orthographicScale = 10.0 // 조명 투영의 크기 (상황에 맞게 조정)
    spotLight.shadowMapSize = CGSize(width: 2048, height: 2048) // 그림자 맵 해상도
    spotLight.shadowMode = .deferred // 그림자 모드 설정 (Deferred는 더 좋은 품질을 제공합니다)
    spotLight.shadowSampleCount = 128 // 그림자 샘플 수 (더 높은 수치일수록 품질이 향상됨)
    spotLight.shadowRadius = 20.0 // 그림자의 흐림 정도
    spotLight.shadowBias = 5.0 // 그림자 편향 (섬세하게 조정하여 그림자 부풀림을 방지)
    spotLight.zNear = 1 // 그림자의 시작 거리
    spotLight.zFar = 1000 // 그림자의 끝 거리
    spotLight.shadowColor = UIColor.black.withAlphaComponent(0.36)// 그림자의 색상과 투명도
     
    spotLight.spotInnerAngle = 30 // 스팟 라이트의 내부 각도
    spotLight.spotOuterAngle = 60 // 스팟 라이트의 외부 각도
    
    spotLightNode.light = spotLight
    spotLightNode.name = "spotLight"
    
    // 조명을 모델 위쪽 배치
    spotLightNode.position = SCNVector3(x: 0, y: 10, z: 0) // 모델 아래쪽에 위치하도록 설정
    spotLightNode.look(at: SCNVector3(x: 0, y: 0, z: 0)) // 모델의 중앙을 향하도록 설정
       
    
    return spotLightNode
}

func makeDirectionalLight(X: Float, Y : Float, Z : Float, intensity : CGFloat, name : String ) -> SCNNode {
    let directionalLightNode = SCNNode()
    let directionalLight = SCNLight()
    directionalLight.type = .directional
    directionalLight.intensity = intensity // 방향성 조명 강도 조절
    directionalLight.color = UIColor(red: 255/255, green: 236/255, blue: 206/255, alpha: 1.0) // 조명 색상 설정
    directionalLightNode.light = directionalLight
    directionalLightNode.name = name
    // 방향성 조명의 방향 설정
    directionalLightNode.position = SCNVector3(x: X, y: Y, z: Z)
    directionalLightNode.look(at: SCNVector3.init(x: 0, y: 0, z: 0)) // 장면의 중심을 향하도록 조명 방향 설정
    
    return directionalLightNode
}

func updateMaterialsToPhysicallyBased(for scene: SCNScene) {
    scene.rootNode.enumerateChildNodes { (node, _) in
        for material in node.geometry?.materials ?? [] {
            material.lightingModel = .physicallyBased
        }
    }
}


func printNodeDetails(node: SCNNode, depth: Int = 0) {
    // 현재 노드의 이름과 깊이를 출력합니다.
    let indentation = String(repeating: "  ", count: depth)
    print("\(indentation)Node name: \(node.name ?? "Unnamed")")
    print("\(indentation)  IsHidden: \(node.isHidden)")
    // 노드의 지오메트리가 있으면 지오메트리의 정보를 출력합니다.
    if let geometry = node.geometry {
        print("\(indentation)  Geometry: \(geometry.name ?? "Unnamed")")
        for material in geometry.materials {
            if let color = material.diffuse.contents as? UIColor {
//                print("\(indentation)    Material color: \(color)")
            }
        }
    }
    
    // 자식 노드가 있으면 자식 노드를 재귀적으로 탐색합니다.
    for childNode in node.childNodes {
        printNodeDetails(node: childNode, depth: depth + 1)
    }
}

func moveNodeToPosition(node: SCNNode, x: Float, y: Float, z: Float) {
    node.position = SCNVector3(x, y, z)
}
