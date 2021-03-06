class DamTypeAUG_A1AR extends KFProjectileWeaponDamageType
	abstract;

static function AwardKill(KFSteamStatsAndAchievements KFStatsAndAchievements, KFPlayerController Killer, KFMonster Killed )
{
	if( Killed.IsA('ZombieStalker') )
		KFStatsAndAchievements.AddStalkerKill();
}

static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount)
{
	KFStatsAndAchievements.AddBullpupDamage(Amount);
}

defaultproperties
{
     HeadShotDamageMult=1.600000
     WeaponClass=Class'AUG_A1AR'
     DeathString="%k killed %o (Steyr AUG A1)."
     bRagdollBullet=True
     DamageThreshold=1
     KDamageImpulse=3000.000000
     KDeathVel=200.000000
     KDeathUpKick=20.000000
}
