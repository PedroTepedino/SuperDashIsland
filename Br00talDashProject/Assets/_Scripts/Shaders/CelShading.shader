/*
 * @Author: Pedro Tepedino
 * @Email: pedrotepedinossauro@gmail.com
 * @Date: 2019-08-03 03:22:47
 * @Last Modified by: Pedro Tepedino
 * @Last Modified time: 2019-08-07 17:46:04
 * @Description: Shader for toon shadow
 */

Shader "Custom/CelShading"
{

	//show values to edit in inspector
	Properties{
		[Header(Base Parameters)]
		_Color("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Texture", 2D) = "white" {}
		_Specular("Specular Color", Color) = (1,1,1,1)
		[HDR] _Emission("Emission", color) = (0 ,0 ,0 , 1)

		[Header(Lighting Parameters)]
		_ShadowTint("Shadow Color", Color) = (0.5, 0.5, 0.5, 1)
		[IntRange]_StepAmount("Shadow Steps", Range(1, 16)) = 2
		_StepWidth("Step Size", Range(0, 1)) = 0.25
		_SpecularSize("Specular Size", Range(0, 1)) = 0.1
		_SpecularFalloff("Specular Falloff", Range(0, 2)) = 1
	}
		SubShader{
			//the material is completely non-transparent and is rendered at the same time as the other opaque geometry
			Tags{ "RenderType" = "Opaque" "Queue" = "Geometry"}

			CGPROGRAM

			//the shader is a surface shader, meaning that it will be extended by unity in the background to have fancy lighting and other features
			//our surface shader function is called surf and we use our custom lighting model
			//fullforwardshadows makes sure unity adds the shadow passes the shader might need
			#pragma surface surf Stepped fullforwardshadows
			#pragma target 3.0

			sampler2D _MainTex;
			fixed4 _Color;
			half3 _Emission;
			fixed4 _Specular;

			float3 _ShadowTint;
			float _StepWidth;
			float _StepAmount;
			float _SpecularSize;
			float _SpecularFalloff;

			struct ToonSurfaceOutput {
				fixed3 Albedo;
				half3 Emission;
				fixed3 Specular;
				fixed Alpha;
				fixed3 Normal;
			};

			//our lighting function. Will be called once per light
			float4 LightingStepped(ToonSurfaceOutput s, float3 lightDir, half3 viewDir, float shadowAttenuation) {
				//how much does the normal point towards the light?
				float towardsLight = dot(s.Normal, lightDir);

				//stretch values so each whole value is one step
				towardsLight = towardsLight / _StepWidth;
				//make steps harder
				float lightIntensity = floor(towardsLight);

				// calculate smoothing in first pixels of the steps and add smoothing to step, raising it by one step
				// (that's fine because we used floor previously and we want everything to be the value above the floor value, 
				// for example 0 to 1 should be 1, 1 to 2 should be 2 etc...)
				float change = fwidth(towardsLight);
				float smoothing = smoothstep(0, change, frac(towardsLight));
				lightIntensity = lightIntensity + smoothing;

				// bring the light intensity back into a range where we can use it for color
				// and clamp it so it doesn't do weird stuff below 0 / above one
				lightIntensity = lightIntensity / _StepAmount;
				lightIntensity = saturate(lightIntensity);

			#ifdef USING_DIRECTIONAL_LIGHT
				//for directional lights, get a hard vut in the middle of the shadow attenuation
				float attenuationChange = fwidth(shadowAttenuation) * 0.5;
				float shadow = smoothstep(0.5 - attenuationChange, 0.5 + attenuationChange, shadowAttenuation);
			#else
				//for other light types (point, spot), put the cutoff near black, so the falloff doesn't affect the range
				float attenuationChange = fwidth(shadowAttenuation);
				float shadow = smoothstep(0, attenuationChange, shadowAttenuation);
			#endif
				lightIntensity = lightIntensity * shadow;

				//calculate how much the surface points points towards the reflection direction
				float3 reflectionDirection = reflect(lightDir, s.Normal);
				float towardsReflection = dot(viewDir, -reflectionDirection);

				//make specular highlight all off towards outside of model
				float specularFalloff = dot(viewDir, s.Normal);
				specularFalloff = pow(specularFalloff, _SpecularFalloff);
				towardsReflection = towardsReflection * specularFalloff;

				//make specular intensity with a hard corner
				float specularChange = fwidth(towardsReflection);
				float specularIntensity = smoothstep(1 - _SpecularSize, 1 - _SpecularSize + specularChange, towardsReflection);
				//factor inshadows
				specularIntensity = specularIntensity * shadow;

				float4 color;
				//calculate final color
				color.rgb = s.Albedo * lightIntensity * _LightColor0.rgb;
				color.rgb = lerp(color.rgb, s.Specular * _LightColor0.rgb, saturate(specularIntensity));

				color.a = s.Alpha;
				return color;
			}


			//input struct which is automatically filled by unity
			struct Input {
				float2 uv_MainTex;
			};

			//the surface shader function which sets parameters the lighting function then uses
			void surf(Input i, inout ToonSurfaceOutput o) {
				//sample and tint albedo texture
				fixed4 col = tex2D(_MainTex, i.uv_MainTex);
				col *= _Color;
				o.Albedo = col.rgb;

				o.Specular = _Specular;

				float3 shadowColor = col.rgb * _ShadowTint;
				o.Emission = _Emission + shadowColor;
			}
			ENDCG
		}
			FallBack "Diffuse"

	//Properties
	//{
	//	_Diffuse("Dissufe", 2D) = "white" {}
	//	_RampTex("Ramp Texture", 2D) = "white" {}
	//	[HDR] _Emission("Emission", color) = (0 ,0 ,0 , 1)
	//	_ShadowTint("Shadow Color", Color) = (0.5, 0.5, 0.5, 1)
	//}
	//SubShader
	//{
	//	CGPROGRAM
	//	#pragma surface surf ToonRamp fullforwardshadows

	//	sampler2D _Diffuse;
	//	sampler2D _RampTex;
	//	half3 _Emission;
	//	float3 _ShadowTint;

	//	half4 LightingToonRamp(SurfaceOutput s, fixed3 lightDir, fixed atten, float shadowAttenuation)
	//	{
	//		float diff = dot(s.Normal, lightDir);

	//		float h = diff * 0.5 + 0.5;
	//		float2 rh = h;
	//		float3 ramp = tex2D(_RampTex, rh).rgb;

	//		#ifdef USING_DIRECTIONAL_LIGHT
	//			float attenuationChange = fwidth(shadowAttenuation) * 0.5;
	//			float shadow = smoothstep(0.5 - attenuationChange, 0.5 + attenuationChange, shadowAttenuation);
	//		#else 
	//			float attenuationChange = fwidth(shadowAttenuation) * 0.5;
	//			float shadow = smoothstep(0, attenuationChange, shadowAttenuation);
	//		#endif

	//		float4 c;
	//		c.rgb = s.Albedo * _LightColor0.rgb * (ramp) * shadow;
	//		c.a = s.Alpha;
	//		return c;
	//	}


	//	struct Input {
	//		float2 uv_Diffuse;
	//	};

	//	void surf(Input IN, inout SurfaceOutput o)
	//	{
	//		o.Albedo = tex2D(_Diffuse, IN.uv_Diffuse).rgb;
	//		o.Emission = _Emission + _ShadowTint;
	//	}
	//	ENDCG
	//}
	//	FallBack "Diffuse"
}
