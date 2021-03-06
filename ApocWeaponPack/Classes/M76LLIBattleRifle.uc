//=============================================================================
// M76 Zastava Battle Rifle Inventory class
//=============================================================================
class M76LLIBattleRifle extends KFWeapon
	config(user);

#exec OBJ LOAD FILE=M76LLI_A.ukx

var         LaserDot                    Spot;                       // The first person laser site dot
var()       float                       SpotProjectorPullback;      // Amount to pull back the laser dot projector from the hit location
var         bool                        bLaserActive;               // The laser site is active
var         LaserBeamEffect             Beam;                       // Third person laser beam effect

var()		class<InventoryAttachment>	LaserAttachmentClass;      // First person laser attachment class
var 		Actor 						LaserAttachment;           // First person laser attachment

replication
{
	reliable if(Role < ROLE_Authority)
		ServerSetLaserActive;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if (Role == ROLE_Authority)
	{
		if (Beam == None)
		{
			Beam = Spawn(class'LaserBeamEffect');
		}
	}
}

simulated function Destroyed()
{
	if (Spot != None)
		Spot.Destroy();

	if (Beam != None)
		Beam.Destroy();

	if (LaserAttachment != None)
		LaserAttachment.Destroy();

	super.Destroyed();
}

simulated function WeaponTick(float dt)
{
	local Vector StartTrace, EndTrace, X,Y,Z;
	local Vector HitLocation, HitNormal;
	local Actor Other;
	local vector MyEndBeamEffect;
	local coords C;

	super.WeaponTick(dt);

	if( Role == ROLE_Authority && Beam != none )
	{
		if( bIsReloading && WeaponAttachment(ThirdPersonActor) != none )
		{
			C = WeaponAttachment(ThirdPersonActor).GetBoneCoords('LightBone');
			X = C.XAxis;
			Y = C.YAxis;
			Z = C.ZAxis;
		}
		else
		{
			GetViewAxes(X,Y,Z);
		}

		// the to-hit trace always starts right in front of the eye
		StartTrace = Instigator.Location + Instigator.EyePosition() + X*Instigator.CollisionRadius;

		EndTrace = StartTrace + 65535 * X;

		Other = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);

		if (Other != None && Other != Instigator && Other.Base != Instigator )
		{
			MyEndBeamEffect = HitLocation;
		}
		else
		{
			MyEndBeamEffect = EndTrace;
		}

		Beam.EndBeamEffect = MyEndBeamEffect;
		Beam.EffectHitNormal = HitNormal;
	}
}

simulated function BringUp(optional Weapon PrevWeapon)
{
	Super.BringUp(PrevWeapon);

	if (Role == ROLE_Authority)
	{
		if (Beam == None)
		{
			Beam = Spawn(class'LaserBeamEffect');
		}
	}
}

simulated function DetachFromPawn(Pawn P)
{
	TurnOffLaser();

	Super.DetachFromPawn(P);

	if (Beam != None)
	{
		Beam.Destroy();
	}
}

simulated function bool PutDown()
{
	if (Beam != None)
	{
		Beam.Destroy();
	}

	TurnOffLaser();

	return super.PutDown();
}

// Use alt fire to switch fire modes
simulated function AltFire(float F)
{
	if(ReadyToFire(0))
	{
		ToggleLaser();
	}
}

// Toggle the laser on and off
simulated function ToggleLaser()
{
	if( Instigator.IsLocallyControlled() )
	{
		if( Role < ROLE_Authority  )
		{
			ServerSetLaserActive(!bLaserActive);
		}

		bLaserActive = !bLaserActive;

		if( Beam != none )
		{
			Beam.SetActive(bLaserActive);
		}

		if( bLaserActive )
		{
			if ( LaserAttachment == none )
			{
				LaserAttachment = Spawn(LaserAttachmentClass,,,,);
				AttachToBone(LaserAttachment,'LightBone1');
			}
			LaserAttachment.bHidden = false;

			if (Spot == None)
			{
				Spot = Spawn(class'LaserDot', self);
			}
		}
		else
		{
			LaserAttachment.bHidden = true;
			if (Spot != None)
			{
				Spot.Destroy();
			}
		}
	}
}

simulated function TurnOffLaser()
{
	if( Instigator.IsLocallyControlled() )
	{
		if( Role < ROLE_Authority  )
		{
			ServerSetLaserActive(false);
		}

		bLaserActive = false;
		LaserAttachment.bHidden = true;

		if( Beam != none )
		{
			Beam.SetActive(false);
		}

		if (Spot != None)
		{
			Spot.Destroy();
		}
	}
}

// Set the new fire mode on the server
function ServerSetLaserActive(bool bNewWaitForRelease)
{
	if( Beam != none )
	{
		Beam.SetActive(bNewWaitForRelease);
	}

	if( bNewWaitForRelease )
	{
		bLaserActive = true;
		if (Spot == None)
		{
			Spot = Spawn(class'LaserDot', self);
		}
	}
	else
	{
		bLaserActive = false;
		if (Spot != None)
		{
			Spot.Destroy();
		}
	}
}

