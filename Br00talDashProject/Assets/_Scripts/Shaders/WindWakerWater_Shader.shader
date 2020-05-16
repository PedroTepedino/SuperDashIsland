// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Br00talShaders/WindWakerWater_Shader"
{
	Properties
	{
		_WaterBaseColor("WaterBaseColor", Color) = (0.172549,0.172549,1,0)
		_FoamColor("FoamColor", Color) = (0.9372549,0.9764706,1,0)
		[NoScaleOffset]_WaterTexture("WaterTexture", 2D) = "white" {}
		_TextureSpeed("TextureSpeed", Vector) = (0,0,0,0)
		_WaterBaseColor2("WaterBaseColor2", Color) = (0.172549,0.172549,1,0)
		_FoamColor2("FoamColor2", Color) = (0,0,0.4352941,0)
		[NoScaleOffset]_WaterTexture2("WaterTexture2", 2D) = "white" {}
		_TextureSpeed2("TextureSpeed2", Vector) = (0,0,0,0)
		[HideInInspector][NoScaleOffset]_WaveTexture2("WaveTexture2", 2D) = "bump" {}
		_IntersectionColor("IntersectionColor", Color) = (0,0,0,0)
		_Distance("Distance", Range( 0 , 3)) = 0
		_WavesScale("WavesScale", Float) = 10
		_textureTile("textureTile", Vector) = (1,1,0,0)
		_WavesSpeed("WavesSpeed", Float) = 0.1
		_WaveTiling("WaveTiling", Float) = 0
		_CosFactor("Cos Factor", Float) = 0.2
		_ElipsisMultiplier("Elipsis Multiplier", Float) = 0.5
		_TextureDistortionTiling("Texture Distortion Tiling", Vector) = (0,0,0,0)
		_Cutoff("Cutoff", Range( 0 , 1)) = 0
		_WaveTilingAdd("WaveTilingAdd", Float) = 0
		_WaveDir("WaveDir", Vector) = (0,0,0,0)
		_WaveNoiseMultiplier("WaveNoiseMultiplier", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPosition241;
		};

		uniform float _WaveTiling;
		uniform float _WaveTilingAdd;
		uniform float _WavesSpeed;
		uniform float _WavesScale;
		uniform float _WaveNoiseMultiplier;
		uniform float4 _IntersectionColor;
		uniform float4 _WaterBaseColor;
		uniform float4 _FoamColor;
		uniform sampler2D _WaterTexture;
		uniform sampler2D _WaveTexture2;
		uniform float2 _TextureDistortionTiling;
		uniform float3 _TextureSpeed;
		uniform float2 _textureTile;
		uniform float _CosFactor;
		uniform float _ElipsisMultiplier;
		uniform float2 _WaveDir;
		uniform float4 _WaterBaseColor2;
		uniform float4 _FoamColor2;
		uniform sampler2D _WaterTexture2;
		uniform float3 _TextureSpeed2;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Distance;
		uniform float _Cutoff;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (( ( _SinTime.y * _WaveTiling ) + _WaveTilingAdd )).xx;
			float2 temp_cast_1 = (( _Time.y * _WavesSpeed )).xx;
			float2 uv_TexCoord327 = v.texcoord.xy * temp_cast_0 + temp_cast_1;
			float simplePerlin2D255 = snoise( uv_TexCoord327*_WavesScale );
			simplePerlin2D255 = simplePerlin2D255*0.5 + 0.5;
			float3 appendResult280 = (float3(0.0 , ( saturate( simplePerlin2D255 ) * _WaveNoiseMultiplier ) , 0.0));
			v.vertex.xyz += appendResult280;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos241 = ase_vertex3Pos;
			float4 ase_screenPos241 = ComputeScreenPos( UnityObjectToClipPos( vertexPos241 ) );
			o.screenPosition241 = ase_screenPos241;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord328 = i.uv_texcoord * _TextureDistortionTiling;
			float3 TextureDistortion313 = UnpackScaleNormal( tex2D( _WaveTexture2, uv_TexCoord328 ), 0.2 );
			float2 appendResult298 = (float2(( _CosTime.y * _CosFactor ) , ( _SinTime.y * 0.5 )));
			float2 uv_TexCoord81 = i.uv_texcoord * _textureTile + ( ( appendResult298 * _ElipsisMultiplier ) + _WaveDir );
			float4 lerpResult3 = lerp( _WaterBaseColor , _FoamColor , ( tex2D( _WaterTexture, ( TextureDistortion313 + ( _TextureSpeed + float3( uv_TexCoord81 ,  0.0 ) ) ).xy ) * 0.8 ));
			float4 lerpResult11 = lerp( _WaterBaseColor2 , _FoamColor2 , ( tex2D( _WaterTexture2, ( ( float3( uv_TexCoord81 ,  0.0 ) + _TextureSpeed2 ) + TextureDistortion313 ).xy ) * 0.8 ));
			float layeredBlendVar64 = 0.0;
			float4 layeredBlend64 = ( lerp( ( lerpResult3 + lerpResult11 ),float4( 0,0,0,0 ) , layeredBlendVar64 ) );
			float4 color236 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float4 ase_screenPos241 = i.screenPosition241;
			float4 ase_screenPosNorm241 = ase_screenPos241 / ase_screenPos241.w;
			ase_screenPosNorm241.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm241.z : ase_screenPosNorm241.z * 0.5 + 0.5;
			float screenDepth241 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm241.xy ));
			float distanceDepth241 = abs( ( screenDepth241 - LinearEyeDepth( ase_screenPosNorm241.z ) ) / ( _Distance ) );
			float4 lerpResult238 = lerp( _IntersectionColor , ( layeredBlend64 * color236 ) , (( saturate( distanceDepth241 ) >= _Cutoff ) ? 1.0 :  0.0 ));
			o.Emission = saturate( ( lerpResult238 * 1.0 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
7;7;2546;1004;350.2151;-411.5428;1.07;True;True
Node;AmplifyShaderEditor.CommentaryNode;309;-3210.028,609.8782;Inherit;False;1113;540;Elipsis Equation;11;334;304;305;298;303;302;301;306;307;300;335;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CosTime;300;-2983.028,659.8782;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;306;-3147.028,746.8782;Inherit;False;Property;_CosFactor;Cos Factor;15;0;Create;True;0;0;False;0;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;307;-3160.028,907.8782;Inherit;False;Constant;_SinFactor;SinFactor;19;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;301;-2972.028,812.8782;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;229;-3103.349,-85.09926;Inherit;False;1316.123;535.5415;TextureDistortion;7;320;319;310;313;134;328;318;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;302;-2769.028,741.8782;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;-2783.028,867.8782;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;318;-3043.149,137.42;Inherit;False;Property;_TextureDistortionTiling;Texture Distortion Tiling;17;0;Create;True;0;0;False;0;0,0;3,3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;298;-2558.028,802.8782;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;305;-2583.028,907.8782;Inherit;False;Property;_ElipsisMultiplier;Elipsis Multiplier;16;0;Create;True;0;0;False;0;0.5;0.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;-2388.028,828.8782;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;334;-2429.681,1000.505;Inherit;False;Property;_WaveDir;WaveDir;20;0;Create;True;0;0;False;0;0,0;1.43,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;328;-2738.821,186.7944;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;114;-2008.292,516.4592;Inherit;False;729.79;628;TexturesMoviments;6;264;82;83;89;81;88;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;264;-1981.444,710.3613;Inherit;False;Property;_textureTile;textureTile;12;0;Create;True;0;0;False;0;1,1;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;134;-2457.609,115.9007;Inherit;True;Property;_WaveTexture2;WaveTexture2;8;2;[HideInInspector];[NoScaleOffset];Create;True;0;0;False;0;None;dd2fd2df93418444c8e280f1d34deeb5;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;0.2;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;335;-2215.681,919.5051;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;89;-1644.292,573.4592;Inherit;False;Property;_TextureSpeed;TextureSpeed;3;0;Create;True;0;0;False;0;0,0,0;0.5,0.5,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;88;-1595.292,1000.459;Inherit;False;Property;_TextureSpeed2;TextureSpeed2;7;0;Create;True;0;0;False;0;0,0,0;0.1,0.1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;313;-2152.738,29.6908;Inherit;False;TextureDistortion;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;81;-1727.35,781.7365;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;314;-1496.533,391.0584;Inherit;False;313;TextureDistortion;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;83;-1432.502,868.7469;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;315;-1478.884,1170.973;Inherit;False;313;TextureDistortion;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-1432.802,696.5441;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;138;-1128.417,428.9613;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;56;-1006.871,-126.5945;Inherit;False;756;662;Layer1 of Water etc;5;5;7;1;3;339;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;57;-1005.836,641.7542;Inherit;False;750;662.0005;Layer2 of Water etc;5;8;10;9;11;341;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;130;-1128.769,1024.086;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1;-940.8713,307.4057;Inherit;True;Property;_WaterTexture;WaterTexture;2;1;[NoScaleOffset];Create;True;0;0;False;0;f9cdcc5c045a9324b9fd6676346b5656;f9cdcc5c045a9324b9fd6676346b5656;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;340;-994.6536,563.0698;Inherit;False;Constant;_Float0;Float 0;23;0;Create;True;0;0;False;0;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-938.8358,1063.755;Inherit;True;Property;_WaterTexture2;WaterTexture2;6;1;[NoScaleOffset];Create;True;0;0;False;0;f9cdcc5c045a9324b9fd6676346b5656;cdc759eef85cb78428dfe1591c10012d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;263;403.2323,1198.632;Inherit;False;1597.206;541.2604;WavesOffset Speed n Scale;15;280;255;262;267;268;274;327;273;250;251;332;333;336;337;338;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;5;-890.8712,-76.59441;Inherit;False;Property;_WaterBaseColor;WaterBaseColor;0;0;Create;True;0;0;False;0;0.172549,0.172549,1,0;0.172549,0.172549,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;339;-633.6536,414.0699;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SinTimeNode;268;419,1274;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;273;419,1418;Inherit;False;Property;_WaveTiling;WaveTiling;14;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-881.8712,109.4056;Inherit;False;Property;_FoamColor;FoamColor;1;0;Create;True;0;0;False;0;0.9372549,0.9764706,1,0;0.7971698,0.9239387,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;341;-636.6536,1119.07;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;9;-889.8356,691.7542;Inherit;False;Property;_WaterBaseColor2;WaterBaseColor2;4;0;Create;True;0;0;False;0;0.172549,0.172549,1,0;0.172549,0.172549,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;249;400.9946,382.3687;Inherit;False;1631.452;708.2202;Intersection Effect and Color;13;240;247;244;238;246;237;239;330;331;242;236;241;344;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;10;-888.8356,880.7542;Inherit;False;Property;_FoamColor2;FoamColor2;5;0;Create;True;0;0;False;0;0,0,0.4352941,0;0.08721964,0.08721964,0.5283019,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;274;611,1290;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;250;425.4671,1557.416;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;3;-515.8713,178.4055;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;240;439.1385,980.8878;Inherit;False;Property;_Distance;Distance;10;0;Create;True;0;0;False;0;0;0.5;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;248;-156.1958,486.4467;Inherit;False;512.9369;206;Layer 1 + Layer 2 = Same Layer;2;63;64;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;344;439.4651,834.8132;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;251;432.0664,1653.85;Inherit;False;Property;_WavesSpeed;WavesSpeed;13;0;Create;True;0;0;False;0;0.1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;11;-520.8358,873.7542;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;333;543.0319,1484.586;Inherit;False;Property;_WaveTilingAdd;WaveTilingAdd;19;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-106.1958,554.759;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;241;727.3101,893.0629;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;267;642.7856,1564.383;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;332;731.0319,1400.586;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;9.07;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;262;1021.987,1588.965;Inherit;False;Property;_WavesScale;WavesScale;11;0;Create;True;0;0;False;0;10;0.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LayeredBlendNode;64;130.7411,536.4467;Inherit;False;6;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;327;912.4655,1379.293;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;236;647.2498,720.5259;Inherit;False;Constant;_Just2SeeIt;Just2SeeIt;13;0;Create;True;0;0;False;0;1,1,1,0;0.9372549,0.9764706,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;242;977.3611,791.6644;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;331;868.0378,1012.301;Inherit;False;Property;_Cutoff;Cutoff;18;0;Create;True;0;0;False;0;0;0.044;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;237;962.3747,652.9377;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCCompareGreaterEqual;330;1139.038,742.3011;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;255;1259.212,1394.298;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;36.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;239;928.2064,451.3687;Inherit;False;Property;_IntersectionColor;IntersectionColor;9;0;Create;True;0;0;False;0;0,0,0,0;0.9372549,0.9764706,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;338;1390.81,1644.324;Inherit;False;Property;_WaveNoiseMultiplier;WaveNoiseMultiplier;21;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;336;1529.81,1473.324;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;246;1515.954,826.616;Inherit;False;Constant;_Power;Power;13;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;238;1343.588,611.5379;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;244;1601.967,637.0778;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;337;1668.81,1521.324;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;247;1857.447,657.1968;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;320;-2720.394,17.94205;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;310;-3083.085,-25.72449;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;280;1802.75,1423.898;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;319;-2864.394,-26.05795;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;203;2225.363,1137.462;Float;False;True;2;ASEMaterialInspector;0;0;Standard;Br00talShaders/WindWakerWater_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.044;True;False;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;302;0;300;2
WireConnection;302;1;306;0
WireConnection;303;0;301;2
WireConnection;303;1;307;0
WireConnection;298;0;302;0
WireConnection;298;1;303;0
WireConnection;304;0;298;0
WireConnection;304;1;305;0
WireConnection;328;0;318;0
WireConnection;134;1;328;0
WireConnection;335;0;304;0
WireConnection;335;1;334;0
WireConnection;313;0;134;0
WireConnection;81;0;264;0
WireConnection;81;1;335;0
WireConnection;83;0;81;0
WireConnection;83;1;88;0
WireConnection;82;0;89;0
WireConnection;82;1;81;0
WireConnection;138;0;314;0
WireConnection;138;1;82;0
WireConnection;130;0;83;0
WireConnection;130;1;315;0
WireConnection;1;1;138;0
WireConnection;8;1;130;0
WireConnection;339;0;1;0
WireConnection;339;1;340;0
WireConnection;341;0;8;0
WireConnection;341;1;340;0
WireConnection;274;0;268;2
WireConnection;274;1;273;0
WireConnection;3;0;5;0
WireConnection;3;1;7;0
WireConnection;3;2;339;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;11;2;341;0
WireConnection;63;0;3;0
WireConnection;63;1;11;0
WireConnection;241;1;344;0
WireConnection;241;0;240;0
WireConnection;267;0;250;0
WireConnection;267;1;251;0
WireConnection;332;0;274;0
WireConnection;332;1;333;0
WireConnection;64;1;63;0
WireConnection;327;0;332;0
WireConnection;327;1;267;0
WireConnection;242;0;241;0
WireConnection;237;0;64;0
WireConnection;237;1;236;0
WireConnection;330;0;242;0
WireConnection;330;1;331;0
WireConnection;255;0;327;0
WireConnection;255;1;262;0
WireConnection;336;0;255;0
WireConnection;238;0;239;0
WireConnection;238;1;237;0
WireConnection;238;2;330;0
WireConnection;244;0;238;0
WireConnection;244;1;246;0
WireConnection;337;0;336;0
WireConnection;337;1;338;0
WireConnection;247;0;244;0
WireConnection;320;0;319;0
WireConnection;280;1;337;0
WireConnection;319;0;310;1
WireConnection;319;1;310;3
WireConnection;203;2;247;0
WireConnection;203;11;280;0
ASEEND*/
//CHKSM=85EE86808E071FB0CBB7BB0D463AD497D42DE774