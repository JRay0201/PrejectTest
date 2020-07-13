Shader "Unlit/C6_SpecularBlinnPhong"
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
                float3 worldNormal: TEXCOORD0;
                float3 worldPos:TEXCOORD1;
            };

            fixed4 _DiffuseColor;
            fixed4 _SpecularColor;
            float _Gloss;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld , v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                float3 worldNormal = normalize(i.worldNormal);
                float3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                fixed3 diffuse = _LightColor0.rgb * _DiffuseColor.rgb * max(0,dot(worldNormal,worldLightDir));

                //float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
                float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                float3 halfDir = normalize(worldLightDir + viewDir);
                fixed3 specular = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(worldNormal,halfDir)),_Gloss);
                fixed3 FinalColor = ambient + diffuse + specular;    
                return fixed4(FinalColor,1.0);
            }
            ENDCG
        }
    }
}
