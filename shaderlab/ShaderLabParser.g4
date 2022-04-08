
// ShaderLab is a language for defining shaders for the Unity game engine.
//
// References:
// - Official docs: https://docs.unity3d.com/Manual/SL-Reference.html
// Other implementations:
// - Atom: https://github.com/khakionion/language-unity-shaderlab
// - TextMate: https://github.com/tgjones/shaders-tmLanguage
//
// Original author:
// Hakanai <hakanai@ephemeral.garden>
//
// Licence: MIT

parser grammar ShaderLabParser;

options
{
    tokenVocab = ShaderLabLexer;
}

// entry point
file
   : shaderBlock EOF
   ;

// Shader: https://docs.unity3d.com/Manual/SL-Shader.html
// Children, in any order:   TODO: Can we enforce the counts in the grammar?
// (1..many) SubShaderBlock,
// (0..1) MaterialPropertiesBlock,
// (0..1) CustomEditorStatement
// (0..many) CustomEditorForRenderPipeline
// (0..1) FallbackStatement
shaderBlock
   :  Shader name=STRING
      OPEN_BRACE
      (  propertiesBlock
      |  subShaderBlock
      |  customEditorBlock
      |  customEditorForRenderPipelineBlock
      |  fallbackBlock
      |  categoryBlock
      )+
      CLOSE_BRACE
   ;

// Category: https://docs.unity3d.com/Manual/SL-Other.html
categoryBlock
   :  Category
      OPEN_BRACE
      (  renderStateCommand
      |  subShaderBlock
      )*
      CLOSE_BRACE
   ;

// Material Properties: https://docs.unity3d.com/Manual/SL-Properties.html
// Children:
// (0..many) MaterialPropertyDeclaration
propertiesBlock
   :  Properties
      OPEN_BRACE
      materialPropertyDeclaration*
      CLOSE_BRACE
   ;

materialPropertyDeclaration
   :  materialPropertyAttribute*
      name=IDENTIFIER
      OPEN_PAREN
      displayText=STRING
      COMMA
      (
         (  Int CLOSE_PAREN EQUALS defaultValue=INTEGER )
      |  (  Float CLOSE_PAREN EQUALS defaultValue=(FLOAT|INTEGER) )
      |  (  Range OPEN_PAREN min=(FLOAT|INTEGER) COMMA max=(FLOAT|INTEGER) CLOSE_PAREN
            CLOSE_PAREN EQUALS defaultValue=(FLOAT|INTEGER) )
      |  (  ( TwoD | TwoDArray | ThreeD | Cube | CubeArray )
            CLOSE_PAREN EQUALS defaultValue=STRING OPEN_BRACE CLOSE_BRACE )
      |  (  ( Color | Vector )
            CLOSE_PAREN EQUALS defaultVectorValue=floatVector )
      )
   ;

materialPropertyAttribute
   :  OPEN_BRACKET
      (  attributeName=materialPropertyAttributeName
      |  drawerName=materialPropertyDrawerName
         (
            OPEN_PAREN
            firstParam=materialPropertyDrawerParameter
            ( COMMA restOfParams=materialPropertyDrawerParameter )*
            CLOSE_PAREN
         )?
      |  STRING
      )
      CLOSE_BRACKET
   ;

materialPropertyAttributeName
   :  Gamma
   |  HDR
   |  HideInInspector
   |  MainTexture
   |  MainColor
   |  NoScaleOffset
   |  Normal
   |  PerRendererData
   ;

materialPropertyDrawerName
   :  Toggle
   |  ToggleOff
   |  KeywordEnum
   |  Enum
   |  PowerSlider
   |  IntRange
   |  IDENTIFIER
   ;

// TODO: This supports some subset of C# attribute syntax
materialPropertyDrawerParameter
   :  IDENTIFIER
   ;

// Fallback: https://docs.unity3d.com/Manual/SL-Fallback.html
fallbackBlock
   :  Fallback ( Off | name=STRING )
   ;

// Custom Editor: https://docs.unity3d.com/Manual/SL-CustomEditor.html
customEditorBlock
   :  CustomEditor className=STRING
   ;

customEditorForRenderPipelineBlock
   :  CustomEditorForRenderPipeline
      className=STRING
      renderPipelineAssetName=STRING
   ;

