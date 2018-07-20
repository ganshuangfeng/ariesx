﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Lines/Tile"
{
	Properties
	{
		_MainTex("Sprite Texture", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap("Pixel snap", Float) = 0
		RepeatX("Repeat X", Float) = 1
		RepeatY("Repeat Y", Float) = 1
		Percent("Percent", Float) = 0
	}

		SubShader
		{
			Tags
			{
				"Queue" = "Transparent"
				"IgnoreProjector" = "True"
				"RenderType" = "Transparent"
				"PreviewType" = "Plane"
				"CanUseSpriteAtlas" = "True"
			}

			Cull Off
			Lighting Off
			ZWrite Off
			Blend One OneMinusSrcAlpha

			Pass
			{
			CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#pragma multi_compile _ PIXELSNAP_ON
	#include "UnityCG.cginc"

		struct appdata_t
		{
			float4 vertex   : POSITION;
			float4 color    : COLOR;
			float2 texcoord : TEXCOORD0;
		};

		struct v2f
		{
			float4 vertex   : SV_POSITION;
			fixed4 color : COLOR;
			half2 texcoord  : TEXCOORD0;
		};

		fixed4 _Color;
		half RepeatX;
		half RepeatY;
		float Percent;

		v2f vert(appdata_t IN)
		{
			v2f OUT;
			OUT.vertex = UnityObjectToClipPos(IN.vertex);
			OUT.texcoord = IN.texcoord * half2(RepeatX, RepeatY);
			//OUT.texcoord.x -= _Time.z % (RepeatX * 10);
			OUT.color = IN.color * _Color;
	#ifdef PIXELSNAP_ON
			OUT.vertex = UnityPixelSnap(OUT.vertex);
	#endif

			return OUT;
		}

		sampler2D _MainTex;

		fixed4 frag(v2f IN) : SV_Target
		{
			//float a = ceil(max(1 + Percent - abs((IN.texcoord.x + _Time.z % (RepeatX * 10)) / RepeatX), 0));
			float a = 1;

			fixed4 c = tex2D(_MainTex, IN.texcoord) * IN.color;
			c.rgb *= min(1, c.a * a);
			return c;
		}
			ENDCG
		}
		}
}