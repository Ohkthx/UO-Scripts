// Created by: Schism (d0x1p2)
// Date created: 15NOV2017
// Version: 1.0
// keepBandaging will continously bandage your character when below max health.
function keepBandaging() {
	Orion.ClearJournal();
	var bandageStart = Orion.Now();
	var bandageComplete = "You finish|You Heal|You apply|You cannot|spared death"
	
	while(true) {
		if (Player.Hits() < Player.MaxHits()) {
			if (!Orion.InJournal("You begin", 'my|sys', '0', '0xFFFF', bandageStart+1000, Orion.Now())) {
				 // If there isn't a started bandage, start one.
				bandageStart = Orion.Now();
				Orion.BandageSelf();
				Orion.Wait(250);
				
				if (Orion.WaitJournal(bandageComplete, bandageStart, bandageStart+30000, 'my|sys')) {}
				Orion.Wait(250);
			} 
		}	
	}
}