class PKMPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=10.000000
     cost=3500
     AmmoCost=10
     BuyClipSize=50
     PowerValue=43
     SpeedValue=80
     RangeValue=50
     Description="Standard issue military rifle. Equipped with an integrated 2X scope."
     ItemName="PKM SAW"
     ItemShortName="PKM SAW"
     AmmoItemName="Патроны 7.62мм"
     Mesh=SkeletalMesh'Pkm_A.pkm3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'PKM'
     PickupMessage="Вы подобрали PKM SAW"
     PickupSound=Sound'PKM_SN.pkm_holster'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'Pkm_SM.Rifle.PkmSM'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
