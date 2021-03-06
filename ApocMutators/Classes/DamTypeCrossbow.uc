class DamTypeCrossbow extends KFProjectileWeaponDamageType
	abstract;

defaultproperties
{
     bSniperWeapon=True
     WeaponClass=Class'ApocMutators.HL_Crossbow'
     DeathString="%o was pinned to the wall by %k's crossbow."
     bRagdollBullet=True
     bBulletHit=True
     FlashFog=(X=600.000000)
     KDamageImpulse=3000.000000
     KDeathVel=85.000000
     KDeathUpKick=35.000000
     VehicleDamageScaling=0.050000
}
