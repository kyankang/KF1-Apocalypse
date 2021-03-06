class PKM extends KFWeapon
	config(user);

#exec OBJ LOAD FILE=KillingFloorWeapons.utx
#exec OBJ LOAD FILE=KillingFloorHUD.utx
#exec OBJ LOAD FILE=Inf_Weapons_Foley.uax
#exec OBJ LOAD FILE=PKM_SN.uax
#exec OBJ LOAD FILE=Pkm_T.utx
#exec OBJ LOAD FILE=PKM_SM.usx
#exec OBJ LOAD FILE=Pkm_A.ukx

function bool RecommendRangedAttack()
{
	return true;
}

//TODO: LONG ranged?
function bool RecommendLongRangedAttack()
{
	return true;
}

function float SuggestAttackStyle()
{
	return -1.0;
}

function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	return AIRating;
}

simulated function SetZoomBlendColor(Canvas c)
{
	local Byte    val;
	local Color   clr;
	local Color   fog;

	clr.R = 255;
	clr.G = 255;
	clr.B = 255;
	clr.A = 255;

	if( Instigator.Region.Zone.bDistanceFog )
	{
		fog = Instigator.Region.Zone.DistanceFogColor;
		val = 0;
		val = Max( val, fog.R);
		val = Max( val, fog.G);
		val = Max( val, fog.B);
		if( val > 128 )
		{
			val -= 128;
			clr.R -= val;
			clr.G -= val;
			clr.B -= val;
		}
	}
	c.DrawColor = clr;
}

defaultproperties
{
     FlashBoneName="tip_1"
     MagCapacity=100
     QuickPutDownTime=0.300000
     QuickBringUpTime=0.300000
     ReloadRate=6.000000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_M14"
     Weight=12.000000
     SleeveNum=2
     bHasAimingMode=True
     IdleAimAnim="Iron_Idle"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'Pkm_T.PKM_Trader'
     bIsTier2Weapon=True
     Mesh=SkeletalMesh'Pkm_A.pkmmesh'
     Skins(0)=Texture'Pkm_T.wpn_pkm'
     Skins(1)=Texture'Pkm_T.wpn_pkm_lenta'
     Skins(2)=Combiner'KF_Weapons_Trip_T.hands.hands_1stP_military_cmb'
     SelectSound=Sound'PKM_SN.pkm_draw'
     HudImage=Texture'Pkm_T.PKM_Unselected'
     SelectedHudImage=Texture'Pkm_T.PKM_selected'
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=32.000000
     FireModeClass(0)=Class'PKMFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="Пулемет Калашникова модернизированный (PKM SAW) является мощным автоматическим оружием и предназначен для уничтожения живой силы и огневых средств противника, а также для поражения воздушных целей.."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=65.000000
     Priority=190
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=4
     GroupOffset=7
     PickupClass=Class'PKMPickup'
     PlayerViewOffset=(X=-10.000000,Y=18.000000,Z=-11.000000)
     BobDamping=5.000000
     AttachmentClass=Class'PKMAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="PKM SAW"
     TransientSoundVolume=1.250000
}