// SubShader: https://docs.unity3d.com/Manual/SL-SubShader.html
// Also in any order?
// (0..1) LODBlock
// (0..1) TagsBlock
// (0..many) RenderStateCommand or PassCommand
// (1..many) PassBlock
subShaderBlock
   :  SubShader
      OPEN_BRACE
      (  lodBlock
      |  tagsBlock
      |  renderStateCommand
      |  passCommand
      |  passBlock
      |  shaderIncludeBlock
      |  legacyCommand
      )*
      CLOSE_BRACE
   ;

// SubShader Tags: https://docs.unity3d.com/Manual/SL-SubShaderTags.html
tagsBlock
   :  Tags
      OPEN_BRACE
      tag*
      CLOSE_BRACE
   ;

// XXX: We could _maybe_ go all the way inside the values to check validity...
tag
   :  name=STRING EQUALS value=STRING
   ;

// SubShader LOD: https://docs.unity3d.com/Manual/SL-ShaderLOD.html
lodBlock
   :  LOD value=INTEGER
   ;

// Pass: https://docs.unity3d.com/Manual/SL-Pass.html
passBlock
   :  Pass
      OPEN_BRACE
      (  nameBlock
      |  tagsBlock
      |  renderStateCommand
      |  legacyCommand
      |  shaderProgramBlock
      )*
      CLOSE_BRACE
   ;

// Name: https://docs.unity3d.com/Manual/SL-Name.html
nameBlock
   :  Name name=STRING
   ;

// Shader Code Blocks: https://docs.unity3d.com/Manual/shader-shaderlab-code-blocks.html
shaderIncludeBlock
   :  hlslIncludeBlock
   |  cgIncludeBlock
   ;

hlslIncludeBlock
   :  HLSLINCLUDE
      hlslBody
      ENDHLSL
   ;

cgIncludeBlock
   :  CGINCLUDE
      cgBody
      ENDCG
   ;

shaderProgramBlock
   : hlslProgramBlock
   | cgProgramBlock
   ;

hlslProgramBlock
   :  HLSLPROGRAM
      hlslBody
      ENDHLSL
   ;

cgProgramBlock
   :  CGPROGRAM
      cgBody
      ENDCG
   ;

hlslBody
   :  (  HLSL_String
      |  HLSL_Identifier
      |  HLSL_OtherNonWS
      )*
   ;

cgBody
   :  (  CG_String
      |  CG_Identifier
      |  CG_OtherNonWS
      )*
   ;

// Commands: https://docs.unity3d.com/Manual/shader-shaderlab-commands.html
renderStateCommand
   :  alphaToMaskCommand
   |  blendCommand
   |  blendOpCommand
   |  colorMaskCommand
   |  conservativeCommand
   |  cullCommand
   |  offsetCommand
   |  stencilCommand
   |  zClipCommand
   |  zTestCommand
   |  zWriteCommand
   ;

passCommand
   : usePassCommand
   | grabPassCommand
   ;

// AlphaToMask: https://docs.unity3d.com/Manual/SL-AlphaToMask.html
alphaToMaskCommand
   :  AlphaToMask state=alphaToMaskState
   ;

alphaToMaskState
   :  On
   |  Off
   |  propertyReference
   ;

// Blend: https://docs.unity3d.com/Manual/SL-Blend.html
blendCommand
   :  Blend
      ( renderTarget=INTEGER )?
      (  state=Off
      |  sourceFactor=blendFactor destinationFactor=blendFactor
      |  sourceFactorRgb=blendFactor destinationFactorRgb=blendFactor COMMA
         sourceFactorAlpha=blendFactor destinationFactorAlpha=blendFactor
      )
   ;

blendFactor
   :  One
   |  Zero
   |  SrcColor
   |  SrcAlpha
   |  DstColor
   |  DstAlpha
   |  OneMinusSrcColor
   |  OneMinusSrcAlpha
   |  OneMinusDstColor
   |  OneMinusDstAlpha
   |  propertyReference
   ;

blendOpCommand
   :  BlendOp operation=blendOpOperation
   ;

blendOpOperation
   :  Add
   |  Sub
   |  RevSub
   |  Min
   |  Max
   |  LogicalClear
   |  LogicalSet
   |  LogicalCopy
   |  LogicalCopyInverted
   |  LogicalNoop
   |  LogicalInvert
   |  LogicalAnd
   |  LogicalNand
   |  LogicalOr
   |  LogicalNor
   |  LogicalXor
   |  LogicalEquiv
   |  LogicalAndReverse
   |  LogicalAndInverted
   |  LogicalOrReverse
   |  LogicalOrInverted
   |  Multiply
   |  Screen
   |  Overlay
   |  Darken
   |  Lighten
   |  ColorDodge
   |  ColorBurn
   |  HardLight
   |  SoftLight
   |  Difference
   |  Exclusion
   |  HSLHue
   |  HSLSaturation
   |  HSLColor
   |  HSLLuminosity
   |  propertyReference
   ;

