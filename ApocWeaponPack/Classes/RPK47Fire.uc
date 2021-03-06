class RPK47Fire extends KFFire;

defaultproperties
{
     FireAimedAnim="Fire_Iron"
     RecoilRate=0.070000
     maxVerticalRecoilAngle=500
     maxHorizontalRecoilAngle=250
     bRecoilRightOnly=True
     ShellEjectClass=Class'ROEffects.KFShellEjectAK'
     ShellEjectBoneName="Shell_eject"
     bAccuracyBonusForSemiAuto=True
     bRandomPitchFireSound=False
     FireSound=Sound'RPK47_A.rpk47_shoot'
     StereoFireSound=Sound'RPK47_A.rpk47_shoot'
     NoAmmoSound=Sound'RPK47_A.RPK47_empty'
     DamageType=Class'DamTypeRPK47'
     DamageMin=70 //35 //kyan
     DamageMax=75 //50
     Momentum=9500.000000
     bPawnRapidFireAnim=True
     TransientSoundVolume=3.800000
     FireLoopAnim="Fire"
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.109000
     AmmoClass=Class'RPK47Ammo'
     AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=350.000000)
     ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
     BotRefireRate=0.990000
     FlashEmitterClass=Class'ROEffects.MuzzleFlash1stMP'
     aimerror=42.000000
     Spread=0.015000
     SpreadStyle=SS_Random
}
