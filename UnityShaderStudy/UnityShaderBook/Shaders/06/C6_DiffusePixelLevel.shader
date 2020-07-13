Shader "Book/C6_DiffusePixelLevel"
{
    Properties
    {
        _DiffuseColor("DiffuseColor",Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Tags{"LightMode" = "ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Lighting.cginc"
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                fixed3 worldNormal :TEXCOORD0;
            };


            float4 _DiffuseColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                float3 worldNormal = normalize(i.worldNormal);
                float3 worldLightDir = WorldSpaceLightDir(i.vertex);
                fixed3 diffuse = _LightColor0.xyz * _DiffuseColor.rgb * saturate(dot(worldNormal,worldLightDir));
                fixed3 color = ambient + diffuse;

                return fixed4(color,1);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}
