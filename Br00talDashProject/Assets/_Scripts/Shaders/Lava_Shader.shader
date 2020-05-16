// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Br00talShaders/Lava_Shader"
{
	Properties
	{
		[HDR]_LavaColor("LavaColor", Color) = (8,1.160784,0,1)
		_NoiseScale("NoiseScale", Float) = 100
		_Power("Power", Float) = 0
		[HDR]_MovimentSpeed("MovimentSpeed", Vector) = (0,0.5,0,0)
		_MovimentSpeed1("MovimentSpeed1", Vector) = (0,-0.5,0,0)
		[HDR]_IntersectionColor1("IntersectionColor", Color) = (0,0,0,0)
		_Distance1("Distance", Range( 0 , 3)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float4 _IntersectionColor1;
		uniform float _Power;
		uniform float2 _MovimentSpeed;
		uniform float _NoiseScale;
		uniform float2 _MovimentSpeed1;
		uniform float4 _LavaColor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Distance1;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float simplePerlin2D7 = snoise( ( ( _MovimentSpeed * _Time.y ) + i.uv_texcoord )*_NoiseScale );
			simplePerlin2D7 = simplePerlin2D7*0.5 + 0.5;
			float simplePerlin2D6 = snoise( ( i.uv_texcoord + ( _Time.y * _MovimentSpeed1 ) )*_NoiseScale );
			simplePerlin2D6 = simplePerlin2D6*0.5 + 0.5;
			float4 temp_cast_1 = (( simplePerlin2D7 * simplePerlin2D6 )).xxxx;
			float div4=256.0/float((int)_Power);
			float4 posterize4 = ( floor( temp_cast_1 * div4 ) / div4 );
			float4 color23 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth24 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth24 = abs( ( screenDepth24 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Distance1 ) );
			float4 lerpResult29 = lerp( _IntersectionColor1 , ( ( posterize4 * _LavaColor ) * color23 ) , saturate( distanceDepth24 ));
			o.Emission = saturate( ( lerpResult29 * 1.0 ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
1373;7;1666;974;-11.36597;301.0232;1.3897;True;False
Node;AmplifyShaderEditor.Vector2Node;18;-1850,384.5;Inherit;False;Property;_MovimentSpeed1;MovimentSpeed1;5;0;Create;True;0;0;False;0;0,-0.5;0,-0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;19;-1843,1.5;Inherit;False;Property;_MovimentSpeed;MovimentSpeed;4;1;[HDR];Create;True;0;0;False;0;0,0.5;0,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;17;-1945,162.5;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1529,300.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-1529,-0.5;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1619,128.5;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-1294,96.5;Inherit;False;Property;_NoiseScale;NoiseScale;2;0;Create;True;0;0;False;0;100;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-1258,-85.5;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-1256,257.5;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;7;-1081,1.5;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;6;-1080,128.5;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-764,130.5;Inherit;False;Property;_Power;Power;3;0;Create;True;0;0;False;0;0;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-760,2.5;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;21;12.57029,-121.5525;Inherit;False;1519.452;775.2202;Intersection Effect and Color;10;31;30;29;28;27;26;25;24;23;22;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosterizeNode;4;-526,44.5;Inherit;False;8;2;1;COLOR;0,0,0,0;False;0;INT;8;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;3;-565,255.5;Inherit;False;Property;_LavaColor;LavaColor;0;1;[HDR];Create;True;0;0;False;0;8,1.160784,0,1;8,1.380392,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;62.57029,538.6668;Inherit;False;Property;_Distance1;Distance;7;0;Create;True;0;0;False;0;0;1;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-247,131.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;23;146.8254,216.605;Inherit;False;Constant;_Just2SeeIt1;Just2SeeIt;13;0;Create;True;0;0;False;0;1,1,1,0;0.9372549,0.9764706,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;24;334.5702,410.6679;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;26;594.7524,325.7534;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;461.9502,149.0167;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;27;397.7822,-71.55242;Inherit;False;Property;_IntersectionColor1;IntersectionColor;6;1;[HDR];Create;True;0;0;False;0;0,0,0,0;4,0.5276997,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;846.5294,275.695;Inherit;False;Constant;_Power1;Power;13;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;29;843.1635,107.6169;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;1101.543,133.1568;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;31;1357.023,153.2758;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1704.41,-123.3342;Float;False;True;2;ASEMaterialInspector;0;0;Standard;Br00talShaders/Lava_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;14;0;17;0
WireConnection;14;1;18;0
WireConnection;13;0;19;0
WireConnection;13;1;17;0
WireConnection;10;0;13;0
WireConnection;10;1;11;0
WireConnection;9;0;11;0
WireConnection;9;1;14;0
WireConnection;7;0;10;0
WireConnection;7;1;8;0
WireConnection;6;0;9;0
WireConnection;6;1;8;0
WireConnection;5;0;7;0
WireConnection;5;1;6;0
WireConnection;4;1;5;0
WireConnection;4;0;20;0
WireConnection;2;0;4;0
WireConnection;2;1;3;0
WireConnection;24;0;22;0
WireConnection;26;0;24;0
WireConnection;25;0;2;0
WireConnection;25;1;23;0
WireConnection;29;0;27;0
WireConnection;29;1;25;0
WireConnection;29;2;26;0
WireConnection;30;0;29;0
WireConnection;30;1;28;0
WireConnection;31;0;30;0
WireConnection;0;2;31;0
ASEEND*/
//CHKSM=945AE63D5F40D52D62F257216FA4A86C83342C43