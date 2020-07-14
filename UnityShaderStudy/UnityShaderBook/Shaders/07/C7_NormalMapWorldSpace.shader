Shader "Book/C7_NormalMapWorldSpace"
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
                float4 vertex : SV_POSITION;
                float4 uv : TEXCOORD0;
                float3 tDirWS : TEXCOORD1;
                float3 bDirWS : TEXCOORD2;
                float3 nDirWS : TEXCOORD3;
                float3 lDirWS : TEXCOORD4;
                float3 vDirWS : TEXCOORD5;
            };

            

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.zw = TRANSFORM_TEX(v.uv,_BumpMap);
                
                o.nDirWS = UnityObjectToWorldNormal(v.normal);
                o.tDirWS = normalize(mul(unity_ObjectToWorld,float4(v.tangent.xyz , 0.0)).xyz);
                o.bDirWS = normalize(cross(o.nDirWS , o.tDirWS) * v.tangent.w);
                o.lDirWS = WorldSpaceLightDir(v.vertex);
                o.vDirWS = WorldSpaceViewDir(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 var_NormalMap = UnpackNormal(tex2D(_BumpMap , i.uv.zw));
                var_NormalMap.xy *= _BumpScale;
                var_NormalMap.z = sqrt(1.0 - saturate(dot(var_NormalMap.xy,var_NormalMap.xy)));
                
                float3x3 TBN = float3x3(i.tDirWS , i.bDirWS , i.nDirWS);
                float3 nDirWS = normalize(mul(var_NormalMap , TBN));          

                float3 lDirWS = normalize(i.lDirWS);

                float3 albedo = tex2D(_MainTex , i.uv.xy).rgb * _Color.rgb;
                float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz *albedo;
                float3 diffuse = _LightColor0.rgb * albedo * max(0,dot(nDirWS,lDirWS));

                float3 vDirWS = normalize(i.vDirWS);
                float3 halfDir = normalize(vDirWS + lDirWS);
                float3 specular = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(halfDir , nDirWS)),_Gloss);

                return fixed4(ambient + diffuse + specular , 1.0);
            }
            ENDCG
        }
    }
    Fallback "Specular"
}
