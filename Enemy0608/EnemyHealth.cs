using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyHealth : MonoBehaviour
{
    public int TotalEnemyHP=100;
    public string BulletLayer;
    public GameObject SparkEffect;
    public GameObject DestroyEffect;
    public Transform DestroyEffectPos;
    [HideInInspector]
    public int CurrentHP;
    void Start()
    {
        CurrentHP = TotalEnemyHP;
    }

    void Update()
    {
        CurrentHP = Mathf.Clamp(CurrentHP, 0, TotalEnemyHP);
        Debug.Log(CurrentHP);
        if (CurrentHP<=0)
        {
            Destroy(gameObject);
            GameObject fx = Instantiate(DestroyEffect, DestroyEffectPos.position, DestroyEffectPos.rotation);
            Destroy(fx, 2);
        }
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag==BulletLayer)
        {
            CurrentHP -= 10;
            GameObject fx = Instantiate(SparkEffect, other.transform.position, other.transform.rotation);
            Destroy(fx, 1);
        }
    }
}
