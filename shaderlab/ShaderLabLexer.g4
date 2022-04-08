
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

lexer grammar ShaderLabLexer;

options {
    caseInsensitive = true;
}

// Keywords
TwoD : '2D';
TwoDArray : '2DArray';
ThreeD : '3D';
A : 'A';
Add : 'Add';
AlphaTest : 'AlphaTest';
AlphaToMask : 'AlphaToMask';
Always : 'Always';
Ambient : 'Ambient';
AmbientAndDiffuse : 'AmbientAndDiffuse';
B : 'B';
BA : 'BA';
Back : 'Back';
BGA : 'BGA';
Bind : 'Bind';
BindChannels : 'BindChannels';
Blend : 'Blend';
BlendOp : 'BlendOp';
Category : 'Category';
Color : 'Color';
ColorBurn : 'ColorBurn';
ColorDodge : 'ColorDodge';
ColorMask : 'ColorMask';
ColorMaterial : 'ColorMaterial';
Combine : 'combine';
Comp : 'Comp';
CompBack : 'CompBack';
CompFront : 'CompFront';
Conservative : 'Conservative';
Constant : 'constant';
Cube : 'Cube';
CubeArray : 'CubeArray';
Cull : 'Cull';
CustomEditor : 'CustomEditor';
CustomEditorForRenderPipeline : 'CustomEditorForRenderPipeline';
Darken : 'Darken';
DecrSat : 'DecrSat';
DecrWrap : 'DecrWrap';
Difference : 'Difference';
Diffuse : 'Diffuse';
DstAlpha : 'DstAlpha';
DstColor : 'DstColor';
Emission : 'Emission';
Enum : 'Enum';
Equal : 'Equal';
Exclusion : 'Exclusion';
Fail : 'Fail';
FailBack : 'FailBack';
FailFront : 'FailFront';
Fallback : 'Fallback';
False : 'False';
Float : 'Float';
Fog : 'Fog';
Front : 'Front';
G : 'G';
GA : 'GA';
Gamma : 'Gamma';
GB : 'GB';
GEqual : 'GEqual';
Global : 'Global';
GrabPass : 'GrabPass';
Greater : 'Greater';
HardLight : 'HardLight';
HDR : 'HDR';
HideInInspector : 'HideInInspector';
HSLColor : 'HSLColor';
HSLHue : 'HSLHue';
HSLLuminosity : 'HSLLuminosity';
HSLSaturation : 'HSLSaturation';
IncrSat : 'IncrSat';
IncrWrap : 'IncrWrap';
Int : 'Int';
IntRange : 'IntRange';
Invert : 'Invert';
Keep : 'Keep';
KeywordEnum : 'KeywordEnum';
LEqual : 'LEqual';
Lerp : 'lerp';
Less : 'Less';
Lighten : 'Lighten';
Lighting : 'Lighting';
LOD : 'LOD';
LogicalAnd : 'LogicalAnd';
LogicalAndInverted : 'LogicalAndInverted';
LogicalAndReverse : 'LogicalAndReverse';
LogicalClear : 'LogicalClear';
LogicalCopy : 'LogicalCopy';
LogicalCopyInverted : 'LogicalCopyInverted';
LogicalEquiv : 'LogicalEquiv';
LogicalInvert : 'LogicalInvert';
LogicalNand : 'LogicalNand';
LogicalNoop : 'LogicalNoop';
LogicalNor : 'LogicalNor';
LogicalOr : 'LogicalOr';
LogicalOrInverted : 'LogicalOrInverted';
LogicalOrReverse : 'LogicalOrReverse';
LogicalSet : 'LogicalSet';
LogicalXor : 'LogicalXor';
MainColor : 'MainColor';
MainTexture : 'MainTexture';
Material : 'Material';
Max : 'Max';
Min : 'Min';
Multiply : 'Multiply';
Name : 'Name';
Never : 'Never';
Normal : 'Normal';
NoScaleOffset : 'NoScaleOffset';
NotEqual : 'NotEqual';
Off : 'Off';
Offset : 'Offset';
On : 'On';
One : 'One';
OneMinusDstAlpha : 'OneMinusDstAlpha';
OneMinusDstColor : 'OneMinusDstColor';
OneMinusSrcAlpha : 'OneMinusSrcAlpha';
OneMinusSrcColor : 'OneMinusSrcColor';
Overlay : 'Overlay';
Pass : 'Pass';
PassBack : 'PassBack';
PassFront : 'PassFront';
PerRendererData : 'PerRendererData';
PowerSlider : 'PowerSlider';
Previous : 'previous';
Primary : 'primary';
Properties : 'Properties';
R : 'R';
RA : 'RA';
Range : 'Range';
RB : 'RB';
RBA : 'RBA';
ReadMask : 'ReadMask';
Ref : 'Ref';
Replace : 'Replace';
RevSub : 'RevSub';
RG : 'RG';
RGA : 'RGA';
RGB : 'RGB';
RGBA : 'RGBA';
Screen : 'Screen';
SeparateSpecular : 'SeparateSpecular';
SetTexture : 'SetTexture';
Shader : 'Shader';
Shininess : 'Shininess';
SoftLight : 'SoftLight';
Specular : 'Specular';
SrcAlpha : 'SrcAlpha';
SrcColor : 'SrcColor';
Stencil : 'Stencil';
Sub : 'Sub';
SubShader : 'SubShader';
Tags : 'Tags';
Tangent : 'Tangent';
Texcoord : 'Texcoord';
TexcoordN : 'Texcoord' Digit+;
Texture : 'texture';
Toggle : 'Toggle';
ToggleOff : 'ToggleOff';
True : 'True';
UsePass : 'UsePass';
Vector : 'Vector';
Vertex : 'Vertex';
WriteMask : 'WriteMask';
ZClip : 'ZClip';
Zero : 'Zero';
ZFail : 'ZFail';
ZFailBack : 'ZFailBack';
ZFailFront : 'ZFailFront';
ZTest : 'ZTest';
ZWrite : 'ZWrite';

