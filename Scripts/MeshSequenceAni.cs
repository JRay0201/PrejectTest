using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//[ExecuteInEditMode]
public class MeshSequenceAni : MonoBehaviour
{
    public List<Mesh> meshList;
    public bool IsLoop;
    public float ChangePerSecond = 1f;

    MeshFilter m_MeshFilter;
    float m_Timer;
    bool m_Add;
    int m_Index;
    void Start()
    {
        m_MeshFilter = GetComponent<MeshFilter>();
        m_Timer = 0;
        m_Index = -1;
    }
    void Update()
    {
        TimerClass();

        if (IsLoop != false)
        {
            if (m_Add)
            {
                
                m_Index = (m_Index == meshList.Count-1) ? 0 : m_Index + 1;
                m_MeshFilter.mesh = meshList[m_Index];
                Debug.Log(m_Index);
                m_Add = false;
            }
        }
        else
        {
            if (m_Add)
            {    
                m_Index = (m_Index == meshList.Count-1) ? meshList.Count-1 : m_Index + 1;
                m_MeshFilter.mesh = meshList[m_Index];

                m_Add = false;
            }
        }
    }
    void TimerClass ()
    {
        m_Timer += Time.deltaTime / ChangePerSecond;

        if (m_Timer>=1)
        {
            m_Timer = 0;
            m_Add = true;

            float a = 10;
            float b = (a == 10 )? 1 : 2;
        }
    }
}
