class G2ContenderDT extends KFWeapon;

#exec OBJ LOAD FILE=Thompson_G2_A.ukx

var color ChargeColor;
var float Range;
var float LastRangingTime;
var() Material ZoomMat;
var() Sound ZoomSound;
var bool bArrowRemoved;
var()		int			lenseMaterialID;
var()		float		scopePortalFOVHigh;
var()		float		scopePortalFOV;
var()       vector      XoffsetScoped;
var()       vector      XoffsetHighDetail;
var()		int			scopePitch;
var()		int			scopeYaw;
var()		int			scopePitchHigh;
var()		int			scopeYawHigh;
var   ScriptedTexture   ScopeScriptedTexture;
var	  Shader		    ScopeScriptedShader;
var   Material          ScriptedTextureFallback;
var     Combiner            ScriptedScopeCombiner;
var     texture             TexturedScopeTexture;
var     texture             ScopeTexture;
var	    bool				bInitializedScope;

exec function pfov(int thisFOV)
{
	if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
		return;

	scopePortalFOV = thisFOV;
}

exec function pPitch(int num)
{
	if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
		return;

	scopePitch = num;
	scopePitchHigh = num;
}

exec function pYaw(int num)
{
	if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
		return;

	scopeYaw = num;
	scopeYawHigh = num;
}

simulated exec function TexSize(int i, int j)
{
	if( !class'ROEngine.ROLevelInfo'.static.RODebugMode() )
		return;

	ScopeScriptedTexture.SetSize(i, j);
}

simulated function bool ShouldDrawPortal()
{
    if( bAimingRifle )
		return true;
	else
		return false;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

    KFScopeDetail = class'KFMod.KFWeapon'.default.KFScopeDetail;

	UpdateScopeMode();
}

simulated function UpdateScopeMode()
{
	if (Level.NetMode != NM_DedicatedServer && Instigator != none && Instigator.IsLocallyControlled() &&
		Instigator.IsHumanControlled() )
    {
	    if( KFScopeDetail == KF_ModelScope )
		{
			scopePortalFOV = default.scopePortalFOV;
			ZoomedDisplayFOV = default.ZoomedDisplayFOV;
			if (bUsingSights)
			{
				PlayerViewOffset = XoffsetScoped;
			}

			if( ScopeScriptedTexture == none )
			{
	        	ScopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
			}

	        ScopeScriptedTexture.FallBackMaterial = ScriptedTextureFallback;
	        ScopeScriptedTexture.SetSize(512,512);
	        ScopeScriptedTexture.Client = Self;

			if( ScriptedScopeCombiner == none )
			{
				ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
	            ScriptedScopeCombiner.Material1 = ScopeTexture;
	            ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
	            ScriptedScopeCombiner.CombineOperation = CO_Multiply;
	            ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
	            ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
	        }

			if( ScopeScriptedShader == none )
			{
				ScopeScriptedShader = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
				ScopeScriptedShader.Diffuse = ScriptedScopeCombiner;
				ScopeScriptedShader.SelfIllumination = ScriptedScopeCombiner;
				ScopeScriptedShader.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
			}

	        bInitializedScope = true;
		}
		else if( KFScopeDetail == KF_ModelScopeHigh )
		{
			scopePortalFOV = scopePortalFOVHigh;
			ZoomedDisplayFOV = default.ZoomedDisplayFOVHigh;
			if (bUsingSights)
			{
				PlayerViewOffset = XoffsetHighDetail;
			}

			if( ScopeScriptedTexture == none )
			{
	        	ScopeScriptedTexture = ScriptedTexture(Level.ObjectPool.AllocateObject(class'ScriptedTexture'));
	        }
			ScopeScriptedTexture.FallBackMaterial = ScriptedTextureFallback;
	        ScopeScriptedTexture.SetSize(512,512);
	        ScopeScriptedTexture.Client = Self;

			if( ScriptedScopeCombiner == none )
			{
				ScriptedScopeCombiner = Combiner(Level.ObjectPool.AllocateObject(class'Combiner'));
	            ScriptedScopeCombiner.Material1 = ScopeTexture;
	            ScriptedScopeCombiner.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
	            ScriptedScopeCombiner.CombineOperation = CO_Multiply;
	            ScriptedScopeCombiner.AlphaOperation = AO_Use_Mask;
	            ScriptedScopeCombiner.Material2 = ScopeScriptedTexture;
	        }

			if( ScopeScriptedShader == none )
			{
				ScopeScriptedShader = Shader(Level.ObjectPool.AllocateObject(class'Shader'));
				ScopeScriptedShader.Diffuse = ScriptedScopeCombiner;
				ScopeScriptedShader.SelfIllumination = ScriptedScopeCombiner;
				ScopeScriptedShader.FallbackMaterial = Shader'ScopeShaders.Zoomblur.LensShader';
			}

            bInitializedScope = true;
		}
		else if (KFScopeDetail == KF_TextureScope)
		{
			ZoomedDisplayFOV = default.ZoomedDisplayFOV;
			PlayerViewOffset.X = default.PlayerViewOffset.X;

			bInitializedScope = true;
		}
	}
}