// ColorMask: https://docs.unity3d.com/Manual/SL-ColorMask.html
colorMaskCommand
   :  ColorMask channels=colorMaskChannels ( renderTarget=INTEGER )?
   ;

// TODO: Is it possible to reorder the letters too?
// TODO: Should only permit 0 instead of INTEGER
colorMaskChannels
   :  INTEGER
   |  R | G | B | A
   |  RG | RB | RA | GB | GA | BA
   |  RGB | RGA | RBA | BGA
   |  RGBA
   |  propertyReference
   ;

// Conservative: https://docs.unity3d.com/Manual/SL-Conservative.html
conservativeCommand
   :  Conservative enabled=conservativeEnabled
   ;

conservativeEnabled
   :  True
   |  False
   |  propertyReference
   ;

// Cull: https://docs.unity3d.com/Manual/SL-Cull.html
cullCommand
   :  Cull state=cullState
   ;

cullState
   :  Back
   |  Front
   |  Off
   |  propertyReference
   ;

// Offset: https://docs.unity3d.com/Manual/SL-Offset.html
offsetCommand
   :  Offset factor=floatValueOrRef COMMA units=floatValueOrRef
   ;

// Stencil: https://docs.unity3d.com/Manual/SL-Stencil.html
stencilCommand
   :  Stencil
      OPEN_BRACE
      (  Ref ref=intValueOrRef
      |  ReadMask readMask=intValueOrRef
      |  WriteMask writeMask=intValueOrRef
      |  Comp comparisonOperation=stencilComparisonOperation
      |  Pass passOperation=stencilOperation
      |  Fail failOperation=stencilOperation
      |  ZFail zFailOperation=stencilOperation
      |  CompBack comparisonOperationBack=stencilComparisonOperation
      |  PassBack passOperationBack=stencilOperation
      |  FailBack failOperationBack=stencilOperation
      |  ZFailBack zFailOperationBack=stencilOperation
      |  CompFront comparisonOperationFront=stencilComparisonOperation
      |  PassFront passOperationFront=stencilOperation
      |  FailFront failOperationFront=stencilOperation
      |  ZFailFront zFailOperationFront=stencilOperation
      )*
      CLOSE_BRACE
   ;

stencilComparisonOperation
   :  Never
   |  Less
   |  Equal
   |  LEqual
   |  Greater
   |  NotEqual
   |  GEqual
   |  Always
   |  propertyReference
   ;

stencilOperation
   :  Keep
   |  Zero
   |  Replace
   |  IncrSat
   |  DecrSat
   |  Invert
   |  IncrWrap
   |  DecrWrap
   |  propertyReference
   ;

// UsePass: https://docs.unity3d.com/Manual/SL-UsePass.html
usePassCommand
   :  UsePass shaderAndPassName=STRING
   ;

// GrabPass: https://docs.unity3d.com/Manual/SL-GrabPass.html
grabPassCommand
   :  GrabPass
      OPEN_BRACE
      textureName=STRING?
      CLOSE_BRACE
   ;

// ZClip: https://docs.unity3d.com/Manual/SL-ZClip.html
zClipCommand
   :  ZClip enabled=zClipEnabled
   ;

zClipEnabled
   :  True
   |  False
   |  propertyReference
   ;

// ZTest: https://docs.unity3d.com/Manual/SL-ZTest.html
zTestCommand
   :  ZTest operation=zTestOperation
   ;

zTestOperation
   :  Less
   |  LEqual
   |  Equal
   |  GEqual
   |  Greater
   |  NotEqual
   |  Always
   |  propertyReference
   ;

// ZWrite: https://docs.unity3d.com/Manual/SL-ZWrite.html
zWriteCommand
   :  ZWrite state=zWriteState
   ;

zWriteState
   :  On
   |  Off
   |  propertyReference
   ;

legacyCommand
   :  legacyFogCommand
   |  legacyColorCommand
   |  legacyMaterialBlock
   |  legacyLightingCommand
   |  legacySeparateSpecularCommand
   |  legacyColorMaterialCommand
   |  legacyAlphaTestCommand
   |  legacySetTextureBlock
   |  legacyBindChannelsBlock
   ;

// [LEGACY] Fog: https://docs.unity3d.com/Manual/SL-Fog.html
legacyFogCommand
   :  Fog fogMode=legacyFogMode
   ;

