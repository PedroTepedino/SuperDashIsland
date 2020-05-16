// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Br00talShaders/ToonFireTest"
{
	Properties
	{
		_Color("Color", Color) = (0,0,0,0)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			half filler;
		};

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _Color.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
0;0;2560;1018;1111.813;427.1245;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;49;-2547.607,372.3168;Inherit;False;797.3366;495.7986;Comment;6;66;64;63;57;56;55;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1;-4353.566,-375.7012;Inherit;False;1433.146;777.5099;Comment;19;20;19;18;17;16;15;14;13;12;11;10;9;8;7;6;5;4;3;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;39;-1247.545,-31.73251;Inherit;False;655.1469;315.6;Comment;6;60;59;51;47;46;45;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;52;-2577.595,894.3937;Inherit;False;782.8;338.4;Comment;5;65;62;61;58;53;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;24;-2354.514,-910.1578;Inherit;False;1247.946;646.4362;Comment;9;44;38;37;36;35;34;30;28;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;15;-3574.471,52.12811;Inherit;True;Property;_TextureSample2;Texture Sample 1;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;14;-3543.614,264.6087;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;13;-3799.868,108.4005;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;12;-3777.704,-248.5331;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;11;-3844.608,-96.15202;Inherit;True;Property;_Cheese1;Cheese;0;0;Create;True;0;0;False;0;1bf1cb9d09dd1314ebfa646bbc7de568;1bf1cb9d09dd1314ebfa646bbc7de568;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-4045.567,-135.5706;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-4077.567,-287.5707;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;34;-1715.352,-860.1578;Inherit;False;Property;_OuterColor1;Outer Color;9;0;Create;True;0;0;False;0;0,0,0,0;1,0,0.1062551,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;7;-4018.868,148.4005;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-4258.867,165.4005;Inherit;False;Property;_Noise2Speed1;Noise 2 Speed;4;0;Create;True;0;0;False;0;-2;-1.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-4262.867,78.40051;Inherit;False;Property;_Noise2Scale1;Noise 2 Scale;3;0;Create;True;0;0;False;0;0.5;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-4276.566,-161.5706;Inherit;False;Property;_Noise1Scale1;Noise 1 Scale;2;0;Create;True;0;0;False;0;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-4022.868,56.40041;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;16;-3537.016,-325.7012;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-3085.22,-87.0447;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-3266.997,151.814;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-4276.566,-67.57059;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1.5,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;21;-2822.179,54.86211;Inherit;True;Property;_Mask1;Mask;5;0;Create;True;0;0;False;0;None;6019833fefada0f4cb3790531c2719d2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-2528.2,-89.1489;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-2382.699,-87.1827;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;25;-2213.604,-85.2165;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-2253.91,-732.5198;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;27;-2063.509,-104.7098;Inherit;True;Property;_TextureSample4;Texture Sample 3;6;0;Create;True;0;0;False;0;None;a73cc3a99dc4bfd4a948c8f0a7f524ef;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;-2304.514,-544.989;Inherit;False;Property;_OuterColorBlend1;Outer Color Blend;11;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;29;-1565.447,-73.5778;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;30;-1993.451,-626.8476;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1711.032,-158.009;Inherit;False;Property;_InnerFlameStep1;Inner Flame Step;7;0;Create;True;0;0;False;0;0;0.9;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1710.934,3.771997;Inherit;False;Property;_OpacityStep1;Opacity Step;15;0;Create;True;0;0;False;0;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-3504.08,-236.2876;Inherit;True;Property;_TextureSample1;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-3213.56,-226.0511;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-4303.566,-270.5707;Inherit;False;Property;_Noise1Speed1;Noise 1 Speed;1;0;Create;True;0;0;False;0;-1;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;-1577.935,725.6522;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-1959.595,954.3937;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-779.1302,-383.0609;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;-907.9979,18.2675;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;46;-1070.998,87.26751;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1197.545,19.6143;Inherit;False;Property;_PremultiplyBlend1;Premultiply Blend;12;0;Create;True;0;0;False;0;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-1262.167,-664.6419;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;43;-1019.727,-261.7545;Inherit;False;Property;_InnerColor1;Inner Color;8;0;Create;True;0;0;False;0;0,0,0,0;0.8113208,0.6770404,0.1722143,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RelayNode;41;-1245.877,-124.5071;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;40;-1401.939,-37.7272;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1459.918,-571.2595;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1434.659,-760.3882;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;42;-1027.142,-352.4067;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;33;-1401.939,-131.7284;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1097.998,169.2675;Inherit;False;Property;_OpacityCutoff1;Opacity Cutoff;14;0;Create;True;0;0;False;0;0.3;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;36;-1710.77,-468.7218;Inherit;False;Property;_TopColor1;TopColor;10;0;Create;True;0;0;False;0;0.2235294,0,0.5058824,0;1,0.7812411,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;68;-462.813,-84.12451;Inherit;False;Property;_Color;Color;16;0;Fetch;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;54;-608.607,-288.1567;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;55;-2497.608,521.5848;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;56;-2494.67,667.7855;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;57;-2214.669,663.7855;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BillboardNode;58;-2527.595,944.3937;Inherit;False;Cylindrical;False;0;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;59;-752.9979,113.2675;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;60;-765.9979,30.26749;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;61;-2502.595,1055.394;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-2241.595,960.3937;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;63;-2078.67,666.7855;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-1915.071,505.1836;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-2131.595,1046.394;Inherit;False;Constant;_Float1;Float 0;15;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-759.7193,-145.3609;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;35;-1695.659,-660.3881;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-2490.675,422.3168;Inherit;False;Property;_PushForward1;Push Forward;13;0;Create;True;0;0;False;0;0;0.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;ASEMaterialInspector;0;0;Standard;Br00talShaders/ToonFireTest;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;11;0
WireConnection;15;1;13;0
WireConnection;14;0;13;0
WireConnection;14;1;6;0
WireConnection;13;0;9;0
WireConnection;13;2;7;0
WireConnection;12;0;10;0
WireConnection;12;2;8;0
WireConnection;10;0;4;0
WireConnection;10;1;3;0
WireConnection;8;1;2;0
WireConnection;7;1;6;0
WireConnection;9;0;3;0
WireConnection;9;1;5;0
WireConnection;16;0;12;0
WireConnection;16;1;2;0
WireConnection;20;0;18;0
WireConnection;20;1;19;0
WireConnection;19;0;15;1
WireConnection;19;1;14;0
WireConnection;22;0;20;0
WireConnection;22;1;21;1
WireConnection;23;0;22;0
WireConnection;23;1;21;1
WireConnection;25;0;23;0
WireConnection;27;1;25;0
WireConnection;29;0;27;1
WireConnection;30;0;26;2
WireConnection;30;2;28;0
WireConnection;17;0;11;0
WireConnection;17;1;12;0
WireConnection;18;0;16;0
WireConnection;18;1;17;1
WireConnection;67;0;64;0
WireConnection;67;1;53;0
WireConnection;53;0;65;0
WireConnection;53;1;62;0
WireConnection;48;0;44;0
WireConnection;48;1;42;0
WireConnection;47;0;45;0
WireConnection;47;1;46;0
WireConnection;46;0;40;0
WireConnection;44;0;37;0
WireConnection;44;1;38;0
WireConnection;41;0;33;0
WireConnection;40;0;32;0
WireConnection;40;1;29;0
WireConnection;38;0;30;0
WireConnection;38;1;36;0
WireConnection;37;0;34;0
WireConnection;37;1;35;0
WireConnection;42;0;41;0
WireConnection;33;0;31;0
WireConnection;33;1;29;0
WireConnection;54;0;48;0
WireConnection;54;1;50;0
WireConnection;57;0;55;0
WireConnection;57;1;56;0
WireConnection;59;0;51;0
WireConnection;59;1;46;0
WireConnection;60;0;47;0
WireConnection;62;0;58;0
WireConnection;62;1;61;0
WireConnection;63;0;57;0
WireConnection;64;0;66;0
WireConnection;64;1;63;0
WireConnection;50;0;43;0
WireConnection;50;1;41;0
WireConnection;35;0;30;0
WireConnection;0;0;68;0
ASEEND*/
//CHKSM=531B3877428F606A6BF6C61422D288739C21B842