simulated event RenderTexture(ScriptedTexture Tex)
{
    local rotator RollMod;

    RollMod = Instigator.GetViewRotation();
    if(Owner != none && Instigator != none && Tex != none && Tex.Client != none)
        Tex.DrawPortal(0,0,Tex.USize,Tex.VSize,Owner,(Instigator.Location + Instigator.EyePosition()), RollMod,  scopePortalFOV );
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


/**
 * Handles all the functionality for zooming in including
 * setting the parameters for the weapon, pawn, and playercontroller
 *
 * @param bAnimateTransition whether or not to animate this zoom transition
 */
simulated function ZoomIn(bool bAnimateTransition)
{
    super(BaseKFWeapon).ZoomIn(bAnimateTransition);

	bAimingRifle = True;

	if( KFHumanPawn(Instigator)!=None )
		KFHumanPawn(Instigator).SetAiming(True);

	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
	{
		if( AimInSound != none )
		{
            PlayOwnedSound(AimInSound, SLOT_Interact,,,,, false);
        }
	}
}

/**
 * Handles all the functionality for zooming out including
 * setting the parameters for the weapon, pawn, and playercontroller
 *
 * @param bAnimateTransition whether or not to animate this zoom transition
 */
simulated function ZoomOut(bool bAnimateTransition)
{
    super.ZoomOut(bAnimateTransition);

	bAimingRifle = False;

	if( KFHumanPawn(Instigator)!=None )
		KFHumanPawn(Instigator).SetAiming(False);

	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
	{
		if( AimOutSound != none )
		{
            PlayOwnedSound(AimOutSound, SLOT_Interact,,,,, false);
        }
        KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
	}
}

/*simulated function WeaponTick(float dt)
{
    super.WeaponTick(dt);

    if( bAimingRifle && ForceZoomOutTime > 0 && Level.TimeSeconds - ForceZoomOutTime > 0 )
    {
	    ForceZoomOutTime = 0;

    	ZoomOut(false);

    	if( Role < ROLE_Authority)
			ServerZoomOut(false);
	}
}*/


/**
 * Called by the native code when the interpolation of the first person weapon to the zoomed position finishes
 */
simulated event OnZoomInFinished()
{
    local name anim;
    local float frame, rate;

    GetAnimParams(0, anim, frame, rate);

    if (ClientState == WS_ReadyToFire)
    {
        if (anim == IdleAnim)
        {
           PlayIdle();
        }
    }

	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none &&
        KFScopeDetail == KF_TextureScope )
	{
		KFPlayerController(Instigator.Controller).TransitionFOV(PlayerIronSightFOV,0.0);
	}
}

simulated function bool CanZoomNow()
{
	Return (!FireMode[0].bIsFiring && Instigator!=None && Instigator.Physics!=PHYS_Falling);
}

