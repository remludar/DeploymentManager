Update	Vrble
Set		VrbleDtTyp = 'N',
		Type = 'S'
Where	VrbleNme = 'FreightCleaning' --select * from vrble
AND		NOT EXISTS (SELECT * FROM Vrble WHERE VrbleNme = 'FreightCleaning' AND VrbleDtTyp = 'N' AND Type = 'S')


Update	Vrble
Set		VrbleDtTyp = 'N',
		Type = 'S'
Where	VrbleNme = 'FreightMisc' --select * from vrble
AND		NOT EXISTS (SELECT * FROM Vrble WHERE VrbleNme = 'FreightMisc' AND VrbleDtTyp = 'N' AND Type = 'S')

