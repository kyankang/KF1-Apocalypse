class UMP45SubmachineGun extends KFWeapon
	config(user);

#exec OBJ LOAD FILE=KillingFloorWeapons.utx
#exec OBJ LOAD FILE=KillingFloorHUD.utx
#exec OBJ LOAD FILE=Inf_Weapons_Foley.uax
#exec OBJ LOAD FILE=UMP45_T.utx
#exec OBJ LOAD FILE=UMP45_Snd.uax
#exec OBJ LOAD FILE=UMP45_sm.usx
#exec OBJ LOAD FILE=UMP45_A.ukx

// Use alt fire to switch fire modes
simulated function AltFire(float F)
{
    if(ReadyToFire(0))
    {
        DoToggle();
    }
}

// Toggle semi/auto fire
simulated function DoToggle ()
{
	local PlayerController Player;

	Player = Level.GetLocalPlayerController();
	if ( Player!=None )
	{
		//PlayOwnedSound(sound'Inf_Weapons_Foley.stg44_firemodeswitch01',SLOT_None,2.0,,,,false);
		FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
		if ( FireMode[0].bWaitForRelease )
			Player.ReceiveLocalizedMessage(class'KFmod.BullpupSwitchMessage',0);
		else Player.ReceiveLocalizedMessage(class'KFmod.BullpupSwitchMessage',1);
	}
	Super.DoToggle();

	ServerChangeFireMode(FireMode[0].bWaitForRelease);
}

// Set the new fire mode on the server
function ServerChangeFireMode(bool bNewWaitForRelease)
{
    FireMode[0].bWaitForRelease = bNewWaitForRelease;
}

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

exec function SwitchModes()
{
	DoToggle();
}

function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	return AIRating;
}

function byte BestMode()
{
	return 0;
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
     MagCapacity=100
     ReloadRate=2.500000
     ReloadAnim="Reload"
     ReloadAnimRate=1.00000
     WeaponReloadAnim="Reload_MP5"
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="Iron_Idle"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'UMP45_T.UMP45_Trader'
     SleeveNum=0
     bIsTier2Weapon=True
     Mesh=SkeletalMesh'UMP45_A.ump45mesh'
     Skins(0)=Combiner'KF_Weapons_Trip_T.hands.hands_1stP_military_cmb'
     Skins(1)=Texture'UMP45_T.uscmap1'
     Skins(2)=Texture'UMP45_T.uscmap2'
     Skins(3)=Texture'UMP45_T.uscmap3'
     SelectSound=Sound'UMP45_Snd.ump45_select'
     HudImage=Texture'UMP45_T.UMP45_Unselected'
     SelectedHudImage=Texture'UMP45_T.UMP45_selected'
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=32.000000
     FireModeClass(0)=Class'UMP45Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="Универсальный пистолет-пулемет, разработанный немецкой компанией Heckler & Koch в 1990-х годах в качестве дополнения к семейству пистолетов-пулеметов HK MP5."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=65.000000
     Priority=95
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=4
     GroupOffset=7
     PickupClass=Class'UMP45Pickup'
     PlayerViewOffset=(X=5.000000,Y=7.000000,Z=-2.500000)
     BobDamping=5.000000
     AttachmentClass=Class'UMP45Attachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="HK UMP-45"
     TransientSoundVolume=2.250000
}
