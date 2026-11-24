class MutForceWeaponView extends mutator config(ForceWeaponView);

var config array<name> ForceSmallWeaponsOff[25];
var config array<name> ForceThirdPerson[25];

replication
{
    // Replicate these variables to all clients
    reliable if (bNetDirty && Role == ROLE_Authority)
        ForceSmallWeaponsOff, ForceThirdPerson;
}

simulated function postbeginplay()
{
super.postbeginplay();
}

simulated function tick(float dt)
{
    local PlayerController PC;
    local int i, j;

    PC = Level.GetLocalPlayerController();

    if(PC != None && PC.Pawn != None && PC.Pawn.Weapon != None)
    {
        // 1. Check Small Weapons
        PC.bSmallWeapons = true; // Default state if no match is found
        for(i = 0; i < ArrayCount(ForceSmallWeaponsOff); i++)
        {
            if(PC.Pawn.Weapon.IsA(ForceSmallWeaponsOff[i]))
            {
                PC.bSmallWeapons = false;
                break; // Stop looping immediately
            }
        }
        // Weapon.uc reads the class default, not the instance, so set both
        class'PlayerController'.default.bSmallWeapons = PC.bSmallWeapons;
        PC.SaveConfig(); // Saved once outside the loop to prevent performance stutter

        // 2. Check Third Person View
        PC.bBehindView = false; // Default state if no match is found
        for(j = 0; j < ArrayCount(ForceThirdPerson); j++)
        {
            if(PC.Pawn.Weapon.IsA(ForceThirdPerson[j]))
            {
                PC.bBehindView = true;
                break; // Stop looping immediately
            }
        }
    }
super.tick(dt);
}

defaultproperties
{
bAlwaysRelevant=true
RemoteRole=Role_SimulatedProxy
ForceSmallWeaponsOff(0)=SomeWeapon
ForceThirdPerson(0)=SomeWeapon
FriendlyName="Force Weapon View"
}