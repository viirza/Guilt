using UnityEngine;

public class ControlsInfo : MonoBehaviour
{
	
[SerializeField] private GameObject controlsInfo;
private bool isHide;

private void Update () {

if(Input.GetKeyDown(KeyCode.Tab)){ 
	if(isHide){
	isHide = false;	
	controlsInfo.SetActive (true);
	}
	else{
	isHide = true;	
	controlsInfo.SetActive (false);
	}
	}
}
}
