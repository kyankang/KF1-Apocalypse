class PKMFire extends KFFire;

defaultproperties
{
     FireAimedAnim="Fire"
     RecoilRate=0.070000
     maxVerticalRecoilAngle=600
     maxHorizontalRecoilAngle=250
     bRecoilRightOnly=True
     ShellEjectClass=Class'PKMKFShellEject'
     ShellEjectBoneName="Shell_13"
     bAccuracyBonusForSemiAuto=True
     bRandomPitchFireSound=False
     FireSound=Sound'PKM_SN.pkm_shoot_mono'
     StereoFireSound=Sound'PKM_SN.pkm_shoot_stereo'
     NoAmmoSound=Sound'PKM_SN.pkm_empty'
     DamageType=Class'DamTypePKM'
     DamageMin=60 //45 //kyan
     DamageMax=65 //55
     Momentum=8500.000000
     bPawnRapidFireAnim=True
     TransientSoundVolume=3.000000
     FireLoopAnim="Fire"
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.095000
     AmmoClass=Class'PKMAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=350.000000)
     ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
     BotRefireRate=0.990000
     FlashEmitterClass=Class'PKMMuzzleFlash1st'
     aimerror=42.000000
     Spread=0.030000
     SpreadStyle=SS_Random
}
