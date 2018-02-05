Shader "FoxShaders/fox3DDF_Blin_LayerSRGBBl_2SubNorm_LNM"
{
	Properties
	{
		MatParamIndex_0("MatParamIndex_0", Vector) = (0.0, 0.0, 0.0, 0.0)
		MatParamIndex_1("MatParamIndex_1", Vector) = (0.0, 0.0, 0.0, 0.0)
		MatParamIndex_2("MatParamIndex_2", Vector) = (0.0, 0.0, 0.0, 0.0)
		MatParamIndex_3("MatParamIndex_3", Vector) = (0.0, 0.0, 0.0, 0.0)
		URepeat_UV("URepeat_UV", Vector) = (0.0, 0.0, 0.0, 0.0)
		VRepeat_UV("VRepeat_UV", Vector) = (0.0, 0.0, 0.0, 0.0)
		UShift_UV("UShift_UV", Vector) = (0.0, 0.0, 0.0, 0.0)
		VShift_UV("VShift_UV", Vector) = (0.0, 0.0, 0.0, 0.0)
		SubNormal_Blend("SubNormal_Blend", Vector) = (0.0, 0.0, 0.0, 0.0)
		URepeat_SubNorm_UV("URepeat_SubNorm_UV", Vector) = (0.0, 0.0, 0.0, 0.0)
		VRepeat_SubNorm_UV("VRepeat_SubNorm_UV", Vector) = (0.0, 0.0, 0.0, 0.0)
		SmallSubNormal_Blend("SmallSubNormal_Blend", Vector) = (0.0, 0.0, 0.0, 0.0)
		URepeat_SmallSubNorm_UV("URepeat_SmallSubNorm_UV", Vector) = (0.0, 0.0, 0.0, 0.0)
		VRepeat_SmallSubNorm_UV("VRepeat_SmallSubNorm_UV", Vector) = (0.0, 0.0, 0.0, 0.0)
		Base_Tex_SRGB("Base_Tex_SRGB", 2D) = "white" {}
		NormalMap_Tex_NRM("NormalMap_Tex_NRM", 2D) = "white" {}
		SpecularMap_Tex_LIN("SpecularMap_Tex_LIN", 2D) = "white" {}
		Layer_Tex_SRGB("Layer_Tex_SRGB", 2D) = "white" {}
		LayerMask_Tex_LIN("LayerMask_Tex_LIN", 2D) = "white" {}
		SubNormalMap_Tex_NRM("SubNormalMap_Tex_NRM", 2D) = "white" {}
		SmallSubNormalMap_Tex_NRM("SmallSubNormalMap_Tex_NRM", 2D) = "white" {}
	}
		
	Subshader
	{
		Tags{ "Queue" = "Geometry" "Ignore Projector" = "True" "RenderType" = "Opaque" }
		LOD 200

		Blend SrcAlpha OneMinusSrcAlpha

		AlphaToMask On

		Pass
		{
			ZWrite On
			ColorMask 0
		}

		CGPROGRAM

		#pragma surface surf Standard fullforwardshadows alpha
		#pragma target 3.0

		sampler2D Base_Tex_SRGB;
		sampler2D NormalMap_Tex_NRM;
		sampler2D SpecularMap_Tex_LIN;
		sampler2D Translucent_Tex_LIN;

		struct Input
		{
			float2 uvBase_Tex_SRGB;
		};

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 mainTex = tex2D(Base_Tex_SRGB, IN.uvBase_Tex_SRGB);
			o.Albedo = mainTex.rgb;
			o.Alpha = mainTex.a;
			o.Metallic = 0.0f;
			o.Smoothness = 1.0f - tex2D(SpecularMap_Tex_LIN, IN.uvBase_Tex_SRGB).g;
			fixed4 finalNormal = tex2D(NormalMap_Tex_NRM, IN.uvBase_Tex_SRGB);
			finalNormal.r = finalNormal.g;
			finalNormal.g = 1.0f - finalNormal.g;
			finalNormal.b = 1.0f;
			finalNormal.a = 1.0f;
			o.Normal = UnpackNormal(finalNormal);
		}
		ENDCG
	}
	FallBack "Standard"
}