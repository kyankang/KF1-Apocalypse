class HK417SwitchMessage extends CriticalEventPlus;

var() localized string SwitchMessage[10];

static function string GetString (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if ( (Switch >= 0) && (Switch <= 9) )
		return Default.SwitchMessage[Switch];
}

defaultproperties
{
     SwitchMessage(0)="Автоматический режим"
     SwitchMessage(1)="Полуавтоматический режим"
     DrawColor=(B=0,G=215,R=255)
     FontSize=1
}
