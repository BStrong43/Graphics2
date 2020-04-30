Shader "Unlit/Kleinan"
{
    Properties
    {
        _MainTex        ("Texture", 2D) = "white" {}
		_FractalColor   ("Fractal Color", Color) = (1.0, 0.0, 0.0, 1.0)
		_AnimSlider     ("Animation Slider", Range(0.0, 8.0)) = 0
		_NumIterations  ("Iterations", int) = 512
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
		//http://www.josleys.com/articles/Kleinian%20escape-time_3.pdf
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uuv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uuv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float4 _FractalColor;
			float _AnimSlider;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.uuv = TRANSFORM_TEX(v.uuv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

			//wrap texture
			float wrap(float x, float KleinR, float scale) {
				x -= scale;
				return (x - KleinR * floor(x / KleinR)) + scale;
			}

			void transformToA(inout float2 z, float KleinR, float KleinI) {
				float iR = 1. / dot(z, z);
				z *= -iR;
				z.x = -KleinI - z.x; 
				z.y = KleinR + z.y;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float2 myUV = i.uuv;
				
				//calculate Kleinian
				float2 lz = myUV + float2(1.0, 1.0), llz = myUV + float2(-1.0, -1.0);
				float flag = 0.;//Variable to determine fractal coord

				//Set up Klein values & incorporate animation
				float KleinR = 1.8462756 + (1.958591 - 1.8462756) * 0.5 + 0.5 * (1.958591 - 1.8462756) * sin(-_AnimSlider * 0.2);		//Klein Real
				float KleinI = 0.09627581 + (0.0112786 - 0.09627581) * 0.5 + 0.5 * (0.0112786 - 0.09627581) * sin(-_AnimSlider * 0.2);  //Klein imaginary

				float f = sign(KleinI) * 1.; //pos/neg?

				for (int i = 0; i < 150; i++) //Iterate Fractal
				{
					myUV.x = myUV.x + f * KleinI / KleinR * myUV.y;
					myUV.x = wrap(myUV.x, 2., -1);
					myUV.x = myUV.x - f * KleinI / KleinR * myUV.y;

					if (myUV.y >= KleinR * 0.5 + f * (2. * KleinR - 1.95) / 4. * sign(myUV.x + KleinI * 0.5) * 
						(1. - exp(-(7.2 - (1.95 - KleinR) * 15.) * abs(myUV.x + KleinI * 0.5)))) //above the separation line?
					{
						myUV = float2(-KleinI, KleinR) - myUV; //rotate by 180°
					}

					//Apply transformation A
					transformToA(myUV, KleinR, KleinI);

					//we've gone to deep, bail bro (2-cycle detection)
					if (dot(myUV - llz, myUV - llz) < 1e-6) { break; }

					//if the iterated point gets outside myUV.y=0 and myUV.y=KleinR
					if (myUV.y<0. || myUV.y>KleinR) { flag = 1.; break; }
					
					//Values for next iteration
					llz = lz; 
					lz = myUV;
				}

				//0'd float4 for black background
				float3 c = (1. - flag) * float4(0.0,0.0,0.0,1.0) + flag * _FractalColor;

				fixed4 col = float4(c, 1.0);//output color
				return col;
            }
            ENDCG
        }
    }
}
