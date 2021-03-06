﻿Shader "Book/C7_NormalMapTangentSpace"
{
    Properties
    {
        _Color("Tint Color",Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        [Normal]_BumpMap("Normal Map",2D) = "bump"{}
        _BumpScale("Bump Scale",float) = 1
        _SpecularColor("SpecularColor",Color) = (1,1,1,1)
        _Gloss("Gloss",Range(8,256))=128
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

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            float _BumpScale;
            fixed4 _SpecularColor;
            float _Gloss;

            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent: TANGENT;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                float3 lightDir : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
                float4 vertex : SV_POSITION;
            };

            

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.zw = TRANSFORM_TEX(v.uv,_BumpMap);
                // Declares 3x3 matrix 'rotation', filled with tangent space basis
                // #define TANGENT_SPACE_ROTATION \
                // float3 binormal = cross( normalize(v.normal), normalize(v.tangent.xyz) ) * v.tangent.w; \
                // float3x3 rotation = float3x3( v.tangent.xyz, binormal, v.normal )
                TANGENT_SPACE_ROTATION;

                o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
                o.viewDir = mul(rotation,ObjSpaceViewDir(v.vertex)).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 tangentLightDir = normalize(i.lightDir);
                float3 tangentViewDir = normalize(i.viewDir);

                float4 packedNormal = tex2D(_BumpMap,i.uv.zw);
                float3 tangentNormal;
                tangentNormal = UnpackNormal(packedNormal);
                tangentNormal.xy *= _BumpScale;
                tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy,tangentNormal.xy)));

                float3 albedo = tex2D(_MainTex , i.uv.xy).rgb * _Color.rgb;
                float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz *albedo;
                float3 diffuse = _LightColor0.rgb * albedo * max(0,dot(tangentNormal,tangentLightDir));

                float3 halfDir = normalize(tangentViewDir + tangentLightDir);
                float3 specular = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(halfDir , tangentNormal)),_Gloss);

                return fixed4(ambient + diffuse + specular , 1.0);
            }
            ENDCG
        }
    }
    Fallback "Specular"
}
