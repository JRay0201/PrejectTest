using System.Collections;
using System.Collections.Generic;
using UnityEngine;
//[ExecuteInEditMode]
public class RotateObject : MonoBehaviour
{
    public Vector3 rotateDir;
    public float rotateSpeed;

    void Update()
    {
         
        transform.Rotate(rotateDir, rotateSpeed);
    }
}
