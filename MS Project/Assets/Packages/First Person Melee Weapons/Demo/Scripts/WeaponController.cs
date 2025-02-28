using UnityEngine;

public class WeaponController : MonoBehaviour
{
private Animator animator;
[SerializeField] private AudioSource attack;
[SerializeField] private AudioSource equip;
[SerializeField] private AudioSource inspect;
[SerializeField] private AudioSource punch;

 
    void Start()
    {
        animator = GetComponent<Animator>();
    }

    
    void Update()
    {
		animator.SetInteger("IdleIndex", Random.Range(0, 5));
		
        if (Input.GetButton("Horizontal") || Input.GetButton("Vertical")) 
	{   
	animator.SetBool("Walk", true);
	}

	else
	{  
	animator.SetBool("Walk", false);
    }
    
	
	
	if (Input.GetKey(KeyCode.LeftShift) && Input.GetButton("Horizontal") || Input.GetKey(KeyCode.LeftShift) && Input.GetButton("Vertical"))
		{   
         animator.SetBool("Run", true);
          }
		else

		{  
         animator.SetBool("Run", false);
		}
		
		
		if (Input.GetButtonDown("Fire1"))
			{
			animator.SetInteger("AttackIndex", Random.Range(0, 6));
			animator.SetBool("Attack", true);
			}
			else
			{
			animator.SetBool("Attack", false);
			}
			
			if (Input.GetKey(KeyCode.I))
			{
				animator.SetBool("Inspect", true);
			}
			else
			{
				animator.SetBool("Inspect", false);
			}
			
			if (Input.GetKey(KeyCode.LeftAlt))
			{
				animator.SetBool("Punch", true);
			}
			else
			{
				animator.SetBool("Punch", false);
			}
	}
	
private void PlayAttackSound()
{
	attack.Play();
}
private void PlayEquipSound()
{
	equip.Play();
}
private void PlayInspectSound()
{
	inspect.Play();
}
private void PlayPunchtSound()
{
	punch.Play();
}

public void Hide()
	{
		gameObject.SetActive (false);
	}

}
