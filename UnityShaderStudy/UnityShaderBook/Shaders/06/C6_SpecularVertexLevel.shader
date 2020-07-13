Shader "Unlit/C6_SpecularVertexLevel"
{
    Properties
    {
        _DiffuseColor("DifffuseColor",Color) = (1,1,1,1)
        _SpecularColor("SpecularColor",Color) = (1,1,1,1)
        _Gloss("Gloss",Range(8.0,256.0)) = 20
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
                float4 pos : SV_POSITION;
                float3 color: COLOR;

            };

            fixed4 _DiffuseColor;
            fixed4 _SpecularColor;
            float _Gloss;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                float3 worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
                float3 worldLightDir = normalize(WorldSpaceLightDir(v.vertex));
                fixed3 diffuse = _LightColor0.rgb * _DiffuseColor.rgb * max(0,dot(worldNormal,worldLightDir));

                float3 reflectDir = normalize(reflect(-worldLightDir , worldNormal));
                float3 viewDir = normalize(UnityWorldSpaceViewDir(v.vertex));
                fixed3 specular = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(reflectDir,viewDir)),_Gloss);

                o.color = ambient + diffuse + specular; 
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(i.color,1.0);
            }
            ENDCG
        }
    }
}
