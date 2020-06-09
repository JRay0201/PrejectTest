using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySkill : MonoBehaviour
{
    public string BulletLayer;
    public GameObject Target;

    bool IsAttack;
    Animator m_ani;
    void Start()
    {
        m_ani = GetComponent<Animator>();
    }

    void Update()
    {
        if (IsAttack)
        {
            EnemyBulletAttack();
        }


    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.tag== BulletLayer)
        {
            IsAttack = true;
        }
    }
    void EnemyBulletAttack()
    {
        m_ani.SetInteger("AniIndex", 7);
        transform.forward = Vector3.Lerp(transform.forward, Target.transform.position - transform.position, Time.deltaTime);
    }
}