simulated event RenderOverlays(Canvas Canvas)
{
    local int m;
	local PlayerController PC;

    if (Instigator == None)
        return;

	PC = PlayerController(Instigator.Controller);

	if(PC == None)
		return;

    if(!bInitializedScope && PC != none )
	{
    	  UpdateScopeMode();
    }

    Canvas.DrawActor(None, false, true);

    for (m = 0; m < NUM_FIRE_MODES; m++)
	{
        if (FireMode[m] != None)
        {
            FireMode[m].DrawMuzzleFlash(Canvas);
        }
    }


    SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
    SetRotation( Instigator.GetViewRotation() + ZoomRotInterp);

	PreDrawFPWeapon();

 	if(bAimingRifle && PC != none && (KFScopeDetail == KF_ModelScope || KFScopeDetail == KF_ModelScopeHigh))
 	{
 		if (ShouldDrawPortal())
 		{
			if ( ScopeScriptedTexture != none )
			{
				Skins[LenseMaterialID] = ScopeScriptedShader;
				ScopeScriptedTexture.Client = Self;   // Need this because this can get corrupted - Ramm
				ScopeScriptedTexture.Revision = (ScopeScriptedTexture.Revision +1);
			}
 		}

		bDrawingFirstPerson = true;
 	    Canvas.DrawBoundActor(self, false, false,DisplayFOV,PC.Rotation,rot(0,0,0),Instigator.CalcZoomedDrawOffset(self));
      	bDrawingFirstPerson = false;
	}
	else if( KFScopeDetail == KF_TextureScope && PC.DesiredFOV == PlayerIronSightFOV && bAimingRifle)
	{
		Skins[LenseMaterialID] = ScriptedTextureFallback;

		SetZoomBlendColor(Canvas);

		Canvas.Style = ERenderStyle.STY_Normal;
		Canvas.SetPos(0, 0);
		Canvas.DrawTile(ZoomMat, (Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);
		Canvas.SetPos(Canvas.SizeX, 0);
		Canvas.DrawTile(ZoomMat, -(Canvas.SizeX - Canvas.SizeY) / 2, Canvas.SizeY, 0.0, 0.0, 8, 8);

		Canvas.Style = 255;
		Canvas.SetPos((Canvas.SizeX - Canvas.SizeY) / 2,0);
		Canvas.DrawTile(ZoomMat, Canvas.SizeY, Canvas.SizeY, 0.0, 0.0, 512, 512);

		Canvas.Font = Canvas.MedFont;
		Canvas.SetDrawColor(200,150,0);

		Canvas.SetPos(Canvas.SizeX * 0.16, Canvas.SizeY * 0.43);
		Canvas.DrawText(" ");

		Canvas.SetPos(Canvas.SizeX * 0.16, Canvas.SizeY * 0.47);
	}
 	else
 	{
		Skins[LenseMaterialID] = ScriptedTextureFallback;
		bDrawingFirstPerson = true;
		Canvas.DrawActor(self, false, false, DisplayFOV);
		bDrawingFirstPerson = false;
 	}
}

simulated function AdjustIngameScope()
{
	local PlayerController PC;

	PC = PlayerController(Instigator.Controller);

	if( !bHasScope )
		return;

	switch (KFScopeDetail)
	{
		case KF_ModelScope:
			if( bAimingRifle )
				DisplayFOV = default.ZoomedDisplayFOV;
			if ( PC.DesiredFOV == PlayerIronSightFOV && bAimingRifle )
			{
            	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
            	{
                    KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
}
			}
			break;

		case KF_TextureScope:
			if( bAimingRifle )
				DisplayFOV = default.ZoomedDisplayFOV;
			if ( bAimingRifle && PC.DesiredFOV != PlayerIronSightFOV )
			{
            	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
            	{
            		KFPlayerController(Instigator.Controller).TransitionFOV(PlayerIronSightFOV,0.0);
            	}
			}
			break;

		case KF_ModelScopeHigh:
			if( bAimingRifle )
			{
				if( ZoomedDisplayFOVHigh > 0 )
					DisplayFOV = default.ZoomedDisplayFOVHigh;
				else
					DisplayFOV = default.ZoomedDisplayFOV;
			}
			if ( bAimingRifle && PC.DesiredFOV == PlayerIronSightFOV )
			{
            	if( Level.NetMode != NM_DedicatedServer && KFPlayerController(Instigator.Controller) != none )
            	{
                    KFPlayerController(Instigator.Controller).TransitionFOV(KFPlayerController(Instigator.Controller).DefaultFOV,0.0);
            	}
			}
			break;
	}

	UpdateScopeMode();
}

simulated event Destroyed()
{
    if (ScopeScriptedTexture != None)
    {
        ScopeScriptedTexture.Client = None;
        Level.ObjectPool.FreeObject(ScopeScriptedTexture);
        ScopeScriptedTexture=None;
    }

    if (ScriptedScopeCombiner != None)
    {
		ScriptedScopeCombiner.Material2 = none;
		Level.ObjectPool.FreeObject(ScriptedScopeCombiner);
		ScriptedScopeCombiner = none;
    }

    if (ScopeScriptedShader != None)
    {
		ScopeScriptedShader.Diffuse = none;
		ScopeScriptedShader.SelfIllumination = none;
		Level.ObjectPool.FreeObject(ScopeScriptedShader);
		ScopeScriptedShader = none;
    }

    Super.Destroyed();
}

simulated function PreTravelCleanUp()
{
    if (ScopeScriptedTexture != None)
    {
        ScopeScriptedTexture.Client = None;
        Level.ObjectPool.FreeObject(ScopeScriptedTexture);
        ScopeScriptedTexture=None;
    }

    if (ScriptedScopeCombiner != None)
    {
		ScriptedScopeCombiner.Material2 = none;
		Level.ObjectPool.FreeObject(ScriptedScopeCombiner);
		ScriptedScopeCombiner = none;
    }

    if (ScopeScriptedShader != None)
    {
		ScopeScriptedShader.Diffuse = none;
		ScopeScriptedShader.SelfIllumination = none;
		Level.ObjectPool.FreeObject(ScopeScriptedShader);
		ScopeScriptedShader = none;
    }
}

defaultproperties
{
     lenseMaterialID=1
     ZoomMat=FinalBlend'Thompson_G2_A.gdcw_acog_FB'
     ScriptedTextureFallback=Texture'Thompson_G2_A.alpha_lens_64x64'
	 scopePortalFOVHigh=8.000000
     scopePortalFOV=8.000000
     PlayerIronSightFOV=12.000000
     ZoomedDisplayFOVHigh=25.000000
     ZoomedDisplayFOV=25.000000
     bHasScope=True
	 ZoomTime=0.285000
     MagCapacity=1
     ReloadRate=1.376000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
	 WeaponReloadAnim="Reload_HuntingShotgun"
     Weight=2.000000
     bHasAimingMode=True
     IdleAimAnim="Iron_Idle"
     StandardDisplayFOV=55.000000
     bModeZeroCanDryFire=True
	 SleeveNum=3
     TraderInfoTexture=Texture'Thompson_G2_A.g2contender_trader'
     HudImage=Texture'Thompson_G2_A.g2contender_unselected'
     SelectedHudImage=Texture'Thompson_G2_A.g2contender_selected'
     Mesh=SkeletalMesh'Thompson_G2_A.G2ContenderMesh'
     Skins(0)=Combiner'Thompson_G2_A.Contender_diffuse_cmb'
     Skins(1)=Texture'Thompson_G2_A.alpha_lens_64x64'
     Skins(2)=Combiner'Thompson_G2_A.uv1024_cmb'
     Skins(3)=Texture'KF_Weapons2_Trip_T.hands.BritishPara_Hands_1st_P'
     Skins(4)=Combiner'Thompson_G2_A.Bullet_cmb'
     SelectSound=Sound'Thompson_G2_A.G2_Pickup'
     bIsTier2Weapon=True
     FireModeClass(0)=Class'G2ContenderDTFire'
     FireModeClass(1)=Class'NoFire'
	 PutDownAnimRate=1.000000
     AIRating=0.550000
     CurrentRating=0.550000
     Description="Thompson G2 Contender - охотничий пистолет"
     DisplayFOV=55.000000
     Priority=120
     InventoryGroup=2
     GroupOffset=14
     PickupClass=Class'G2ContenderDTPickup'
     PlayerViewOffset=(X=13.000000,Y=14.000000,Z=-5.500000)
     BobDamping=4.500000
     AttachmentClass=Class'G2ContenderDTAttachment'
	 ItemName="Thompson G2 Contender"
	 ScopeTexture=Texture'Thompson_G2_A.gdcw_acog';
}