simulated event RenderOverlays( Canvas Canvas )
{
	local int m;
	local Vector StartTrace, EndTrace;
	local Vector HitLocation, HitNormal;
	local Actor Other;
	local vector X,Y,Z;
	local coords C;

	if (Instigator == None)
		return;

	if ( Instigator.Controller != None )
		Hand = Instigator.Controller.Handedness;

	if ((Hand < -1.0) || (Hand > 1.0))
		return;

	// draw muzzleflashes/smoke for all fire modes so idle state won't
	// cause emitters to just disappear
	for (m = 0; m < NUM_FIRE_MODES; m++)
	{
		if (FireMode[m] != None)
		{
			FireMode[m].DrawMuzzleFlash(Canvas);
		}
	}

	SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
	SetRotation( Instigator.GetViewRotation() + ZoomRotInterp);

	// Handle drawing the laser beam dot
	if (Spot != None)
	{
		StartTrace = Instigator.Location + Instigator.EyePosition();
		GetViewAxes(X, Y, Z);

		if( bIsReloading && Instigator.IsLocallyControlled() )
		{
			C = GetBoneCoords('LightBone');
			X = C.XAxis;
			Y = C.YAxis;
			Z = C.ZAxis;
		}

		EndTrace = StartTrace + 65535 * X;

		Other = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);

		if (Other != None && Other != Instigator && Other.Base != Instigator )
		{
			EndBeamEffect = HitLocation;
		}
		else
		{
			EndBeamEffect = EndTrace;
		}

		Spot.SetLocation(EndBeamEffect - X*SpotProjectorPullback);

		if(  Pawn(Other) != none )
		{
			Spot.SetRotation(Rotator(X));
			Spot.SetDrawScale(Spot.default.DrawScale * 0.5);
		}
		else if( HitNormal == vect(0,0,0) )
		{
			Spot.SetRotation(Rotator(-X));
			Spot.SetDrawScale(Spot.default.DrawScale);
		}
		else
		{
			Spot.SetRotation(Rotator(-HitNormal));
			Spot.SetDrawScale(Spot.default.DrawScale);
		}
	}

	//PreDrawFPWeapon();	// Laurent -- Hook to override things before render (like rotation if using a staticmesh)

	bDrawingFirstPerson = true;
	Canvas.DrawActor(self, false, false, DisplayFOV);
	bDrawingFirstPerson = false;
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

simulated function Notify_ShowBullets()
{
	local int AvailableAmmo;

	AvailableAmmo = AmmoAmount(0);

	if (AvailableAmmo == 0)
	{
		SetBoneScale (0, 0.0, 'bullet1');
		SetBoneScale (1, 0.0, 'bullet');
	}
	else if (AvailableAmmo == 1)
	{
		SetBoneScale (0, 0.0, 'bullet1');
		SetBoneScale (1, 0.0, 'bullet');
	}
	else
	{
		SetBoneScale (0, 1.0, 'bullet1');
		SetBoneScale (1, 1.0, 'bullet');
	}
}

simulated function Notify_HideBullets()
{
	if (MagAmmoRemaining <= 0)
	{
		SetBoneScale (1, 0.0, 'bullet1');
	}
	else if (MagAmmoRemaining <= 1)
	{
		SetBoneScale (0, 0.0, 'bullet');
	}
}

defaultproperties
{
     FlashBoneName="tip1"
     SpotProjectorPullback=1.000000
     LaserAttachmentClass=Class'KFMod.LaserAttachmentFirstPerson'
     MagCapacity=10
     ReloadRate=3.000000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_AK47"
     Weight=8.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=55.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'M76LLI_A.M76LLI_T.M76LLI_Trader'
     bIsTier3Weapon=True
     SleeveNum=7
     Mesh=SkeletalMesh'M76LLI_A.M76LLI_mesh'
     Skins(0)=Texture'M76LLI_A.M76LLI_T.M76LLI_tex_1'
     Skins(1)=Texture'M76LLI_A.M76LLI_T.M76LLI_tex_2'
     Skins(2)=Texture'M76LLI_A.M76LLI_T.M76LLI_tex_3'
     Skins(3)=Texture'M76LLI_A.M76LLI_T.M76LLI_tex_4'
     Skins(4)=Texture'M76LLI_A.M76LLI_T.M76LLI_tex_5'
     Skins(5)=Texture'M76LLI_A.M76LLI_T.M76LLI_tex_6'
     Skins(6)=Texture'M76LLI_A.M76LLI_T.M76LLI_tex_7'
     Skins(7)=Texture'KF_Weapons3_Trip_T.hands.Priest_Hands_1st_P'
     SelectSound=Sound'M76LLI_A.M76LLI_SND.M76LLI_select'
     HudImage=Texture'M76LLI_A.M76LLI_T.M76LLI_Unselected'
     SelectedHudImage=Texture'M76LLI_A.M76LLI_T.M76LLI_selected'
     PlayerIronSightFOV=60.000000
     ZoomedDisplayFOV=45.000000
     FireModeClass(0)=Class'M76LLIFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="Zastava M76 - винтовка, разработанная в Югославии на базе автомата Калашникова, адаптированного под более длинные и мощные винтовочные патроны 7,92×57 мм."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=55.000000
     Priority=185
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=4
     GroupOffset=5
     PickupClass=Class'M76LLIPickup'
     PlayerViewOffset=(X=22.000000,Y=18.000000,Z=-6.000000)
     BobDamping=5.000000
     AttachmentClass=Class'M76LLIAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="Zastava M76"
     TransientSoundVolume=1.250000
}
