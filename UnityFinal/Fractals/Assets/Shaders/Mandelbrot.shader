Shader "Unlit/Mandelbrot"
{
    Properties
    {
        _MainTex	("Texture", 2D) = "white" {}
		_MandelColor("Mandelbrot Color", Color) = (0,0,0,1)
		_JulaiCoord ("Julia Coordinate", Vector) = (.9, .4, 0,0)
		_TimeSlide  ("Time Slider", Range(0,5)) = 0
		
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

			float getJuliaValue(float2 coord, float2 offset) {
				float2 c = float2(offset.x, offset.y);
				float2 z = float2(coord.x, coord.y);
				for (float iteration = 0.0; iteration < 512.0; iteration++) {

					float real = z.x * z.x - z.y * z.y + c.x;
					float imaginary = 2.0 * z.x * z.y + c.y;

					z.x = real;
					z.y = imaginary;

					if (z.x * z.x + z.y * z.y > 4.0) {
						return iteration;
					}
				}

			return 0.0;
			}

			float getMandelValue(float2 coord) {
				float2 c = float2(coord.x, coord.y);
				float2 z = float2(0.0, 0.0);
			
				for (float iteration = 0.0; iteration < 512.0; iteration++) {
					float real = z.x * z.x - z.y * z.y + c.x;
					float imaginary = 2.0 * z.x * z.y + c.y;
			
					z.x = real;
					z.y = imaginary;
			
					if (z.x * z.x + z.y * z.y > 4.0) {
						return iteration;
				}
			  }
			
			  return 0.0;
			}

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
			float4 _MandelColor;
			float4 _JuliaCoord;
			float _TimeSlide;
            float4 _MainTex_ST;

			//Vertex Shader
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

			//Fragment Shader
			fixed4 frag(v2f i) : SV_Target
			{
				//Set Scale for fractal
				float scale = 2.0;
				float2 scaledUV = i.uv * scale;
				
				//Get position input for Julia Set
				float2 juliaInput = _JuliaCoord.xy;
				
				//Animate julia
				juliaInput.x += cos(_TimeSlide * 4.0);
				juliaInput.y += sin(_TimeSlide * 4.0);

				float juliaValue = getJuliaValue(scaledUV, juliaInput);
				float mandelbrotValue = getMandelValue(scaledUV);

				float juliaColor = 5.0 * juliaValue / 512.0;
				float mandelbrotColor = 5.0 * mandelbrotValue / 512.0;

				float color = mandelbrotColor + juliaColor;

				fixed4 col = _MandelColor * color;
                
                return col;
            }
            ENDCG
        }
    }
}
