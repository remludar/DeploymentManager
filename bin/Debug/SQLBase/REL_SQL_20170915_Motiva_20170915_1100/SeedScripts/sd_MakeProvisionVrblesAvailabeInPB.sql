Update	Vrble
Set		VrbleDtTyp = 'N',
		Type = 'S'
Where	VrbleNme = 'FreightPerGallon' --select * from vrble
AND		NOT EXISTS (SELECT * FROM Vrble WHERE VrbleNme = 'FreightPerGallon' AND VrbleDtTyp = 'N' AND Type = 'S')

Update	Vrble
Set		VrbleDtTyp = 'N',
		Type = 'S'
Where	VrbleNme = 'FreightFlatRate' --select * from vrble
AND		NOT EXISTS (SELECT * FROM Vrble WHERE VrbleNme = 'FreightFlatRate' AND VrbleDtTyp = 'N' AND Type = 'S')

Update	Vrble
Set		VrbleDtTyp = 'N',
		Type = 'S'
Where	VrbleNme = 'FreightMileage' --select * from vrble
AND		NOT EXISTS (SELECT * FROM Vrble WHERE VrbleNme = 'FreightMileage' AND VrbleDtTyp = 'N' AND Type = 'S')

Update	Vrble
Set		VrbleDtTyp = 'N',
		Type = 'S'
Where	VrbleNme = 'FreightFuelSurcharge'
AND		NOT EXISTS (SELECT * FROM Vrble WHERE VrbleNme = 'FreightFuelSurcharge' AND VrbleDtTyp = 'N' AND Type = 'S')

Update	Vrble
Set		VrbleDtTyp = 'X',
		Type = 'S'
Where	VrbleNme = 'PlannedTransferMOT'
AND		NOT EXISTS (SELECT * FROM Vrble WHERE VrbleNme = 'PlannedTransferMOT' AND VrbleDtTyp = 'X' AND Type = 'S')