INTEGER
   :  Digit+
   ;

// TODO: What sort of floating point numbers are actually supported?
FLOAT
   :  Digit+ ( '.' Digit* )
   |  '.' Digit+
   ;

// I verified that Unity doesn't support backslash escaped strings.
// It may support some _other_ escape character...
STRING
   : '"'
     (~'"')*
     '"'
   ;

CGPROGRAM : 'CGPROGRAM' -> pushMode(CG_BLOCK);
CGINCLUDE : 'CGINCLUDE' -> pushMode(CG_BLOCK);

HLSLPROGRAM : 'HLSLPROGRAM' -> pushMode(HLSL_BLOCK);
HLSLINCLUDE : 'HLSLINCLUDE' -> pushMode(HLSL_BLOCK);

IDENTIFIER : CLikeIdentifier;

PLUS : '+';
MINUS : '-';
TIMES : '*';
OPEN_PAREN : '(';
CLOSE_PAREN : ')';
OPEN_BRACE : '{';
CLOSE_BRACE : '}';
OPEN_BRACKET : '[';
CLOSE_BRACKET : ']';
EQUALS : '=';
COMMA : ',';

WS : [ \n\u000D] -> skip; // same as [ \n\r]
LINE_COMMENT : CLikeLineComment -> skip;
BLOCK_COMMENT : CLikeBlockComment -> skip;

fragment CLikeLineComment : '//' ~[\r\n]* '\r'? '\n';
fragment CLikeBlockComment : '/*' (('*' ~'/') | ~'*')* '*/';

fragment CLikeString
   : '"'
     (  ~( '"' | '\\' )
     |  '\\'
        (  'a' | 'b' | 'e' | 'f' | 'n' | 'r' | 't' | 'v' | '\\' | '\'' | '"' | '?'
        |  OctalDigit OctalDigit OctalDigit
        |  'x' HexDigit HexDigit
        |  'u' HexDigit HexDigit HexDigit HexDigit
        |  'U' HexDigit HexDigit HexDigit HexDigit HexDigit HexDigit HexDigit HexDigit
        )
     )
     '"'
   ;

fragment CLikeIdentifier : IdentifierStartChar IdentifierChar*;

fragment Digit : [0-9];
fragment OctalDigit : [0-7];
fragment HexDigit : [0-9a-fA-F];
fragment IdentifierStartChar : [_A-Za-z];
fragment IdentifierChar : [_A-Za-z0-9];
fragment NonWhiteSpace : (~[ \t\r\n])+;

// I could just merge the two code block types as it is right now, but it seems like it
// might be nice to actually parse the respective languages in the future.

mode CG_BLOCK;

   CG_WS : [ \n\u000D] -> skip; // same as [ \n\r]
   CG_LineComment : CLikeLineComment -> skip;
   CG_BlockComment : CLikeBlockComment -> skip;
   CG_String : CLikeString;
   ENDCG : 'ENDCG' -> popMode;
   CG_Identifier : CLikeIdentifier;
   CG_OtherNonWS : NonWhiteSpace;

mode HLSL_BLOCK;

   HLSL_WS : [ \n\u000D] -> skip; // same as [ \n\r]
   HLSL_LineComment : CLikeLineComment -> skip;
   HLSL_BlockComment : CLikeBlockComment -> skip;
   HLSL_String : CLikeString;
   ENDHLSL : 'ENDHLSL' -> popMode;
   HLSL_Identifier : CLikeIdentifier;
   HLSL_OtherNonWS : NonWhiteSpace;
