class M249Pickup extends KFWeaponPickup;

defaultproperties
{
     Weight=9.000000
     cost=4000
     AmmoCost=10
     BuyClipSize=30
     PowerValue=42
     SpeedValue=90
     RangeValue=50
     Description="Легкий (ручной) пулемет, состоит на вооружении многих стран, в том числе в США (под обозначением M249 SAW), Канаде (обозначается С9), Австралии (обозначается F-89) и других."
     ItemName="M249 SAW"
     ItemShortName="M249 SAW"
     AmmoItemName="Патроны 5,56mm NATO"
     Mesh=SkeletalMesh'm249_A.m249_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'M249'
     PickupMessage="Вы подобрали M249 SAW"
     PickupSound=Sound'M249_Snd.m249_pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'M249_SM.M249_ST'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
