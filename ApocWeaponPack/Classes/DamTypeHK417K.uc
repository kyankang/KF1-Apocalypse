class DamTypeHK417K extends KFProjectileWeaponDamageType;

static function AwardKill(KFSteamStatsAndAchievements KFStatsAndAchievements, KFPlayerController Killer, KFMonster Killed )
{
	if( Killed.IsA('ZombieStalker') )
		KFStatsAndAchievements.AddStalkerKill();
}

defaultproperties
{
     DeathString="%k killed %o (HK-417)."
     WeaponClass=Class'HK417'
     bSniperWeapon=True
     bRagdollBullet=True
     bBulletHit=True
     FlashFog=(X=600.000000)
     KDamageImpulse=4500.000000
     KDeathVel=200.000000
     KDeathUpKick=20.000000
     VehicleDamageScaling=0.800000
}
