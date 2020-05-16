// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Br00talShaders/ToonFire"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Cheese("Cheese", 2D) = "white" {}
		_Noise1Speed("Noise 1 Speed", Float) = -1
		_Noise1Scale("Noise 1 Scale", Float) = 1
		_Noise2Scale("Noise 2 Scale", Float) = 0.5
		_Noise2Speed("Noise 2 Speed", Float) = -2
		_Mask("Mask", 2D) = "white" {}
		_TextureSample3("Texture Sample 3", 2D) = "white" {}
		_InnerFlameStep("Inner Flame Step", Range( 0 , 1)) = 0
		_InnerColor("Inner Color", Color) = (0,0,0,0)
		_OuterColor("Outer Color", Color) = (0,0,0,0)
		_TopColor("TopColor", Color) = (0.2235294,0,0.5058824,0)
		_OuterColorBlend("Outer Color Blend", Range( 0 , 1)) = 0
		_PremultiplyBlend("Premultiply Blend", Range( 0 , 1)) = 0.5
		_OpacityCutoff("Opacity Cutoff", Range( 0 , 1)) = 0.3
		_OpacityStep("Opacity Step", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _OuterColor;
		uniform float _OuterColorBlend;
		uniform float4 _TopColor;
		uniform float _InnerFlameStep;
		uniform sampler2D _TextureSample3;
		uniform float _Noise1Speed;
		uniform float _Noise1Scale;
		uniform sampler2D _Cheese;
		uniform float _Noise2Speed;
		uniform float _Noise2Scale;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform float4 _InnerColor;
		uniform float _PremultiplyBlend;
		uniform float _OpacityStep;
		uniform float _OpacityCutoff;
		uniform float _Cutoff = 0.5;


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
			float smoothstepResult38 = smoothstep( 0.0 , _OuterColorBlend , i.uv_texcoord.y);
			float2 appendResult8 = (float2(0.0 , _Noise1Speed));
			float2 uv_TexCoord6 = i.uv_texcoord * float2( 1.5,1 );
			float2 panner5 = ( 1.0 * _Time.y * appendResult8 + ( _Noise1Scale * uv_TexCoord6 ));
			float simplePerlin2D52 = snoise( panner5*_Noise1Speed );
			simplePerlin2D52 = simplePerlin2D52*0.5 + 0.5;
			float2 appendResult14 = (float2(0.0 , _Noise2Speed));
			float2 panner16 = ( 1.0 * _Time.y * appendResult14 + ( uv_TexCoord6 * _Noise2Scale ));
			float simplePerlin2D48 = snoise( panner16*_Noise2Speed );
			simplePerlin2D48 = simplePerlin2D48*0.5 + 0.5;
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			float4 tex2DNode22 = tex2D( _Mask, uv_Mask );
			float2 appendResult23 = (float2(( ( ( ( simplePerlin2D52 * tex2D( _Cheese, panner5 ).r ) * ( tex2D( _Cheese, panner16 ).r * simplePerlin2D48 ) ) + tex2DNode22.r ) * tex2DNode22.r ) , 0.0));
			o.Emission = ( ( ( ( _OuterColor * ( 1.0 - smoothstepResult38 ) ) + ( smoothstepResult38 * _TopColor ) ) * ( 1.0 - step( _InnerFlameStep , tex2D( _TextureSample3, appendResult23 ).r ) ) ) + ( _InnerColor * step( _InnerFlameStep , tex2D( _TextureSample3, appendResult23 ).r ) ) ).rgb;
			float smoothstepResult84 = smoothstep( 0.0 , 1.0 , saturate( ( _PremultiplyBlend + step( _OpacityStep , tex2D( _TextureSample3, appendResult23 ).r ) ) ));
			o.Alpha = smoothstepResult84;
			float smoothstepResult83 = smoothstep( 0.0 , 1.0 , step( _OpacityCutoff , step( _OpacityStep , tex2D( _TextureSample3, appendResult23 ).r ) ));
			clip( smoothstepResult83 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
7;1;2546;1010;745.8094;181.551;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;54;-3033.326,-182.1939;Inherit;False;1433.146;777.5099;Comment;19;7;6;9;12;13;11;10;8;14;1;5;16;17;48;3;51;53;18;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2983.326,-77.06339;Inherit;False;Property;_Noise1Speed;Noise 1 Speed;2;0;Create;True;0;0;False;0;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-2956.326,125.9367;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.5,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-2956.326,31.93667;Inherit;False;Property;_Noise1Scale;Noise 1 Scale;3;0;Create;True;0;0;False;0;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-2942.627,271.9078;Inherit;False;Property;_Noise2Scale;Noise 2 Scale;4;0;Create;True;0;0;False;0;0.5;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2938.627,358.9078;Inherit;False;Property;_Noise2Speed;Noise 2 Speed;5;0;Create;True;0;0;False;0;-2;-1.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-2757.326,-94.06339;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-2698.627,341.9078;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-2725.326,57.93667;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2702.627,249.9077;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;16;-2479.627,301.9078;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;5;-2457.463,-55.02578;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;1;-2524.367,97.35529;Inherit;True;Property;_Cheese;Cheese;1;0;Create;True;0;0;False;0;1bf1cb9d09dd1314ebfa646bbc7de568;1bf1cb9d09dd1314ebfa646bbc7de568;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;3;-2183.839,-42.78027;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;48;-2223.373,458.116;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-2254.231,245.6354;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;52;-2216.776,-132.1939;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-1893.319,-32.54382;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1946.756,345.3213;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1764.98,106.4626;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;-1501.938,248.3694;Inherit;True;Property;_Mask;Mask;6;0;Create;True;0;0;False;0;None;6019833fefada0f4cb3790531c2719d2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-1207.959,104.3584;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1062.458,106.3246;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;46;-1034.273,-716.6506;Inherit;False;1247.946;646.4362;Comment;9;39;37;38;32;40;41;43;44;45;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-893.3634,108.2908;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-933.6693,-539.0125;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;39;-984.2731,-351.4817;Inherit;False;Property;_OuterColorBlend;Outer Color Blend;12;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;24;-743.2678,88.79755;Inherit;True;Property;_TextureSample3;Texture Sample 3;7;0;Create;True;0;0;False;0;None;a73cc3a99dc4bfd4a948c8f0a7f524ef;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;38;-673.21,-433.3403;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-390.6936,197.2793;Inherit;False;Property;_OpacityStep;Opacity Step;16;0;Create;True;0;0;False;0;0;0.641;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;25;-245.2066,119.9295;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-390.7916,35.49827;Inherit;False;Property;_InnerFlameStep;Inner Flame Step;8;0;Create;True;0;0;False;0;0;0.9;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;-375.4186,-466.8808;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;29;-81.69883,61.77887;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;44;-390.5289,-275.2145;Inherit;False;Property;_TopColor;TopColor;11;0;Create;True;0;0;False;0;0.2235294,0,0.5058824,0;1,0.7812411,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;60;72.69591,161.7748;Inherit;False;655.1469;315.6;Comment;6;56;55;59;58;57;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;32;-395.1112,-666.6506;Inherit;False;Property;_OuterColor;Outer Color;10;0;Create;True;0;0;False;0;0,0,0,0;1,0,0.1062551,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;30;-81.69881,155.7801;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-139.6778,-377.7522;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RelayNode;42;74.36369,69.00015;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-114.4186,-566.881;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RelayNode;55;249.2427,280.7748;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;131.6959,203.1216;Inherit;False;Property;_PremultiplyBlend;Premultiply Blend;13;0;Create;True;0;0;False;0;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;56;468.2427,210.7748;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;58.07335,-471.1346;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;31;293.0983,-158.8994;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;35;300.5137,-68.24721;Inherit;False;Property;_InnerColor;Inner Color;9;0;Create;True;0;0;False;0;0,0,0,0;0.8113208,0.6770404,0.1722143,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;57;222.2427,362.7748;Inherit;False;Property;_OpacityCutoff;Opacity Cutoff;15;0;Create;True;0;0;False;0;0.3;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;560.5213,48.14643;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;58;572.2427,322.7748;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;59;585.2427,207.7748;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;79;-1257.354,1087.901;Inherit;False;782.8;338.4;Comment;5;73;74;75;76;77;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;541.1103,-189.5536;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;78;-1227.367,565.8241;Inherit;False;797.3366;495.7986;Comment;6;66;72;70;67;69;71;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;84;876.1906,185.449;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-921.3542,1153.901;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-639.3543,1147.901;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;70;-1174.429,861.2927;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;77;-811.3543,1239.901;Inherit;False;Constant;_Float0;Float 0;15;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;83;911.1906,318.449;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-257.6942,919.1594;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PosVertexDataNode;75;-1182.354,1248.901;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-594.8303,698.6909;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;711.6335,-94.64941;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalizeNode;72;-758.429,860.2927;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;69;-1177.367,715.0921;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;66;-1170.434,615.8241;Inherit;False;Property;_PushForward;Push Forward;14;0;Create;True;0;0;False;0;0;0.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;71;-894.4289,857.2927;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BillboardNode;73;-1207.354,1137.901;Inherit;False;Cylindrical;False;0;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;82;1361.058,-6.989059;Float;False;True;2;ASEMaterialInspector;0;0;Standard;Br00talShaders/ToonFire;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;1;7;0
WireConnection;14;1;13;0
WireConnection;10;0;9;0
WireConnection;10;1;6;0
WireConnection;11;0;6;0
WireConnection;11;1;12;0
WireConnection;16;0;11;0
WireConnection;16;2;14;0
WireConnection;5;0;10;0
WireConnection;5;2;8;0
WireConnection;3;0;1;0
WireConnection;3;1;5;0
WireConnection;48;0;16;0
WireConnection;48;1;13;0
WireConnection;17;0;1;0
WireConnection;17;1;16;0
WireConnection;52;0;5;0
WireConnection;52;1;7;0
WireConnection;53;0;52;0
WireConnection;53;1;3;1
WireConnection;51;0;17;1
WireConnection;51;1;48;0
WireConnection;18;0;53;0
WireConnection;18;1;51;0
WireConnection;20;0;18;0
WireConnection;20;1;22;1
WireConnection;21;0;20;0
WireConnection;21;1;22;1
WireConnection;23;0;21;0
WireConnection;24;1;23;0
WireConnection;38;0;37;2
WireConnection;38;2;39;0
WireConnection;25;0;24;1
WireConnection;40;0;38;0
WireConnection;29;0;26;0
WireConnection;29;1;25;0
WireConnection;30;0;28;0
WireConnection;30;1;25;0
WireConnection;43;0;38;0
WireConnection;43;1;44;0
WireConnection;42;0;29;0
WireConnection;41;0;32;0
WireConnection;41;1;40;0
WireConnection;55;0;30;0
WireConnection;56;0;47;0
WireConnection;56;1;55;0
WireConnection;45;0;41;0
WireConnection;45;1;43;0
WireConnection;31;0;42;0
WireConnection;36;0;35;0
WireConnection;36;1;42;0
WireConnection;58;0;57;0
WireConnection;58;1;55;0
WireConnection;59;0;56;0
WireConnection;33;0;45;0
WireConnection;33;1;31;0
WireConnection;84;0;59;0
WireConnection;74;0;73;0
WireConnection;74;1;75;0
WireConnection;76;0;77;0
WireConnection;76;1;74;0
WireConnection;83;0;58;0
WireConnection;68;0;67;0
WireConnection;68;1;76;0
WireConnection;67;0;66;0
WireConnection;67;1;72;0
WireConnection;34;0;33;0
WireConnection;34;1;36;0
WireConnection;72;0;71;0
WireConnection;71;0;69;0
WireConnection;71;1;70;0
WireConnection;82;2;34;0
WireConnection;82;9;84;0
WireConnection;82;10;83;0
ASEEND*/
//CHKSM=F679555D7AE12553E8651CD953E6475945DE9E39