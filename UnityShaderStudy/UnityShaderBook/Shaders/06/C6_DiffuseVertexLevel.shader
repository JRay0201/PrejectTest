Shader "Book/C6_DiffuseVertexLevel"
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
                fixed3 color :COLOR;
            };


            float4 _DiffuseColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                float3 worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
                float3 worldLight =WorldSpaceLightDir(v.vertex);
                float3 diffuse = _LightColor0.rgb * _DiffuseColor.rgb * saturate(dot(worldNormal,worldLight));
                o.color = ambient + diffuse;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                

                return fixed4(i.color,1);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}
