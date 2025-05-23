﻿using UnityEngine;

public class WeaponSelection : MonoBehaviour {
	
private int selectedWeapon = -1;

private void start () 
{
SelectWeapon ();
}
 
private void Update () {
	
int previousSelectedWeapon = selectedWeapon;

if (Input.GetAxis("Mouse ScrollWheel") < 0f)
	 {
		 if (selectedWeapon >= transform.childCount - 1)
			 selectedWeapon = 0;
		 else
		 selectedWeapon++;
	 }
if (Input.GetAxis("Mouse ScrollWheel") > 0f)
	 {
		 if (selectedWeapon <= 0)
			 selectedWeapon = transform.childCount - 1;
		 else
		 selectedWeapon--;
	 }
	 	 
	 
	 if (previousSelectedWeapon != selectedWeapon)
	 {
		 SelectWeapon ();
	 }
}

void SelectWeapon ()
 {
	 int i = 0;
	 foreach (Transform weapon in transform)
	 {
		 if (i == selectedWeapon)
			 weapon.gameObject.SetActive(true);
		 else
			 weapon.GetComponent<WeaponController>().Hide();
                i++;
	 }
	  }
}

		 