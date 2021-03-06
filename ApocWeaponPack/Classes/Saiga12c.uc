class Saiga12c extends KFWeapon;

#exec OBJ LOAD FILE=saigac_T.utx
#exec OBJ LOAD FILE=saigac_SN.uax
#exec OBJ LOAD FILE=saigac_SM.usx
#exec OBJ LOAD FILE=saigac_A.ukx

defaultproperties
{
     MagCapacity=8
     ReloadRate=3.133000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_AK47"
     bHasAimingMode=True
     IdleAimAnim="Iron_Idle"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'saigaC_T.Saiga_Trader'
     SleeveNum=2
     Weight=5.000000
     bIsTier3Weapon=True
     Mesh=SkeletalMesh'saigac_A.saigacmesh'
     Skins(0)=Texture'saigaC_T.saiga'
     Skins(1)=Texture'saigaC_T.saigaparts'
     Skins(2)=Combiner'KF_Weapons_Trip_T.hands.hands_1stP_military_cmb'
     Skins(3)=Texture'saigaC_T.wpn_gilza1'
     SelectSound=Sound'KF_PumpSGSnd.SG_Select'
     HudImage=Texture'saigaC_T.Saiga_Unselected'
     SelectedHudImage=Texture'saigaC_T.Saiga_selected'
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=32.000000
     FireModeClass(0)=Class'Saiga12cFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     Description="Гладкоствольный карабин Сайга-12, 12-го калибра под дробовые и пулевые охотничьи патроны."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-100.000000)
     DisplayFOV=65.000000
     Priority=160
     InventoryGroup=4
     GroupOffset=10
     PickupClass=Class'Saiga12cPickup'
     PlayerViewOffset=(X=10.000000,Y=8.000000,Z=-4.000000)
     BobDamping=4.000000
     AttachmentClass=Class'Saiga12cAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="Сайга 12с"
     TransientSoundVolume=1.250000
	 DrawScale=0.85
}
