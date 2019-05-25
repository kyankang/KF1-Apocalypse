Class SlotMachine_UHGrenade extends SlotMachine_HGrenade;

#exec AUDIO IMPORT file="Assets\SlotMachine\UnholyBlowup.WAV" NAME="UnholyBlowup" GROUP="FX"

simulated function Explode(vector HitLocation, vector HitNormal)
{
    bHasExploded = True;

    if (Level.NetMode != NM_DedicatedServer)
        PlaySound(Sound'UnholyBlowup', SLOT_None, 2.0);
    if (Level.NetMode != NM_Client)
    {
        class'SlotMachine_GodModeCard'.default.GodModeTime=23.000000;
        for (C=Level.ControllerList; C != None; C=C.nextController)
        {
            if (C.bIsPlayer && C.Pawn != None && C.Pawn.Health > 0 && PlayerController(C) != None)
            {
                KFPlayerController(C).Pawn.Spawn(class'SlotMachine_GodModeClient', KFPlayerController(C).Pawn);
                PlayerController(KFPlayerController(C).Pawn.Controller).ReceiveLocalizedMessage(class'SlotMachine_GodModeMessage');
            }
        }
        class'SlotMachine_GodModeCard'.default.GodModeTime=40.000000;

        Spawn(Class'SlotMachine_BlackHoleProj');
    }

    Destroy();
}

defaultproperties
{
     Skins(0)=Texture'ApocMutators.UnholyGrenade'
}