legacyFogMode
   :  Off
   |  Global
   |  propertyReference
   ;

// [LEGACY] Materials / lighting: https://docs.unity3d.com/Manual/SL-Material.html
legacyColorCommand
   :  Color color=floatVectorOrRef
   ;

legacyMaterialBlock
   :  Material
      OPEN_BRACE
      legacyMaterialCommand*
      CLOSE_BRACE
   ;

legacyLightingCommand
   :  Lighting enabled=legacyLightingEnabled
   ;

legacyLightingEnabled
   :  On
   |  Off
   |  propertyReference
   ;

legacySeparateSpecularCommand
   :  SeparateSpecular enabled=legacySeparateSpecularEnabled
   ;

legacySeparateSpecularEnabled
   :  On
   |  Off
   |  propertyReference
   ;

legacyColorMaterialCommand
   :  ColorMaterial colorMaterialMode=legacyColorMaterialMode
   ;

legacyColorMaterialMode
   :  AmbientAndDiffuse
   |  Emission
   |  propertyReference
   ;

legacyMaterialCommand
   :  legacyDiffuseCommand
   |  legacyAmbientCommand
   |  legacySpecularCommand
   |  legacyShininessCommand
   |  legacyEmissionCommand
   ;

legacyDiffuseCommand
   :  Diffuse color=floatVectorOrRef
   ;

legacyAmbientCommand
   :  Ambient color=floatVectorOrRef
   ;

legacySpecularCommand
   :  Specular color=floatVectorOrRef
   ;

legacyShininessCommand
   :  Shininess value=floatValueOrRef
   ;

legacyEmissionCommand
   :  Emission value=floatVectorOrRef
   ;

// [LEGACY] Alpha testing: https://docs.unity3d.com/Manual/SL-AlphaTest.html
legacyAlphaTestCommand
   :  AlphaTest comparison=legacyAlphaTestComparison alphaValue=floatValueOrRef
   ;

legacyAlphaTestComparison
   :  Greater
   |  GEqual
   |  Less
   |  LEqual
   |  Equal
   |  NotEqual
   |  Always
   |  Never
   |  propertyReference
   ;

// [LEGACY] Texture combining: https://docs.unity3d.com/Manual/SL-SetTexture.html
legacySetTextureBlock
   :  SetTexture
      textureName=propertyReference
      OPEN_BRACE
      legacyTextureBlockCombineCommand*
      CLOSE_BRACE
   ;

legacyTextureBlockCombineCommand
   :  Combine
      legacyTextureBlockCombineEntry
      ( COMMA legacyTextureBlockCombineEntry )*
   ;

legacyTextureBlockCombineEntry
   :  src1=legacyTextureBlockSource
      (  TIMES src2=legacyTextureBlockSource
      |  PLUS src2=legacyTextureBlockSource
      |  MINUS src2=legacyTextureBlockSource
      |  Lerp OPEN_PAREN src2=legacyTextureBlockSource CLOSE_PAREN src3=legacyTextureBlockSource
      |  TIMES src2=legacyTextureBlockSource PLUS src3=legacyTextureBlockSource
      )?
   ;

legacyTextureBlockSource
   :  Previous
   |  Constant
   |  Primary
   |  Texture
   ;

// [LEGACY] Vertex data channel mapping: https://docs.unity3d.com/Manual/SL-BindChannels.html
legacyBindChannelsBlock
   :  BindChannels
      OPEN_BRACE
      legacyBindCommand*
      CLOSE_BRACE
   ;

// XXX: source string is actually a restricted set of strings too:
// 'Vertex', 'Normal', 'Tangent', 'Texcoord', 'Texcoord1', 'Color'
// Not sure what to do about that in the grammar.
legacyBindCommand
   :  Bind source=STRING target=legacyBindTarget
   ;

legacyBindTarget
   :  Vertex
   |  Normal
   |  Tangent
   |  Texcoord
   |  TexcoordN
   |  Color
   ;

intValueOrRef
   : INTEGER
   | propertyReference
   ;

floatVectorOrRef
   : floatVector
   | propertyReference
   ;

floatValueOrRef
   : floatValue
   | propertyReference
   ;

propertyReference
   : OPEN_BRACKET
     property=IDENTIFIER
     CLOSE_BRACKET
   ;

floatVector
   :  OPEN_PAREN
      x=floatValue COMMA
      y=floatValue COMMA
      z=floatValue COMMA
      w=floatValue CLOSE_PAREN
   ;

floatValue
   : FLOAT|INTEGER
   ;
